//
//  BookmarksDocument.m
//  Bookmarks
//
//  Created by Akifumi Takata on 05/10/11.
//  Copyright Nursery-Framework 2005 . All rights reserved.
//

#import "ATBookmarksDocument.h"
#import "ATBookmarksWindowController.h"
#import "ATFirefoxHTMLBookmarksImporter.h"
#import "ATBookmarks.h"
#import "ATBookmarksHome.h"
#import "ATBookmarksPresentation.h"
#import "ATIDPool.h"
#import <Nursery/NUMainBranchNursery.h>
#import "ATInspectorWindowController.h"
#import "ATItem.h"
#import "ATBinder.h"
#import "ATEditor.h"
#import "ATSafariBookmarksImporter.h"
#import "ATFirefoxBookmarksImporter.h"
#import "ATChromeBookmarksImporter.h"
#import "ATDocumentPreferences.h"
#import "ATDocumentPreferencesWindowController.h"
#import "ATWebIconLoaderWindowController.h"

@implementation ATBookmarksDocument

- (id)init
{
    self = [super init];
    if (self) {
        [self setBookmarksHome:[ATBookmarksHome bookmarksHome]];
		importers = [NSMutableArray new];
    }
    return self;
}

- (BOOL)writeSafelyToURL:(NSURL *)anAbsoluteURL ofType:(NSString *)aTypeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outError
{
    if ([aTypeName isEqualToString:@"BookmarksDocumentInNursery"] || [aTypeName isEqualToString:@"org.nursery-framework.bookmarksn"])
    {
        if (![[anAbsoluteURL scheme] isEqualToString:@"nursery"])
        {
            if (![(NUMainBranchNursery *)[self nursery] filePath])
                [(NUMainBranchNursery *)[self nursery] setFilePath:[anAbsoluteURL path]];
        }
        
        [[self bookmarksHome] setWindowSettings:[self windowSettingsForNursery]];
        
#ifdef DEBUG
        [[self bookmarks] kidnapWithRoots:[self rootBindersForBookmarksPresentation]];
#endif
        
        NUFarmOutStatus aFarmOutStatus = [[[self bookmarksHome] garden] farmOut];
        return aFarmOutStatus == NUFarmOutStatusSucceeded;
    }
    else
    {
        return [super writeSafelyToURL:anAbsoluteURL ofType:aTypeName forSaveOperation:saveOperation error:outError];
    }
    
    return NO;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError * _Nullable *)outError
{
    if ([typeName isEqualToString:@"BookmarksDocumentInNursery"] || [typeName isEqualToString:@"org.nursery-framework.bookmarksn"])
    {
        NUNursery *aNursery = nil;
        NUGarden *aGarden = nil;
        
        if ([[url scheme] isEqualToString:@"nursery"])
        {
            aNursery = [NUBranchNursery branchNurseryWithServiceName:[url path]];
        }
        else
        {
            aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:[url path]];
        }
        
        NSLog(@"%@", aNursery);
        aGarden = [aNursery makeGarden];
        id aNurseryRoot = [aGarden root];
        
        if ([aNurseryRoot isKindOfClass:[ATBookmarksHome class]])
        {
            [self setBookmarksHome:aNurseryRoot];
            [self bookmarksHome];
            
            [[self bookmarksHome] setNursery:aNursery];
            [[self bookmarksHome] setGarden:aGarden];
//            [[self bookmarksHome] setbaseGarden:[aNursery createSandboxWithGrade:[[aNursery garden] grade]]];
            [self bookmarks];
            
            return [self bookmarksHome] ? YES : NO;
//            return NO;
        }
        else if ([aNurseryRoot isKindOfClass:[NSDictionary class]])
        {
            [[self bookmarksHome] setBookmarks:aNurseryRoot[@"Bookmarks"]];
            [[self bookmarksHome] setNursery:aNursery];
            [[self bookmarksHome] setGarden:aGarden];
            [[[self bookmarksHome] bookmarks] setDocument:self];
            [self setUndoManager:[[self bookmarks] undoManager]];
            
            return YES;
        }
        else
            return NO;
    }
    else
        return [super readFromURL:url ofType:typeName error:outError];
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
#ifdef DEBUG
    [[self bookmarks] kidnapWithRoots:[self rootBindersForBookmarksPresentation]];
#endif
    
	NSMutableDictionary *aPlist = [[self bookmarks] propertyListRepresentation];
	
	[aPlist setObject:[self windowSettings] forKey:@"windowSettings"];
	
    return [NSPropertyListSerialization dataFromPropertyList:aPlist format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];//[[self bookmarks] serializedPropertyListRepresentation];
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
	NSDictionary *aPlist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
	
	[self setBookmarks:[ATBookmarks bookmarksWithArchive:aPlist]];
	savedWindowFrame = [aPlist[@"windowSettings"][@"savedWindowFrame"] copy];
	
	return [self bookmarks] ? YES : NO;
}

- (BOOL)revertToContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	BOOL aReverted = [super revertToContentsOfURL:absoluteURL ofType:typeName error:outError];
	   
    NSArray *anOldWindowControllers = [[[self windowControllers] copy] autorelease];
    
    if (aReverted)
        [self cancelWebIconLoaderIfNeeded];
    
    [anOldWindowControllers enumerateObjectsUsingBlock:^(NSWindowController *aWindowController, NSUInteger idx, BOOL *stop) {
        [self removeWindowController:aWindowController];
    }];
    
    [self makeWindowControllers];
    [self showWindows];

	return aReverted;
}

- (void)makeWindowControllers
{
	inMakingWindowControllers = YES;
	
    id aRoot = [[[self bookmarksHome] garden] root];
    NSDictionary *aWindowSettingsForNursery = nil;
    
    if ([aRoot isKindOfClass:[NSDictionary class]])
        aWindowSettingsForNursery = [(NSDictionary *)aRoot objectForKey:@"windowSettings"];
    else
        aWindowSettingsForNursery = [aRoot windowSettings];

	if (aWindowSettingsForNursery)
    {
        NSArray *aWindowFramesAndPresentations = [aWindowSettingsForNursery objectForKey:@"windowFramesAndPresentations"];
        
        [aWindowFramesAndPresentations enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *aDictionary, NSUInteger idx, BOOL *stop)
        {
            ATBookmarksWindowController *aWindowController = [ATBookmarksWindowController controllerWithPresentation:[aDictionary objectForKey:@"presentation"] windowIndex:++windowIndex home:[self bookmarksHome]];
            [aWindowController setShouldCascadeWindows:NO];
            [[aWindowController window] setFrameFromString:[aDictionary objectForKey:@"frame"]];
            [self addWindowController:aWindowController];
            //[aWindowController showWindow:nil];
        }];
    }
    else
    {
        ATBookmarksPresentation *aPresentaion = [[self bookmarksHome] makeBookmarksPresentation];
        ATBookmarksWindowController *aWindowController = [ATBookmarksWindowController controllerWithPresentation:aPresentaion windowIndex:++windowIndex home:[self bookmarksHome]];
        
        if (savedWindowFrame)
        {
            [aWindowController setShouldCascadeWindows:NO];
            [[aWindowController window] setFrameFromString:savedWindowFrame];
            [savedWindowFrame release];
            savedWindowFrame = nil;
        }
        
        [self addWindowController:aWindowController];
    }

	inMakingWindowControllers = NO;
}

- (void)showWindows
{
    [[self windowControllers] enumerateObjectsUsingBlock:^(NSWindowController *aWinController, NSUInteger idx, BOOL *stop) {
        //[aWinController showWindow:nil];
        [[aWinController window] makeKeyAndOrderFront:nil];
    }];
}

- (void)openWindowWith:(ATBookmarksPresentation *)aPresentation
{
	[self addWindowController:[ATBookmarksWindowController controllerWithPresentation:aPresentation windowIndex:++windowIndex home:[self bookmarksHome]]];
	[[[self windowControllers] lastObject] showWindow:nil];
}

- (void)openWindowFor:(ATBinder *)aBinder
{
    ATBookmarksPresentation *aPresentation = [[self bookmarksHome] makeBookmarksPresentation];

	[aPresentation setRoot:aBinder];
	[self addWindowController:[ATBookmarksWindowController controllerWithPresentation:aPresentation windowIndex:++windowIndex home:[self bookmarksHome]]];
	[[[self windowControllers] lastObject] showWindow:nil];
}

- (void)openInspectorWindowFor:(NSArray *)anEditors bookmarksWindowController:(ATBookmarksWindowController *)aBookmarksWindowController
{
    __block NSPoint aTopLeft = NSZeroPoint;
    
    [anEditors enumerateObjectsUsingBlock:^(ATEditor *anEditor, NSUInteger idx, BOOL *stop) {
        
        ATInspectorWindowController *anInspectorWindowController = [self inspectorWindowControllerForEditor:anEditor];
        
        if (!anInspectorWindowController)
        {
            NSString *aWindowNibName = [[anEditor item] isBookmark] ? @"ATBookmarkInspectorWindow" : @"ATBinderInspectorWindow";
            
            anInspectorWindowController = [[[ATInspectorWindowController alloc] initWith:anEditor windowNibName:aWindowNibName] autorelease];
            [self addWindowController:anInspectorWindowController];
            
            if (NSEqualPoints(aTopLeft, NSZeroPoint))
            {
                aTopLeft = [[aBookmarksWindowController window] frame].origin;
                aTopLeft.y += [[aBookmarksWindowController window] frame].size.height;
            }
            
            aTopLeft = [[anInspectorWindowController window] cascadeTopLeftFromPoint:aTopLeft];
            [[anInspectorWindowController window] setFrameTopLeftPoint:aTopLeft];
        }
        
        [anInspectorWindowController showWindow:nil];
    }];
}

- (ATInspectorWindowController *)inspectorWindowControllerForEditor:(ATEditor *)anEditor
{
    __block ATInspectorWindowController *anInspectorWindowController = nil;
    
    [[self windowControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ATInspectorWindowController class]]
            && [[[obj editor] item] isEqual:[anEditor item]])
        {
            anInspectorWindowController = obj;
            *stop = YES;
        }
    }];

    return anInspectorWindowController;
}

- (NSArray *)bookmarksWindowControllers
{
    NSMutableArray *aWindowControllers = [NSMutableArray array];
    
    [[self windowControllers] enumerateObjectsUsingBlock:^(NSWindowController *aWindowController, NSUInteger idx, BOOL *stop)
    {
        if ([aWindowController isKindOfClass:[ATBookmarksWindowController class]])
            [aWindowControllers addObject:aWindowController];
    }];
    
    return aWindowControllers;
}

- (NSDictionary *)windowSettings
{
	return [NSDictionary dictionaryWithObject:[[[[self windowControllers] objectAtIndex:0] window] stringWithSavedFrame] forKey:@"savedWindowFrame"];
}

- (NSDictionary *)windowSettingsForNursery
{
    NSMutableDictionary *aDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *aWindowFramesAndPresentations = [NSMutableArray array];
    
    [[self orderedWindows] enumerateObjectsUsingBlock:^(NSWindow *aWindow, NSUInteger idx, BOOL *stop)
    {
        if ([[aWindow windowController] isKindOfClass:[ATBookmarksWindowController class]])
        {
            ATBookmarksPresentation *aPresentation = [[aWindow windowController] bookmarksPresentation];
            NSDictionary *aWindowFrameAndPresentation = [NSDictionary dictionaryWithObjectsAndKeys:aPresentation,@"presentation", [aWindow stringWithSavedFrame],@"frame", nil];
            [aWindowFramesAndPresentations addObject:aWindowFrameAndPresentation];
        }
    }];
    
    [aDictionary setObject:aWindowFramesAndPresentations forKey:@"windowFramesAndPresentations"];
    
    return aDictionary;
}

- (void)importBookmarksUsingImporter:(ATBookmarksImporter *)anImporter
{
    NSOpenPanel *anOpenPanel = [NSOpenPanel openPanel];
    NSString *aBookmarksFilepath = [anImporter defaultBookmarksFilepath];
    NSURL *aPreviousDirectoryURL = [[[anOpenPanel directoryURL] copy] autorelease];
    [anOpenPanel setDirectoryURL:[NSURL fileURLWithPath:aBookmarksFilepath]];
    
    if ([[aBookmarksFilepath pathExtension] length])
        [anOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:[aBookmarksFilepath pathExtension]]];
    
    [anOpenPanel beginSheetModalForWindow:[self windowForSheet] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
        {
            ATBinder *aBinder = [anImporter importBookmarksFromContentsOfFile:[[anOpenPanel URL] path]];
            NSArray *anItem = [NSArray arrayWithObject:aBinder];
            ATBinder *aRoot = [[self bookmarks] root];
            [[self bookmarks] insertItems:anItem to:[aRoot count] of:aRoot contextInfo:nil];
        }
        [anOpenPanel setDirectoryURL:aPreviousDirectoryURL];
        [anOpenPanel orderOut:nil];
    }];
}

- (void)preferencesDidChangeNotification:(NSNotification *)aNotification
{
    [self updateChangeCount:NSChangeDone];
}

- (void)shouldCloseWindowController:(NSWindowController *)aWindowController delegate:(id)aDelegate shouldCloseSelector:(SEL)aShouldCloseSelector contextInfo:(void *)aContextInfo
{
    if ([self bookmarksWindowCount] == 1 && [aWindowController isKindOfClass:[ATBookmarksWindowController class]])
    {
        [aWindowController setShouldCloseDocument:YES];
        __block void *aContextInfoInBlock = aContextInfo;
        __block id aSelfInBlock = self;
        
        void (^aBlock)(BOOL) = ^(BOOL aCanCloseDocument) {
            NSInvocation *anInvocation = [NSInvocation invocationWithMethodSignature:[aDelegate methodSignatureForSelector:aShouldCloseSelector]];
            [anInvocation setSelector:aShouldCloseSelector];
            [anInvocation setArgument:&aSelfInBlock atIndex:2];
            [anInvocation setArgument:&aCanCloseDocument atIndex:3];
            [anInvocation setArgument:&aContextInfoInBlock atIndex:4];
            [anInvocation invokeWithTarget:aDelegate];
            [aWindowController setShouldCloseDocument:NO];
        };
        
        [self canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(document:shouldClose:contextInfo:) contextInfo:[aBlock copy]];
    }
    else
        [super shouldCloseWindowController:aWindowController delegate:aDelegate shouldCloseSelector:aShouldCloseSelector contextInfo:aContextInfo];
}

- (void)document:(NSDocument *)aDocument shouldClose:(BOOL)aShouldClose  contextInfo:(void  *)aContextInfo
{
    void (^aBlock)(BOOL) = aContextInfo;
    aBlock(aShouldClose);
    
    [aBlock release];
}

- (void)close
{
    [self cancelWebIconLoaderIfNeeded];

    [[self bookmarksHome] close];

    [super close];
}

- (void)cancelWebIconLoaderIfNeeded
{
    [[self windowControllers] enumerateObjectsUsingBlock:^(NSWindowController *aWindowController, NSUInteger idx, BOOL *stop) {
        if ([aWindowController isKindOfClass:[ATWebIconLoaderWindowController class]])
            [[(ATWebIconLoaderWindowController *)aWindowController model] cancel];
    }];
}

- (NSArray *)rootBindersForBookmarksPresentation
{
    NSMutableArray *aRootBinders = [NSMutableArray array];
    
    [[self bookmarksWindowControllers] enumerateObjectsUsingBlock:^(ATBookmarksWindowController *aWindowController, NSUInteger idx, BOOL *stop) {
        [aRootBinders addObject:[[aWindowController bookmarksPresentation] root]];
    }];
    
    return aRootBinders;
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"ATBookmarksDocument #dealloc");
#endif
    
	[importers makeObjectsPerformSelector:@selector(cancel)];
	[importers release];

    [self setBookmarksHome:nil];
	
	[super dealloc];
}

@end

@implementation ATBookmarksDocument (Actions)

- (IBAction)showRootWindow:(id)sender
{
    [self openWindow:sender];
}

- (IBAction)openWindow:(id)sender
{
    [self openWindowFor:[[self bookmarks] root]];
}

- (void)showDocumentPreferences:(id)sender
{
    __block ATDocumentPreferencesWindowController *aWindowController = nil;
    
    [[self orderedWindows] enumerateObjectsUsingBlock:^(NSWindow *aWindow, NSUInteger idx, BOOL *stop) {
        if ([[[aWindow windowController] class] isEqual:[ATDocumentPreferencesWindowController class]])
        {
            aWindowController = [aWindow windowController];
            *stop = YES;
        }
    }];
     
    if (!aWindowController)
    {
        aWindowController = [ATDocumentPreferencesWindowController windowControllerWithPreferences:[[self bookmarksHome] preferences]];
        [self addWindowController:aWindowController];
        NSWindow *aBookmarksWindow = [self mostFrontBookmarksWindow];
        NSPoint aTopLeft = [aBookmarksWindow frame].origin;
        aTopLeft.y += [aBookmarksWindow frame].size.height;
        [[aWindowController window] setFrameTopLeftPoint:[aBookmarksWindow cascadeTopLeftFromPoint:aTopLeft]];
    }
    
    [aWindowController showWindow:nil];
}

//- (void)openWindowFor:(id)sender
//{
//	ATBookmarksPresentation *aPresentation = [[[ATBookmarksPresentation alloc] initWithBookmarks:[self bookmarks]] autorelease];
//	
//	[aPresentation setRoot:[[sender selections] lastObject]];
//	
//	[self addWindowController:[ATBookmarksWindowController controllerWithPresentation:aPresentation windowIndex:++windowIndex]];
//	[[[self windowControllers] lastObject] showWindow:sender];
//}

- (IBAction)importFirefoxBookmarks:(id)sender
{
	ATFirefoxHTMLBookmarksImporter *anImporter = [ATFirefoxHTMLBookmarksImporter importerWithDocument:self];

	[importers addObject:anImporter];
	[anImporter importInBackgroundFromFileSelectedByUser];
}

- (void)importerImportingFinished:(ATFirefoxHTMLBookmarksImporter *)anImporter
{
	[importers removeObject:anImporter];
}

- (IBAction)importBookmarksFromSafari:(id)sender
{
    [self importBookmarksUsingImporter:[ATSafariBookmarksImporter importer]];
}

- (IBAction)importBookmarksFromFirefox:(id)sender
{
    [self importBookmarksUsingImporter:[ATFirefoxBookmarksImporter importer]];
}

- (IBAction)importBookmarksFromChrome:(id)sender
{
    [self importBookmarksUsingImporter:[ATChromeBookmarksImporter importer]];
}

- (void)kidnap:(id)sender
{
    [[self bookmarks] kidnapWithRoots:[self rootBindersForBookmarksPresentation]];
}

@end

@implementation ATBookmarksDocument (Accessing)

- (NUNursery *)nursery
{
    return [[self bookmarksHome] nursery];
}

-  (void)setBookmarks:(ATBookmarks *)aBookmarks
{
    [[self bookmarksHome] setBookmarks:aBookmarks];
	[aBookmarks setDocument:self];
	[self setUndoManager:[aBookmarks undoManager]];
}

- (ATBookmarks *)bookmarks
{
    return [[self bookmarksHome] bookmarks];
}

- (ATBookmarksHome *)bookmarksHome
{
    return bookmarksHome;
}

- (void)setBookmarksHome:(ATBookmarksHome *)aBookmarksHome
{
    if (bookmarksHome)
        [[NSNotificationCenter defaultCenter] removeObserver:[bookmarksHome preferences]];
    
    [bookmarksHome release];
    bookmarksHome = [aBookmarksHome retain];
    
    [[bookmarksHome bookmarks] setDocument:self];
    [self setUndoManager:[[self bookmarks] undoManager]];
    
    if (bookmarksHome)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesDidChangeNotification:) name:ATDocumentPreferencesDidChangeNotification object:[bookmarksHome preferences]];
}

- (NSArray *)orderedWindows
{
	NSEnumerator *enumerator = [[[NSApplication sharedApplication] orderedWindows] objectEnumerator];
	NSWindow *aWindow = nil;
	NSMutableArray *anOrderedWindows = [NSMutableArray array];
	
	while (aWindow = [enumerator nextObject])
	{
		NSEnumerator *aDocumentWindowEnum = [[self windowControllers] objectEnumerator];
		id aWindowController = nil;
		BOOL aWindowIsFoundInDocument = NO;
		
		while (!aWindowIsFoundInDocument && (aWindowController = [aDocumentWindowEnum nextObject]))
		{
			if ([aWindow isEqual:[aWindowController window]])
			{
				[anOrderedWindows addObject:aWindow];
				aWindowIsFoundInDocument = YES;
			}
		}
	}
	
	return anOrderedWindows;
}

- (NSWindow *)mostFrontBookmarksWindow
{
    __block NSWindow *aBookmarksWindow = nil;
    
    [[self orderedWindows] enumerateObjectsUsingBlock:^(NSWindow *aWindow, NSUInteger idx, BOOL *stop) {
        if ([[aWindow windowController] isKindOfClass:[ATBookmarksWindowController class]])
        {
            aBookmarksWindow = aWindow;
            *stop = YES;
        }
    }];
    
    return aBookmarksWindow;
}

- (NSUInteger)bookmarksWindowCount
{
    __block NSUInteger aBookmarkWindowCount = 0;
    
    [[self windowControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ATBookmarksWindowController class]])
            aBookmarkWindowCount++;
    }];
    
    return aBookmarkWindowCount;
}
- (NSWindow *)windowForSheet
{
	return [self mostFrontBookmarksWindow];
}

@end

@implementation ATBookmarksDocument (Testing)

- (BOOL)hasSheet
{
	BOOL aWindowHasAttachedSheet = NO;
	NSEnumerator *enumerator = [[self windowControllers] objectEnumerator];
	id aWindowController = nil;
	
	while (!aWindowHasAttachedSheet && (aWindowController = [enumerator nextObject]))
		aWindowHasAttachedSheet = [[aWindowController  window] attachedSheet] ? YES : NO;
	
	return aWindowHasAttachedSheet;
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
    SEL anAction = [anItem action];

    if (anAction == @selector(revertDocumentToSaved:))
    {
        return !([self isDocumentEdited] && [super validateUserInterfaceItem:anItem]) ? NO : YES;
    }
	else
		return [super validateUserInterfaceItem:anItem];
}

- (BOOL)inMakingWindowControllers
{
	return inMakingWindowControllers;
}

@end
