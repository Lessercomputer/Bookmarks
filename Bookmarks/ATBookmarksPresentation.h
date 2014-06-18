//
//  ATBookmarksPresentaion.h
//  ATBookmarks
//
//  Created by 明史 on 05/10/12.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nursery/Nursery.h>

@class ATBookmarks;
@class ATBinder;
@class ATBinderPath;
@class ATEditor;
@class ATSelectionInBinder;
@class ATItemWrapper;
@class ATBinderWrapper;
@class ATBookmarksInsertOperation;
@class ATBookmarksRemoveOperation;
@class ATBookmarksMoveOperation;

extern NSString *ATBookmarksPresentationSelectionDidChangeNotification;
extern NSString *ATBookmarksPresentationDidChangeNotification;

@interface ATBookmarksPresentation : NSObject
{
    NUBell *bell;
	NSNumber *presentationID;
	ATBookmarks *bookmarks;
	ATBinder *root;
	NSArray *selections;
	NSArray *selectionIndexPaths;
    NSIndexSet *selectionIndexes;
    NSMutableArray *binders;
    NSMutableArray *binderWrappers;
    NSMutableArray *binderWrappersBeforeDragging;
    NSInteger selectedColumn;
	BOOL inMakeNewItem;
	NSUInteger countOfItems;
    NSUInteger disableCountOfNotification;
    NSInteger countOfDraggingEntered;
}

- (id)initWithBookmarks:(ATBookmarks *)aBookmarks;

@end

@interface ATBookmarksPresentation (Coding) <NUCoding>

@end

@interface ATBookmarksPresentation (Accessing)

- (void)setPresentationID:(NSNumber *)aNumber;
- (NSNumber *)presentationID;

- (void)setBookmarks:(ATBookmarks *)aBookmarks;
- (ATBookmarks *)bookmarks;

- (ATBinder *)root;
- (void)setRoot:(ATBinder *)aRoot;

- (NSArray *)selections;
- (void)setSelections:(NSArray *)aSelections;

- (NSArray *)selectedItems;
- (NSArray *)selectedBookmarks;

- (NSArray *)selectionIndexPaths;
- (void)setSelectionIndexPaths:(NSArray *)anIndexPaths;

- (NSIndexSet *)selectionIndexes;
- (NSIndexSet *)selectionIndexesInSelectedColumn;

- (NSUInteger)countOfItems;
- (void)setCountOfItems:(NSUInteger)aCount;

- (NSMenu *)menuForEvent:(NSEvent *)theEvent;

- (NSMutableArray *)binders;
- (NSInteger)binderCount;

@end

@interface ATBookmarksPresentation (Opening)

- (NSArray *)arrayWithURLsOfSelectedBookmarkItems;
- (NSArray *)arrayWithURLsOf:(NSArray *)anItems;
- (void)open:(id)anItem;
- (BOOL)openItemsInSelectedFolder;
- (BOOL)openURLsIn:(NSArray *)aURLs;
- (BOOL)openURLsIn:(NSArray *)aURLs withNewTabs:(BOOL)aNewTabFlag;

- (BOOL)openURLsWithFirefox:(NSArray *)aURLs;

@end

@interface ATBookmarksPresentation (Testing)

- (BOOL)canCopy;
- (BOOL)canCut;

- (BOOL)canPaste;

- (BOOL)canDelete;

- (BOOL)currentSelectionIsRoot;
- (BOOL)currentSelectionIsNotRoot;

- (BOOL)inMakeNewItem;
- (BOOL)isInDragging;

- (BOOL)anyBookmarkWithURLIsSelected;
- (BOOL)canOpenSelectedBinder;

- (BOOL)binderIsRoot:(ATBinder *)aBinder;
- (BOOL)lastBinderIsRoot;

- (BOOL)lastBinderHasSelection;

- (BOOL)validateMenuItem:(id <NSMenuItem>)aMenuItem;

@end

@interface ATBookmarksPresentation (Actions)

- (IBAction)copy:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)delete:(id)sender;

- (IBAction)openItemsInSelectedFolder:(id)sender;
- (IBAction)openSelectedItemsWithoutFolders:(id)sender;
- (IBAction)openSelectedItemsWithFirefoxWithoutFolders:(id)sender;
- (IBAction)openSelectedItemsWithoutFoldersWithNewTabs:(id)sender;
- (void)runAppleScriptNamed:(NSString *)aScriptName handlerName:(NSString *)aHandlerName argment:(NSAppleEventDescriptor *)anArgment;
- (void)runAppleScriptNamed:(NSString *)aScriptName handlerName:(NSString *)aHandlerName argments:(NSAppleEventDescriptor *)anArgments;

@end

@interface ATBookmarksPresentation (Editing)

- (void)beginMakingNewItem:(ATEditor *)anEditor;

- (void)endMakingNewItem:(ATEditor *)anEditor;

- (NSArray *)editorsForSelections;

- (void)accept:(id)anOriginallyItem edited:(NSDictionary *)aValue;

@end

@interface ATBookmarksPresentation (Modifying)

- (void)copySelections;
- (void)cutSelections;
- (void)paste;

- (void)add:(id)anItem;
- (void)addItems:(NSArray *)anItems;
- (void)preferredInsertDestination:(ATBinder **)aDestinationBinder index:(unsigned *)anIndex;
- (void)removeSelections;

@end


@interface ATBookmarksPresentation (BookmarksNotifications)

- (void)bookmarksItemsDidInsert:(NSNotification *)aNotification;
- (void)bookmarksItemsDidMove:(NSNotification *)aNotification;
- (void)bookmarksItemsDidRemove:(NSNotification *)aNotification;
- (void)bookmarksFolderDidOpenOrClose:(NSNotification *)aNotification;
- (void)bookmarksWillOrDidEditItem:(NSNotification *)aNotification;
- (void)bookmarksDidChange:(NSNotification *)aNotification;

@end

@interface ATBookmarksPresentation (OutlineViewDataSouce)

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpanded:(id)aFolder;

- (void)outlineView:(NSOutlineView *)outlineView openFolder:(ATBinder *)aFolder recursive:(BOOL)aRecursiveFlag;
- (void)outlineView:(NSOutlineView *)outlineView closeFolder:(ATBinder *)aFolder recursive:(BOOL)aRecursiveFlag;

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(int)index;
- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(int)index;

@end

@interface ATBookmarksPresentation (BrowserDelegate)

- (BOOL)browser:(NSBrowser *)sender canDragRowsWithIndexes:(NSIndexSet *)aDraggingRows inColumn:(int)aDraggingColumn;
- (BOOL)browser:(NSBrowser *)sender writeRowsWithIndexes:(NSIndexSet *)aDraggingRows inColumn:(int)aDraggingColumn toPasteboard:(NSPasteboard *)aDragPboard;

@end

@interface ATBookmarksPresentation (Browser)

- (NSIndexSet *)selectionIndexesInColumn:(NSUInteger)aColumn;
- (void)setSelectionIndexes:(NSIndexSet *)aSelectionIndexes inColumn:(NSUInteger)aColumn;
- (void)changeLastColumn:(NSInteger)anOldLastColumn toColumn:(NSInteger)aColumn;

- (void)browser:(id)sender draggingEntered:(id <NSDraggingInfo>)aDraggingInfo;
- (void)browser:(id)sender draggingEnded:(id <NSDraggingInfo>)aDraggingInfo;

- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo on:(id)anItem contextInfo:(id)aContextInfo;
- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo;

- (void)postDidChangeNotification:(BOOL)aRootChanged;

- (NSInteger)lastColumn;
- (NSInteger)selectedColumn;
- (void)setSelectedColumn:(NSInteger)aColumn;
- (void)getSelectionIndexesInto:(NSIndexSet **)aSelectionIndexes binderInto:(ATBinder **)aBinder;
- (NSUInteger)binderCount;
- (ATBinder *)binderAt:(NSUInteger)anIndex;
- (NSUInteger)itemCountOf:(ATBinderWrapper *)aBinderWrapper;
- (ATItemWrapper *)itemWrapperAt:(NSUInteger)anIndex ofBinderWrapper:(ATItemWrapper *)aBinderWrapper;
- (NSInteger)firstColumnForBinder:(ATBinder *)aBinder;
- (ATBinder *)lastBinder;
- (ATBinder *)selectedBinder;

@end

@interface ATBookmarksPresentation (Private)

- (NSMutableArray *)binderWrappers;
- (void)setBinderWrappers:(NSMutableArray *)aBinderWrappers;

- (void)removeBinderWrappersFromIndex:(NSUInteger)aColumn;
- (void)addBinderWrapper:(ATBinderWrapper *)aBinderWrapper;

- (void)reloadItemsAt:(NSUInteger)aColumn;

- (ATBinderWrapper *)binderWrapperAt:(NSUInteger)aColumn;
- (NSUInteger)indexOfBinderWrapper:(ATBinderWrapper *)aBinderWrapper;

- (void)storeBinderWrappersForDragging;
- (void)restoreBinderWrappersForDragging;
- (void)discardBinderWrappersForDragging;
- (void)setBinderWrappersForDragging:(NSMutableArray *)aBinderWrappers;
- (NSMutableArray *)copyBinderWrappers;

//- (ATBinderWrapper *)binderWrapperFor:(ATItemWrapper *)aBinderWrapper;
- (NSIndexSet *)computeNewSelectionWithCurrentSelection:(NSIndexSet *)aCurrentSelectionIndexes removedSelection:(NSIndexSet *)aRemovedSelectionIndexes;

- (void)disableNotification;
- (void)enableNotification;
- (BOOL)notificationIsEnabled;

- (void)getUpperBinderIndex:(NSInteger *)anUpperBinderIndex lowerBinderIndex:(NSInteger *)aLowerBinderIndex fromBinderIndex1:(NSInteger)aBinderIndex1 binderIndex2:(NSInteger)aBinderIndex2;

- (void)updateWithInsertOperation:(ATBookmarksInsertOperation *)anInsertOperation;
- (void)updateWithRemoveOperation:(ATBookmarksRemoveOperation *)aRemoveOperation;
- (void)updateWithMoveOperation:(ATBookmarksMoveOperation *)aMoveOperation;
- (void)updateWithSameBinderMoveOperation:(ATBookmarksMoveOperation *)aMoveOperation;
- (void)updateWithDifferentBinderMoveOperation:(ATBookmarksMoveOperation *)aMoveOperation;
//- (void)updateWithMoveOperation:(ATBookmarksMoveOperation *)aMoveOperation binderIndex:(NSInteger)aBinderIndex;

- (void)discardBinderWrapperChangeInfo;

@end

@interface ATBookmarksPresentation (Debugging)

- (IBAction)logItemIDOfSelections:(id)sender;
- (IBAction)logDuplicativeItemIDs:(id)sender;
- (IBAction)logSelections:(id)sender;

- (void)logDraggingSourceOperationMask:(id <NSDraggingInfo> )info;

@end