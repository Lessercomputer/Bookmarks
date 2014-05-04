/* ATFirefoxBookmarksImporter */

#import <Cocoa/Cocoa.h>

@class ATBinder;
@class ATBookmarks;
@class ATNetscapeBookmarkFile1DocumentEntity;
@class ATElement;
@class ATBookmarksDocument;

enum ATFirefoxBookmarksImporterStatus { ATFirefoxBookmarksImporterIsLoadingFile, ATFirefoxBookmarksImporterLoadingFinished, ATFirefoxBookmarksImporterIsParsing, ATFirefoxBookmarksImporterParsingFailed, ATFirefoxBookmarksImporterIsConverting, ATFirefoxBookmarksImporterSucceed, ATFirefoxBookmarksImporterFailed, ATFirefoxBookmarksImporterIsCanceled };

@interface ATFirefoxBookmarksImporter : NSObject
{
	NSString *bookmarksFilePath;
	NSMutableData *bookmarksFileData;
	NSInputStream *bookmarksInputStream;
	unsigned bytesRead;
	
	enum ATFirefoxBookmarksImporterStatus status;
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

@interface ATFirefoxBookmarksImporter (Accessing)

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

- (enum ATFirefoxBookmarksImporterStatus)status;

- (BOOL)isRunning;

@end

@interface ATFirefoxBookmarksImporter (Importing)

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