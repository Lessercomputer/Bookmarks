//
//  MyDocument.h
//  ATBookmarks
//
//  Created by ?? on 05/10/11.
//  Copyright __MyCompanyName__ 2005 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class NUMainBranchNursery;
@class ATBookmarks;
@class ATBookmarksPresentation;
@class ATFirefoxHTMLBookmarksImporter;
@class ATBinder;
@class ATIDPool;
@class ATBookmarksHome;
@class ATInspectorWindowController;
@class ATEditor;
@class ATBookmarksImporter;

@interface ATBookmarksDocument : NSDocument
{
    ATBookmarksHome *bookmarksHome;
	int windowIndex;
	NSMutableArray *importers;
	NSString *savedWindowFrame;
	BOOL inMakingWindowControllers;
}

- (void)openWindowWith:(ATBookmarksPresentation *)aPresentation;
- (void)openWindowFor:(ATBinder *)aBinder;
- (void)openInspectorWindowFor:(NSArray *)anEditors;

- (ATInspectorWindowController *)inspectorWindowControllerForEditor:(ATEditor *)anEditor;

- (NSDictionary *)windowSettings;
- (NSDictionary *)windowSettingsForNursery;

- (void)importBookmarksUsingImporter:(ATBookmarksImporter *)anImporter;

@end

@interface ATBookmarksDocument (Actions)

- (IBAction)showRootWindow:(id)sender;
- (IBAction)openWindow:(id)sender;

- (IBAction)importFirefoxBookmarks:(id)sender;
- (void)importerImportingFinished:(ATFirefoxHTMLBookmarksImporter *)anImporter;

- (IBAction)importBookmarksFromSafari:(id)sender;
- (IBAction)importBookmarksFromFirefox:(id)sender;
- (IBAction)importBookmarksFromChrome:(id)sender;

@end

@interface ATBookmarksDocument (Accessing)

- (NUMainBranchNursery *)nursery;
- (void)setNursery:(NUMainBranchNursery *)aNursery;

- (ATBookmarksHome *)bookmarksHome;
- (void)setBookmarksHome:(ATBookmarksHome *)aBookmarksHome;

-  (void)setBookmarks:(ATBookmarks *)aBookmarks;
- (ATBookmarks *)bookmarks;

- (ATIDPool *)bookmarksPresentationIDPool;
- (void)setBookmarksPresentationIDPool:(ATIDPool *)aPool;

- (NSArray *)orderedWindows;

@end

@interface ATBookmarksDocument (Testing)

- (BOOL)hasSheet;

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem;

- (BOOL)inMakingWindowControllers;

@end