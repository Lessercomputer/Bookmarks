#import "ATFirefoxBookmarksImporter.h"
#import "ATBookmark.h"
#import "ATBinder.h"
#import "ATBookmarks.h"
#import "ATNetscapeBookmarkFile1Scanner.h"
#import "ATNetscapeBookmarkFile1DocumentEntity.h"
#import "ATElement.h"
#import "ATBookmarksDocument.h"
#import "ATBase64Decoder.h"

@implementation ATFirefoxBookmarksImporter

+ (id)importerWithDocument:(ATBookmarksDocument *)aDocument
{
	return [[[self alloc] initWithDocument:aDocument] autorelease];
}

- (id)initWith:(NSString *)aBookmarksFilePath bookmarks:(ATBookmarks *)aBookmarks
{
	[super init];
	
	bookmarks = aBookmarks;
	bookmarksFilePath = [aBookmarksFilePath copy];
	
	[self setProcessDescription:NSLocalizedString(@"Loading a Bookmarks File ...", nil)];
	
	return self;
}

- (id)initWithDocument:(ATBookmarksDocument *)aDocument
{
	[self initWith:nil bookmarks:[aDocument bookmarks]];
	
	document = aDocument;
	
	return self;
}

- (void)dealloc
{	
	[bookmarksFilePath release];
	[bookmarksFileData release];
	[bookmarksDocumentEntity release];
	[root release];
	[foldersBeingBuilt release];
	[self setCurrentItemName:nil];
	[currentItemNameForBinding release];
	currentItemNameForBinding = nil;
	[convertingProgressDescription release];
	convertingProgressDescription = nil;
	[nextBindingValueUpdatingDate release];
	[processDescription release];
	processDescription = nil;
	
	NSLog(@"ATFirefoxBookmarksImporter dealloc");
	
	[super dealloc];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
	if ([key isEqualToString:@"currentItemName"])
		return NO;
	else
		return [super automaticallyNotifiesObserversForKey:key];
}

@end

@implementation ATFirefoxBookmarksImporter (Accessing)

- (NSString *)currentItemName
{
	return currentItemName;
}

- (void)setCurrentItemName:(NSString *)aString
{
	[currentItemName release];
	currentItemName = [aString copy];
}

- (NSString *)currentItemNameForBinding
{
	return currentItemNameForBinding;
}

- (void)setCurrentItemNameForBinding:(NSString *)aString
{
	[currentItemNameForBinding release];
	currentItemNameForBinding = [aString copy];
}

- (NSUInteger)countOfItems
{
	return countOfItems;
}

- (void)setCountOfItems:(NSUInteger)aCount
{
	countOfItems = aCount;
}

- (NSUInteger)countOfConvertedItems
{
	return countOfConvertedItems;
}

- (void)setCountOfConvertedItems:(NSUInteger)aCount
{
	countOfConvertedItems = aCount;
}

- (NSString *)convertingProgressDescription
{
	return convertingProgressDescription;
}

- (void)setConvertingProgressDescription:(NSString *)aString
{
	[convertingProgressDescription release];
	convertingProgressDescription = [aString copy];
}

- (void)updateBindingValueIfNeeded
{
	if (!nextBindingValueUpdatingDate || ([nextBindingValueUpdatingDate timeIntervalSinceNow] < 0))
	{
		[self performSelectorOnMainThread:@selector(setCurrentItemNameForBinding:) withObject:currentItemName waitUntilDone:YES];
		[self performSelectorOnMainThread:@selector(setConvertingProgressDescription:) withObject:[NSString stringWithFormat:@"%u / %u", countOfConvertedItems, countOfItems] waitUntilDone:YES];
		
		[nextBindingValueUpdatingDate release];
		nextBindingValueUpdatingDate = [[NSDate dateWithTimeIntervalSinceNow:0.001] retain];
	}
}

- (NSString *)processDescription
{
	return processDescription;
}

- (void)setProcessDescription:(NSString *)aString
{
	[processDescription release];
	processDescription = [aString copy];
}

- (enum ATFirefoxBookmarksImporterStatus)status
{
	enum ATFirefoxBookmarksImporterStatus aStatus = 0;
	
	[statusLock lock];
	aStatus = status;
	[statusLock unlock];
	
	return aStatus;
}

- (BOOL)isRunning
{
	enum ATFirefoxBookmarksImporterStatus aStatus = [self status];
	
	return (aStatus == ATFirefoxBookmarksImporterIsConverting) || (aStatus == ATFirefoxBookmarksImporterIsParsing);
}

@end

@implementation ATFirefoxBookmarksImporter (Importing)

- (void)importInBackgroundFromFileSelectedByUser
{
	[self retain];
	[[NSOpenPanel openPanel] beginSheetForDirectory:nil file:nil types:[NSArray arrayWithObject:@"html"] modalForWindow:[document windowForSheet] modalDelegate:self didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)importInBackground
{
	statusLock = [[NSLock alloc] init];
	
	status = ATFirefoxBookmarksImporterIsLoadingFile;
	
	[NSBundle loadNibNamed:@"ATFirefoxBookmarksImporter" owner:self];
	[panel makeKeyAndOrderFront:nil];
	
	[NSThread detachNewThreadSelector:@selector(importUsingThread) toTarget:self withObject:nil];
	
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
}


- (void)importUsingThread
{
	NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
	
	[self loadBookmarksFile];
	[self parse];
	[self convert];
	
	[aPool release];
	
	[statusLock release];
	statusLock = nil;
	
	[NSThread exit];
}

- (void)loadBookmarksFile
{
	[self startLoadingBookmarksFile];
	
	while (([self status] == ATFirefoxBookmarksImporterIsLoadingFile) && ([self status] != ATFirefoxBookmarksImporterIsCanceled))
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
}	

- (void)startLoadingBookmarksFile
{
	unsigned aFileSize = 0;
	
	[statusLock lock];
	
	if (status != ATFirefoxBookmarksImporterIsCanceled)
		status = ATFirefoxBookmarksImporterIsLoadingFile;
		
	[statusLock unlock];
	
	aFileSize = [[[[NSFileManager defaultManager] fileAttributesAtPath:bookmarksFilePath traverseLink:NO] objectForKey:NSFileSize] unsignedIntegerValue];
	bookmarksFileData = [[NSMutableData alloc] initWithLength:aFileSize];
	bookmarksInputStream = [[NSInputStream alloc] initWithFileAtPath:bookmarksFilePath];

    [bookmarksInputStream setDelegate:self];

    [bookmarksInputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    [bookmarksInputStream open];
}

- (void)parse
{
	[statusLock lock];
	
	if (status != ATFirefoxBookmarksImporterIsCanceled)
	{
		BOOL aParsingSucceed = NO;
		NSString *aBookmarksString = nil;
		
		status = ATFirefoxBookmarksImporterIsParsing;
		
		[statusLock unlock];

		[self performSelectorOnMainThread:@selector(setProcessDescription:) withObject:NSLocalizedString(@"Initializing String ...", nil) waitUntilDone:YES];
		aBookmarksString = [[[NSString alloc] initWithData:bookmarksFileData encoding:NSUTF8StringEncoding] autorelease];
		[self performSelectorOnMainThread:@selector(setProcessDescription:) withObject:NSLocalizedString(@"Parsing Firefox Bookmarks ...", nil) waitUntilDone:YES];
		bookmarksDocumentEntity = [[ATNetscapeBookmarkFile1DocumentEntity alloc] initWithString:aBookmarksString];
		aParsingSucceed = [bookmarksDocumentEntity parse];
		
		if (!aParsingSucceed)
		{
			[statusLock lock];
			
			if (status != ATFirefoxBookmarksImporterIsCanceled)
			{
				status = ATFirefoxBookmarksImporterParsingFailed;
				NSLog(@"Firefox Bookmarks Importing Failed.");
			}
			
			[statusLock unlock];
		}
	}
	else
		[statusLock unlock];
}

- (void)convert
{
	NSEnumerator *anEnumerator = nil;
	ATElement *anElement = nil;
	unsigned aCount;
	ATItem *aPreviousItem = nil;

	[statusLock lock];
	
	if (status == ATFirefoxBookmarksImporterIsParsing)
		status = ATFirefoxBookmarksImporterIsConverting;
		
	[statusLock unlock];
	
	anEnumerator = [bookmarksDocumentEntity objectEnumerator];
	root = [ATBinder new];
	foldersBeingBuilt = [[NSMutableArray alloc] initWithObjects:root, nil];
	
	[root setName:@"FirefoxBookmarks"];
	
	[self performSelectorOnMainThread:@selector(setProcessDescription:) withObject:NSLocalizedString(@"Converting Firefox Bookmarks ...", nil) waitUntilDone:YES];
	
	aCount = [bookmarksDocumentEntity countOfElementNamed:@"H3"] + [bookmarksDocumentEntity countOfElementNamed:@"A"];
	[self setCountOfItems:aCount];
	
	while (([self status] != ATFirefoxBookmarksImporterIsCanceled) && (anElement = [anEnumerator nextObject]))
	{
		NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
		
		if ([anElement nameIs:@"A"])
		{
			ATBookmark *aBookmark = [[ATBookmark new] autorelease];
			NSString *anIconDataType = nil;
			NSString *anAddDateString = [[anElement attributeList] objectForKey:@"ADD_DATE"];
			NSString *aLastVisitDateString = [[anElement attributeList] objectForKey:@"LAST_VISIT"];
			NSString *aLastModifiedDateString = [[anElement attributeList] objectForKey:@"LAST_MODIFIED"];
			
			[aBookmark setName:[anElement content]];
			[aBookmark setUrlString:[[anElement attributeList] objectForKey:@"HREF"]];
			[aBookmark setIconData:[self iconDataFrom:anElement type:&anIconDataType]];
			[aBookmark setIconDataType:anIconDataType];
			if (anAddDateString)
				[aBookmark setAddDate:[NSDate dateWithTimeIntervalSince1970:[anAddDateString intValue]]];
			if (aLastVisitDateString)
				[aBookmark setLastVisitDate:[NSDate dateWithTimeIntervalSince1970:[aLastVisitDateString intValue]]];
			if (aLastModifiedDateString)
				[aBookmark setLastModifiedDate:[NSDate dateWithTimeIntervalSince1970:[aLastModifiedDateString intValue]]];
			[[foldersBeingBuilt lastObject] add:aBookmark];
			
			aPreviousItem = aBookmark;
			
			[self setCurrentItemName:[aBookmark name]];
			++countOfConvertedItems;
			[self updateBindingValueIfNeeded];
		}
		else if ([anElement nameIs:@"H3"])
		{
			ATBinder *aFolder = [[ATBinder new] autorelease];
			NSString *anAddDateString = [[anElement attributeList] objectForKey:@"ADD_DATE"];
			
			[aFolder setName:[anElement content]];
			if (anAddDateString)
				[aFolder setAddDate:[NSDate dateWithTimeIntervalSince1970:[anAddDateString intValue]]];
			[[foldersBeingBuilt lastObject] add:aFolder];
			[foldersBeingBuilt addObject:aFolder];
			
			aPreviousItem = aFolder;
			
			[self setCurrentItemName:[aFolder name]];
			++countOfConvertedItems;
			[self updateBindingValueIfNeeded];
		}
		else if ([anElement nameIs:@"DL"])
		{
			[anEnumerator nextObject];//DL要素の最初のP要素を読み飛ばす
		}
		else if ([anElement nameIs:@"P"])//現在のフォルダの終わり
		{
			[foldersBeingBuilt removeLastObject];
		}
		else if ([anElement nameIs:@"DD"])
		{
			[aPreviousItem setComment:[anElement content]];
		}
		
		[aPool release];
	}
	
	[statusLock lock];
	
	if (status != ATFirefoxBookmarksImporterIsCanceled)
		status = ATFirefoxBookmarksImporterSucceed;
		
	[statusLock unlock];
}

/*
	"data:image/x-icon;base64,"
	"data:image/bmp;base64,"
*/
- (NSData *)iconDataFrom:(ATElement *)aAElement type:(NSString **)aType
{
	NSString *anIconLit = [[aAElement attributeList] objectForKey:@"ICON"];
	NSData *anIconData = nil;	
	
	if (anIconLit)
	{
		NSScanner *aScanner = [NSScanner scannerWithString:anIconLit];

		if ([aScanner scanUpToString:@"/" intoString:nil] && [aScanner scanString:@"/" intoString:nil])
		{
			NSString *anIconDataType = nil;
			
			if ([aScanner scanUpToString:@";" intoString:&anIconDataType] && [aScanner scanString:@";" intoString:nil])
			{
				if ([aScanner scanUpToString:@"," intoString:nil] && [aScanner scanString:@"," intoString:nil])
				{
					NSString *aBase64String = [anIconLit substringFromIndex:[aScanner scanLocation]];
					NSData *aBase64Data = [aBase64String dataUsingEncoding:NSASCIIStringEncoding];

					anIconData = [[[[ATBase64Decoder alloc] initWith:aBase64Data] autorelease] decode];
					*aType = anIconDataType;
				}
			}
		}
	}
	
	return anIconData;
}

- (void)update:(NSTimer *)aTimer
{	
	if (![self isRunning])
	{
		[aTimer invalidate];
		[panel close];
		panel = nil;
		[controller release];
		controller = nil;
		
		if ([self status] == ATFirefoxBookmarksImporterSucceed)
			[bookmarks add:root];
		
		[document importerImportingFinished:self];
		
		[self release];
	}
}

- (IBAction)cancel:(id)sender
{
	[self cancel];
}

- (void)cancel
{
	[statusLock lock];
	status = ATFirefoxBookmarksImporterIsCanceled;
	[statusLock unlock];
	
	document = nil;
}

- (BOOL)windowShouldClose:(id)sender
{
	[self cancel];
	panel = nil;
	
	return YES;
}

- (void)openPanelDidEnd:(NSOpenPanel *)aPanel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if (returnCode == NSOKButton)
	{
		bookmarksFilePath = [[aPanel filename] copy];
		[self importInBackground];
	}
	else
		[self release];
}


- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode)
	{
        case NSStreamEventHasBytesAvailable:
        {
			int len = 0;
			uint8_t *aBytes = [bookmarksFileData mutableBytes];
			unsigned aMaxLength = (([bookmarksFileData length] - bytesRead) < 1024) ? [bookmarksFileData length] - bytesRead : 1024;

            len = [(NSInputStream *)stream read:&aBytes[bytesRead] maxLength:aMaxLength];

            if(len)
                bytesRead += len;
			else
                NSLog(@"no read bytes");

            break;
        }
		case NSStreamEventEndEncountered:
		{
			[statusLock lock];
			
			if (status != ATFirefoxBookmarksImporterIsCanceled)
				status = ATFirefoxBookmarksImporterLoadingFinished;
			
			[statusLock unlock];
			
			[bookmarksInputStream close];

            [bookmarksInputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

            [bookmarksInputStream release];

            bookmarksInputStream = nil;

            break;
		}
	}
}


@end