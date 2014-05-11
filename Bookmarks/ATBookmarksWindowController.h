/* ATBookmarksWindowController */

#import <Cocoa/Cocoa.h>

@class ATBookmarks;
@class ATBookmarksPresentation;
@class ATBookmarksBrowserController;

@interface ATBookmarksWindowController : NSWindowController
{
	IBOutlet id bookmarksView;
	IBOutlet ATBookmarksPresentation *bookmarksPresentation;
	IBOutlet NSObjectController *presentationController;
    IBOutlet ATBookmarksBrowserController *browserController;
	//ATBookmarks *bookmarks;
	//id topLevelFolder;
	NSUInteger windowIndex;
	BOOL ignoreWindowFrameChange;
}
@end

@interface ATBookmarksWindowController (Initializing)

+ (id)controllerWithPresentation:(ATBookmarksPresentation *)aPresentation windowIndex:(NSUInteger)anIndex;

- (id)initWithPresentation:(ATBookmarksPresentation *)aPresentation windowIndex:(NSUInteger)anIndex;

@end

@interface ATBookmarksWindowController (Accessing)

- (void)setBookmarks:(ATBookmarks *)aBookmarks;
- (ATBookmarks *)bookmarks;

- (void)setBookmarksPresentation:(ATBookmarksPresentation *)aPresentation;
- (ATBookmarksPresentation *)bookmarksPresentation;

- (NSIndexSet *)selectionIndexSetInPresentation;

@end

@interface ATBookmarksWindowController (Actions)

- (IBAction)makeNewBookmark:(id)sender;
- (IBAction)makeNewFolder:(id)sender;

- (IBAction)showNewWindow:(id)sender;

- (IBAction)openWindowWithCurrentPresentation:(id)sender;
- (IBAction)openWindowForCurrentBinder:(id)sender;
- (IBAction)openItem:(id)sender;

- (IBAction)loadWebIconOfSelectedItems:(id)sender;

- (IBAction)openSelectedBinder:(id)sender;

- (IBAction)openBookmark:(id)sender;

@end

@interface ATBookmarksWindowController (Testing)

- (BOOL)validateMenuItem:(NSMenuItem *)aMenuItem;

- (BOOL)ignoreWindowFrameChange;
- (void)setIgnoreWindowFrameChange:(BOOL)aFlag;

@end

@interface ATBookmarksWindowController (Notifying)

- (void)addObserverForWindow;
- (void)windowDidMoveOrResize:(NSNotification *)aNotification;

@end
