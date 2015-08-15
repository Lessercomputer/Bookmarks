//
//  BookmarksDocument.h
//  Bookmarks
//
//  Created by P,T,A on 05/10/11.
//  Copyright PEDOPHILIA 2005 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

@class NUNursery;
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
- (NSArray *)bookmarksWindowControllers;

- (NSDictionary *)windowSettings;
- (NSDictionary *)windowSettingsForNursery;

- (void)importBookmarksUsingImporter:(ATBookmarksImporter *)anImporter;

- (void)preferencesDidChangeNotification:(NSNotification *)aNotification;

- (void)cancelWebIconLoaderIfNeeded;

- (NSArray *)rootBindersForBookmarksPresentation;

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

- (IBAction)kidnap:(id)sender;

@end

@interface ATBookmarksDocument (Accessing)

- (NUNursery *)nursery;

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