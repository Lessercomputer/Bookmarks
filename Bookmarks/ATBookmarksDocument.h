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
@class ATBookmarksWindowController;

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
- (void)openInspectorWindowFor:(NSArray *)anEditors bookmarksWindowController:(ATBookmarksWindowController *)aBookmarksWindowController;

- (ATInspectorWindowController *)inspectorWindowControllerForEditor:(ATEditor *)anEditor;

- (NSDictionary *)windowSettings;
- (NSDictionary *)windowSettingsForNursery;

- (void)importBookmarksUsingImporter:(ATBookmarksImporter *)anImporter;

- (void)preferencesDidChangeNotification:(NSNotification *)aNotification;

- (void)cancelWebIconLoaderIfNeeded;

@end

@interface ATBookmarksDocument (Actions)

- (IBAction)showRootWindow:(id)sender;
- (IBAction)openWindow:(id)sender;

- (IBAction)showDocumentPreferences:(id)sender;

- (IBAction)importFirefoxBookmarks:(id)sender;
- (void)importerImportingFinished:(ATFirefoxHTMLBookmarksImporter *)anImporter;

- (IBAction)importBookmarksFromSafari:(id)sender;
- (IBAction)importBookmarksFromFirefox:(id)sender;
- (IBAction)importBookmarksFromChrome:(id)sender;

@end

@interface ATBookmarksDocument (Accessing)

- (NUMainBranchNursery *)nursery;

- (ATBookmarksHome *)bookmarksHome;
- (void)setBookmarksHome:(ATBookmarksHome *)aBookmarksHome;

-  (void)setBookmarks:(ATBookmarks *)aBookmarks;
- (ATBookmarks *)bookmarks;

- (NSArray *)orderedWindows;
- (NSWindow *)mostFrontBookmarksWindow;
- (NSUInteger)bookmarksWindowCount;

@end

@interface ATBookmarksDocument (Testing)

- (BOOL)hasSheet;

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem;

- (BOOL)inMakingWindowControllers;

@end