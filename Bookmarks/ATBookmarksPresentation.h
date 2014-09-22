//
//  BookmarksPresentaion.h
//  Bookmarks
//
//  Created by 高田 明史  on 05/10/12.
//  Copyright 2005 Pedophilia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nursery/Nursery.h>

@class ATBookmarksHome;
@class ATBookmarks;
@class ATBinder;
@class ATEditor;
@class ATItemWrapper;
@class ATBinderWrapper;
@class ATBookmarksInsertOperation;
@class ATBookmarksRemoveOperation;
@class ATBookmarksMoveOperation;

extern NSString *ATBookmarksPresentationSelectionDidChangeNotification;
extern NSString *ATBookmarksPresentationDidChangeNotification;

@interface ATBookmarksPresentation : NSObject <NSWindowDelegate>
{
    NUBell *bell;
	NSNumber *presentationID;
	ATBookmarksHome *bookmarksHome;
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

- (id)initWithBookmarksHome:(ATBookmarksHome *)aBookmarksHome;

@end

@interface ATBookmarksPresentation (Coding) <NUCoding>

@end

@interface ATBookmarksPresentation (Accessing)

- (void)setPresentationID:(NSNumber *)aNumber;
- (NSNumber *)presentationID;

- (void)setBookmarksHome:(ATBookmarksHome *)aBookmarksHome;
- (ATBookmarksHome *)bookmarksHome;

- (ATBookmarks *)bookmarks;

- (ATBinder *)root;
- (void)setRoot:(ATBinder *)aRoot;

- (NSArray *)selections;

- (NSArray *)selectedItems;
- (NSArray *)selectedBookmarks;

- (NSIndexSet *)selectionIndexes;
- (NSIndexSet *)selectionIndexesInSelectedColumn;

- (NSUInteger)countOfItems;
- (void)setCountOfItems:(NSUInteger)aCount;

- (NSMenu *)menuForEvent:(NSEvent *)theEvent;

@end

@interface ATBookmarksPresentation (Opening)

- (NSArray *)arrayWithURLsOfSelectedBookmarkItems;
- (NSArray *)arrayWithURLsOf:(NSArray *)anItems;
- (void)open:(id)anItem;
- (BOOL)openBookmarksInSelectedBinderWithSafari;
- (BOOL)openURLsInSafari:(NSArray *)aURLs;
- (BOOL)openURLsInSafari:(NSArray *)aURLs withNewTabs:(BOOL)aNewTabFlag;

- (BOOL)openURLsInChrome:(NSArray *)aURLs;
- (BOOL)openURLsInChrome:(NSArray *)aURLs withNewTabs:(BOOL)aNewTabFlag;

- (BOOL)openURLsInFirefoxWithNewTabs:(NSArray *)aURLs;

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

- (BOOL)validateMenuItem:(NSMenuItem *)aMenuItem;

@end

@interface ATBookmarksPresentation (Actions)

- (IBAction)copy:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)delete:(id)sender;

- (IBAction)openBookmarksInSelectedBinderWithSafari:(id)sender;
- (IBAction)openSelectedBookmarksWithSafari:(id)sender;
- (IBAction)openSelectedBookmarksWithSafariWithNewTabs:(id)sender;

- (IBAction)openBookmarksInSelectedBinderWithChrome:(id)sender;
- (IBAction)openSelectedBookmarksWithChrome:(id)sender;
- (IBAction)openSelectedBookmarksWithChromeWithNewTabs:(id)sender;

- (IBAction)openBookmarksInSelectedBinderWithFirefox:(id)sender;
- (IBAction)openSelectedBookmarksWithFirefoxWithNewTabs:(id)sender;

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
- (void)preferredInsertDestination:(ATBinder **)aDestinationBinder index:(NSUInteger *)anIndex;
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

@interface ATBookmarksPresentation (BrowserDelegate)

@end

@interface ATBookmarksPresentation (Browser)

- (NSIndexSet *)selectionIndexesInColumn:(NSUInteger)aColumn;
- (void)setSelectionIndexes:(NSIndexSet *)aSelectionIndexes inColumn:(NSUInteger)aColumn;
- (void)changeLastColumn:(NSInteger)anOldLastColumn toColumn:(NSInteger)aColumn;

- (void)browser:(id)sender draggingEntered:(id <NSDraggingInfo>)aDraggingInfo;
- (void)browser:(id)sender draggingEnded:(id <NSDraggingInfo>)aDraggingInfo;

- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo on:(id)anItem contextInfo:(id)aContextInfo;
- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo;

- (void)postDidChangeNotification:(NSNumber *)aRootChanged;

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

#ifdef DEBUG

@interface ATBookmarksPresentation (Debugging)

- (IBAction)logItemIDOfSelections:(id)sender;
- (IBAction)logDuplicativeItemIDs:(id)sender;
- (IBAction)logSelections:(id)sender;

- (void)logDraggingSourceOperationMask:(id <NSDraggingInfo> )info;

@end

#endif