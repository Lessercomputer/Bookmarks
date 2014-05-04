//
//  ATBookmarks.h
//  ATBookmarks
//
//  Created by 明史 on 05/10/11.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nursery/Nursery.h>

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
	int changeCountOfDraggingPasteBoard;
	NSNumber *sourceBinderID;
	int changeCountOfGeneralPasteboard;
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

- (NSMutableArray *)items;
- (NSMutableDictionary *)itemsDictionary;
- (NULibrary *)itemLibrary;

- (ATBookmarksDocument *)document;
- (void)setDocument:(ATBookmarksDocument *)aDocument;

- (NSUndoManager  *)undoManager;

- (id)itemFor:(NSUInteger)anID;
- (NSArray *)itemsFor:(NSArray *)anIDs;

- (id)itemForIDNumber:(NSNumber *)anIDNumber;

- (NSArray *)itemsBy:(NSArray *)anIndexPaths;

- (void)openFolder:(ATBinder *)aFolder;
- (void)openFolder:(ATBinder *)aFolder recursive:(BOOL)aRecursiveFlag;
- (void)openFolder:(ATBinder *)aFolder recursive:(BOOL)aRecursiveFlag firstPass:(BOOL)aFirstPassFlag;

- (void)closeFolder:(ATBinder *)aFolder;
- (void)closeFolder:(ATBinder *)aFolder recursive:(BOOL)aRecursiveFlag;
- (void)closeFolder:(ATBinder *)aFolder recursive:(BOOL)aRecursiveFlag firstPass:(BOOL)aFirstPassFlag;

- (NSMutableDictionary *)groupItemsByParentAndSortSiblingsByIndex:(NSArray *)anItems;
- (NSMutableDictionary *)groupItemsByParentAndSortSiblingsByIndex:(NSArray *)anItems groupLinkedSiblings:(BOOL)aFlag;

- (NSArray *)topLevelItemsIn:(NSArray *)anItems;

- (ATBinder *)draggingSourceBinder;
- (void)setDraggingSourceBinder:(ATBinder *)aBinder;

- (NSIndexSet *)draggingItemIndexes;
- (void)setDraggingItemIndexes:(NSIndexSet *)anIndexes;

- (void)close;

@end

@interface ATBookmarks (Modifying)

- (void)change:(id)anItem with:(NSDictionary *)aValue;

- (void)apply:(NSArray *)aWebIcons to:(NSArray *)aBookmarks;

- (void)add:(id)anItem;
- (void)add:(id)anItem to:(ATBinder *)aFolder contextInfo:(id)anInfo;
- (void)addItems:(NSArray  *)anItems to:(ATBinder *)aFolder contextInfo:(id)anInfo;
- (void)insert:(id)anItem to:(NSUInteger)anIndex of:(ATBinder *)aFolder contextInfo:(id)anInfo;
- (void)insertItems:(NSArray  *)anItems of:(ATBinder *)aSourceBinder to:(NSUInteger)anIndex of:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo;

- (void)insertItems:(NSArray *)anItems to:(NSUInteger)anIndex of:(ATBinder *)aBinder contextInfo:(id)anInfo;

- (void)registerItems:(NSArray *)anItems;

-  (void)move:(id)anItem to:(NSUInteger)anIndex of:(ATBinder *)aFolder contextInfo:(id)anInfo;
- (void)moveItems:(NSArray  *)anItems of:(ATBinder *)aSourceBinder to:(NSUInteger)anIndex of:(ATBinder *)aFolder contextInfo:(id)anInfo;

- (void)moveOrInsertItems:(NSArray *)anItems of:(ATBinder *)aSourceBinder to:(NSUInteger)anIndex of:(ATBinder *)aDestinationBinder contextInfo:(id)aContextInfo;

- (void)moveItemsAtIndexes:(NSIndexSet *)aSourceIndexes of:(ATBinder *)aSourceBinder toIndex:(NSUInteger)aDestinationIndex of:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo;

- (void)removeItems:(NSArray  *)anItems from:(ATBinder *)aSourceBinder;
- (void)removeItems:(NSArray  *)anItems  from:(ATBinder *)aSourceBinder contextInfo:(id)anInfo;

- (void)removeItemsAtIndexes:(NSIndexSet *)anIndexes from:(ATBinder *)aBinder contextInfo:(id)anInfo;

@end

@interface ATBookmarks (Testing)

- (BOOL)canMove:(NSArray *)anItems to:(ATBinder *)aFolder at:(NSUInteger)anIndex;
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

- (NSArray *)indexPathsFrom:(NSArray *)anItems;
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

- (NSDragOperation)validateDrop:(id <NSDraggingInfo>)anInfo on:(id)anItem;
- (NSDragOperation)validateDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex;
- (NSDragOperation)validateLocalDrop:(id <NSDraggingInfo>)anInfo to:(ATBinder *)anItem at:(NSUInteger)anIndex;

- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo on:(id)anItem contextInfo:(id)aContextInfo;
- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo;
- (BOOL)acceptLocalDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo;
- (BOOL)acceptNonLocalDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo;

- (void)logDragOperationMask:(NSDragOperation)aDragOperation;

@end

@interface ATBookmarks (Private)

- (void)setRoot:(ATBinder *)aRoot;

- (void)setIDPool:(ATIDPool *)anIDPool;

- (void)setUndoManager:(NSUndoManager  *)aManager;

- (void)newItemIDTo:(id)anItem;
- (void)restoreItemIDOf:(id)anItem;
- (void)releseItemIDOf:(id)anItem;

- (void)setItems:(NSMutableArray *)anItems;
- (void)setItemsDictionary:(NSMutableDictionary *)aDictionary;
- (void)setItemLibrary:(NULibrary *)aLibrary;

- (void)bookmarksWillInsert:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo;
- (void)bookmarksDidInsert:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo;

- (void)runInsertOperation:(ATBookmarksInsertOperation *)anInsertOperation;
- (void)runRemoveOperation:(ATBookmarksRemoveOperation *)aRemoveOperation;
- (void)runMoveOperation:(ATBookmarksMoveOperation *)aMoveOperation;

- (void)bookmarksWillMove:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo;
- (void)bookmarksDidMove:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo;

- (void)bookmarksWillMoveOrInsert:(NSArray *)anItems from:(ATBinder *)aSourceBinder to:(ATBinder *)aDestinationBinder movingItems:(NSArray *)aMovingItems insertingItems:(NSArray *)anInsertingItems contextInfo:(id)aContextInfo;
- (void)bookmarksDidMoveOrInsert:(NSArray *)anItems from:(ATBinder *)aSourceBinder to:(ATBinder *)aDestinationBinder movingItems:(NSArray *)aMovingItems insertingItems:(NSArray *)anInsertingItems contextInfo:(id)aContextInfo;

- (void)bookmarksWillRemove:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo;
- (void)bookmarksDidRemove:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo;

- (NSDictionary *)userInfoWithItems:(NSArray *)anItems contextInfo:(id)anInfo;
- (NSDictionary *)userInfoWithItems:(NSArray *)anItems source:(ATBinder *)aSource destination:(ATBinder *)aDestination contextInfo:(id)anInfo;
- (NSDictionary *)moveOrInsertUserInfoWithItems:(NSArray *)anItems source:(ATBinder *)aSourceBinder destination:(ATBinder *)aDestinationBinder movingItems:(NSArray *)aMovingItems insertingItems:(NSArray *)anInsertingItems contextInfo:(id)aContextInfo;

- (void)bookmarksWillEdit:(id)anItem;
- (void)bookmarksDidEdit:(id)anItem;

- (void)bookmarksWillChange;
- (void)bookmarksWillChange:(id)anInfo;
- (void)bookmarksDidChange;
- (void)bookmarksDidChange:(id)anInfo;

- (void)logDraggingSourceOperationMask:(NSDragOperation)aOperation;

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