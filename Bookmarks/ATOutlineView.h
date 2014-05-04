/* ATOutlineView */

#import <Cocoa/Cocoa.h>

@class ATBookmarks, ATBinder;

@interface ATOutlineView : NSOutlineView
{
	BOOL inSynchronization;
}
@end

@interface ATOutlineView (Accessing)

- (ATBookmarks *)bookmarks;
- (NSIndexSet *)selectionIndexSetInPresentation;

@end

@interface ATOutlineView (UpdatingView)

- (void)updateSwitchingStatus;
- (void)updateSwitchingStatusOfFolder:(ATBinder *)aFolder;

@end

@interface ATOutlineView (ViewDelegateAndNotifications)

- (void)didExpandItem:(ATBinder *)aFolder expandChildren:(BOOL)anExpandChildrenFlag;
- (void)didCollapseItem:(ATBinder *)aFolder collapseChildren:(BOOL)anCollapseChildrenFlag;

@end

@interface ATOutlineView (BookmarksPresentationNotifications)

- (void)bookmarksItemsDidInsertOrMoveOrRemove:(NSNotification *)aNotification;

- (void)bookmarksDidEditItem:(NSNotification *)aNotification;

- (void)selectionInBookmarksPresentationDidChange:(NSNotification *)aNotification;

- (void)folderWasExpandedOnBookmarks:(NSNotification *)aNotification;
- (void)folderWasCollapsedOnBookmarks:(NSNotification *)aNotification;

@end