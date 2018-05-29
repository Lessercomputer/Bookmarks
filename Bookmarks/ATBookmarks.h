//
//  Bookmarks.h
//  Bookmarks
//
//  Created by Akifumi Takata  on 05/10/11.
//  Copyright 2005 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nursery/Nursery.h>

@class ATItem;
@class ATBinder;
@class ATBookmark;
@class ATIDPool;
@class ATBookmarksDocument;
@class ATBookmarksInsertOperation;
@class ATBookmarksRemoveOperation;
@class ATBookmarksMoveOperation;

extern NSString *ATBookmarksWillInsertNotification;
extern NSString *ATBookmarksDidInsertNotification;

extern NSString *ATBookmarksWillMovetNotification;
extern NSString *ATBookmarksDidMoveNotification;

extern NSString *ATBookmarksWillMoveOrInsertNotification;
extern NSString *ATBookmarksDidMoveOrInsertNotification;

extern NSString *ATBookmarksWillRemovetNotification;
extern NSString *ATBookmarksDidRemoveNotification;

extern NSString *ATBookmarksWillChangeNotification;
extern NSString *ATBookmarksDidChangeNotification;

extern NSString *ATBookmarksDidOpenFolderNotification;
extern NSString *ATBookmarksDidCloseFolderNotification;

extern NSString *ATBookmarksWillEditItemNotification;
extern NSString *ATBookmarksDidEditItemNotification;

extern NSString *ATBookmarksItemIDsPasteBoardType;
extern NSString *ATBookmarksItemsPropertyListRepresentaionPasteBoardType;

@interface ATBookmarks : NSObject
{
    NUBell *bell;
	ATBinder *root;
	ATIDPool *idPool;
//	NSMutableArray *items;
    NULibrary *itemLibrary;
	NSUndoManager *undoManager;
	unsigned untitledBookmarkIndex;
	unsigned untitledFolderIndex;
	NSInteger changeCountOfDraggingPasteBoard;
	NSNumber *sourceBinderID;
	NSInteger changeCountOfGeneralPasteboard;
    BOOL hasCutItems;
	NSArray *itemsToPaste;
	ATBookmarksDocument *document;
    ATBinder *draggingSourceBinder;
    NSIndexSet *draggingItemIndexes;
}

@end

@interface ATBookmarks (Initializing)

+ (id)bookmarksWithArchive:(NSDictionary *)anArchive;

- (id)initWithIDPool:(ATIDPool *)anIDPool items:(NSMutableDictionary *)anItemsDictionary root:(ATBinder *)aRoot;

- (void)releaseItems;

@end

@interface ATBookmarks (Coding) <NUCoding>
@end

@interface ATBookmarks (Accessing)

- (ATIDPool *)idPool;

- (ATBinder *)root;

- (NSUInteger)count;

- (NULibrary *)itemLibrary;

- (ATBookmarksDocument *)document;
- (void)setDocument:(ATBookmarksDocument *)aDocument;

- (NSUndoManager  *)undoManager;

- (id)itemFor:(NSUInteger)anID;
- (NSArray *)itemsFor:(NSArray *)anIDs;

- (id)itemForIDNumber:(NSNumber *)anIDNumber;

- (NSArray *)itemsBy:(NSArray *)anIndexPaths;

- (ATBinder *)draggingSourceBinder;
- (void)setDraggingSourceBinder:(ATBinder *)aBinder;

- (NSIndexSet *)draggingItemIndexes;
- (void)setDraggingItemIndexes:(NSIndexSet *)anIndexes;

- (void)close;

@end

@interface ATBookmarks (Modifying)

- (void)change:(id)anItem with:(NSDictionary *)aValue;

- (void)apply:(NSArray *)aWebIcons to:(NSArray *)aBookmarks;

- (void)add:(ATItem *)anItem;
- (void)insertItems:(NSArray *)anItems to:(NSUInteger)anIndex of:(ATBinder *)aBinder contextInfo:(id)anInfo;

- (void)registerItems:(NSArray *)anItems;

- (void)moveItemsAtIndexes:(NSIndexSet *)aSourceIndexes of:(ATBinder *)aSourceBinder toIndex:(NSUInteger)aDestinationIndex of:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo;

- (void)removeItemsAtIndexes:(NSIndexSet *)anIndexes from:(ATBinder *)aBinder contextInfo:(id)anInfo;

@end

@interface ATBookmarks (Testing)

- (BOOL)canMoveItemsAtIndexes:(NSIndexSet *)anIndexSet of:(ATBinder *)aSourceBinder to:(NSUInteger)anIndex of:(ATBinder *)aDestinationBinder;

- (BOOL)canPaste;

@end

@interface ATBookmarks (CreatingNewItem)
- (ATBinder *)untitledFolder;

- (ATBookmark *)untitledBookmark;
@end

@interface ATBookmarks (Converting)
- (NSData *)serializedPropertyListRepresentation;

- (NSMutableDictionary   *)propertyListRepresentation;

- (NSArray *)itemsFromBookmarkDictionaryList:(NSArray *)aBookmarkDictionaryList;
@end

@interface ATBookmarks (Editing)

- (BOOL)copy:(NSIndexSet *)aSelectionIndexes of:(ATBinder *)aSourceBinder;
- (BOOL)copy:(NSIndexSet *)aSelectionIndexes of:(ATBinder *)aSourceBinder to:(NSPasteboard *)aPasteboard;
- (BOOL)cut:(NSIndexSet *)aSelectionIndexes of:(ATBinder *)aSourceBinder;

- (void)pasteTo:(ATBinder *)aFolder at:(NSUInteger)anIndex contextInfo:(id)anInfo;
- (void)pasteTo:(ATBinder *)aFolder at:(NSUInteger)anIndex from:(NSPasteboard *)aPasteboard contextInfo:(id)anInfo;

- (NSArray *)itemsFrom:(NSPasteboard *)aPasteboard;

- (void)resetAllItemIDs;

@end

@interface ATBookmarks (DraggingAndDropping)

- (BOOL)writeDraggingItemsWithIndexes:(NSIndexSet *)anIndexes of:(ATBinder *)aSourceBinder to:(NSPasteboard *)aPasteboard;

- (NSArray *)pasteBoardTypes;

- (NSDragOperation)validateDrop:(id <NSDraggingInfo>)anInfo on:(ATItem *)anItem;
- (NSDragOperation)validateDrop:(id <NSDraggingInfo>)anInfo to:(ATItem *)anItem at:(NSUInteger)anIndex;
- (NSDragOperation)validateLocalDrop:(id <NSDraggingInfo>)anInfo to:(ATBinder *)anItem at:(NSUInteger)anIndex;

- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo on:(ATBinder *)anItem contextInfo:(id)aContextInfo;
- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo;
- (BOOL)acceptLocalDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo;
- (BOOL)acceptNonLocalDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo;

#ifdef DEBUG
- (void)logDragOperationMask:(NSDragOperation)aDragOperation;
#endif

@end

@interface ATBookmarks (GC)

- (void)GCWithRoots:(NSArray *)aRoots;

@end

@interface ATBookmarks (Private)

- (void)setRoot:(ATBinder *)aRoot;

- (void)setIDPool:(ATIDPool *)anIDPool;

- (void)setUndoManager:(NSUndoManager  *)aManager;

- (void)newItemIDTo:(id)anItem;
- (void)restoreItemIDOf:(id)anItem;
- (void)releseItemIDOf:(id)anItem;

- (void)setItemLibrary:(NULibrary *)aLibrary;

- (void)runInsertOperation:(ATBookmarksInsertOperation *)anInsertOperation;
- (void)runRemoveOperation:(ATBookmarksRemoveOperation *)aRemoveOperation;
- (void)runMoveOperation:(ATBookmarksMoveOperation *)aMoveOperation;

- (NSDictionary *)userInfoWithItems:(NSArray *)anItems contextInfo:(id)anInfo;
- (NSDictionary *)userInfoWithItems:(NSArray *)anItems source:(ATBinder *)aSource destination:(ATBinder *)aDestination contextInfo:(id)anInfo;

- (void)bookmarksWillEdit:(id)anItem;
- (void)bookmarksDidEdit:(id)anItem;

- (void)bookmarksWillChange;
- (void)bookmarksWillChange:(id)anInfo;
- (void)bookmarksDidChange;
- (void)bookmarksDidChange:(id)anInfo;

#ifdef DEBUG
- (void)logDraggingSourceOperationMask:(NSDragOperation)aOperation;
#endif

- (void)setSourceBinderID:(NSNumber *)aSourceBinderID;

- (NSArray *)itemsToPaste;
- (void)setItemsToPaste:(NSArray *)anItems;

@end

@interface ATBookmarks (ScriptingSupport)

//- (NSArray *)bookmarkItems;
- (id)valueInBookmarkItemsWithUniqueID:(id)aNumber;
- (NSUInteger)countOfBookmarkItems;
- (id)objectInBookmarkItemsAtIndex:(NSUInteger)anIndex;

@end
