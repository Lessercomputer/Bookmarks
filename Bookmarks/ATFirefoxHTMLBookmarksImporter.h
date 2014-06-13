/* ATFirefoxHTMLBookmarksImporter */

#import <Cocoa/Cocoa.h>

@class ATBinder;
@class ATBookmarks;
@class ATNetscapeBookmarkFile1DocumentEntity;
@class ATElement;
@class ATBookmarksDocument;

enum ATFirefoxHTMLBookmarksImporterStatus { ATFirefoxHTMLBookmarksImporterIsLoadingFile, ATFirefoxHTMLBookmarksImporterLoadingFinished, ATFirefoxHTMLBookmarksImporterIsParsing, ATFirefoxHTMLBookmarksImporterParsingFailed, ATFirefoxHTMLBookmarksImporterIsConverting, ATFirefoxHTMLBookmarksImporterSucceed, ATFirefoxHTMLBookmarksImporterFailed, ATFirefoxHTMLBookmarksImporterIsCanceled };

@interface ATFirefoxHTMLBookmarksImporter : NSObject
{
	NSString *bookmarksFilePath;
	NSMutableData *bookmarksFileData;
	NSInputStream *bookmarksInputStream;
	unsigned bytesRead;
	
	enum ATFirefoxHTMLBookmarksImporterStatus status;
	NSLock *statusLock;

	ATNetscapeBookmarkFile1DocumentEntity *bookmarksDocumentEntity;
	ATBookmarks *bookmarks;
	ATBinder *root;
	NSMutableArray *foldersBeingBuilt;
	
	NSString *currentItemName;
	NSString *currentItemNameForBinding;
	unsigned countOfItems;
	unsigned countOfConvertedItems;
	NSString *convertingProgressDescription;
	NSDate *nextBindingValueUpdatingDate;
	NSString *processDescription;

	IBOutlet NSObjectController *controller;
	IBOutlet NSPanel *panel;
	
	ATBookmarksDocument *document;
}

+ (id)importerWithDocument:(ATBookmarksDocument *)aDocument;

- (id)initWith:(NSString *)aBookmarksFilePath bookmarks:(ATBookmarks *)aBookmarks;
- (id)initWithDocument:(ATBookmarksDocument *)aDocument;

@end

@interface ATFirefoxHTMLBookmarksImporter (Accessing)

- (NSString *)currentItemName;
- (void)setCurrentItemName:(NSString *)aString;

- (NSString *)currentItemNameForBinding;
- (void)setCurrentItemNameForBinding:(NSString *)aString;

- (NSUInteger)countOfItems;
- (void)setCountOfItems:(NSUInteger)aCount;

- (NSUInteger)countOfConvertedItems;
- (void)setCountOfConvertedItems:(NSUInteger)aCount;

- (NSString *)convertingProgressDescription;
- (void)setConvertingProgressDescription:(NSString *)aString;

- (void)updateBindingValueIfNeeded;

- (NSString *)processDescription;
- (void)setProcessDescription:(NSString *)aString;

- (enum ATFirefoxHTMLBookmarksImporterStatus)status;

- (BOOL)isRunning;

@end

@interface ATFirefoxHTMLBookmarksImporter (Importing)

- (void)importInBackgroundFromFileSelectedByUser;

- (void)importInBackground;
- (void)importUsingThread;

- (void)loadBookmarksFile;
- (void)startLoadingBookmarksFile;

- (void)parse;

- (void)convert;

- (NSData *)iconDataFrom:(ATElement *)aAElement type:(NSString **)aType;

- (void)update:(NSTimer *)aTimer;

- (IBAction)cancel:(id)sender;
- (void)cancel;

@end