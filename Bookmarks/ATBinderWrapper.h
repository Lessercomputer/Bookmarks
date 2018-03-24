//
//  ATBinderWrapper.h
//  Bookmarks
//
//  Created by Akifumi Takata on 2012/10/13.
//
//

#import "ATItemWrapper.h"

@class ATBinder;

@interface ATBinderWrapper : ATItemWrapper
{
    NSMutableArray *items;
    NSMutableIndexSet *selectionIndexes;
    BOOL selectionIsChanged;
    BOOL itemsIsChanged;
}

- (ATBinder *)binder;

- (NSMutableArray *)items;
- (void)setItems:(NSMutableArray *)anItems;

- (NSIndexSet *)selectionIndexes;
- (void)setSelectionIndexes:(NSIndexSet *)aSelectionIndexes;

- (ATItemWrapper *)itemAt:(NSUInteger)anIndex;
- (NSArray *)itemsAt:(NSIndexSet *)anIndexes;

- (NSUInteger)indexOf:(ATItemWrapper *)anItemWrapper;
- (NSIndexSet *)indexesOf:(NSArray *)anItems;

- (NSArray *)selectedItems;
- (void)setSelectedItems:(NSArray *)anItems;

- (void)insertItems:(NSArray *)anItems at:(NSIndexSet *)anIndexes;

- (void)removeAtIndexes:(NSIndexSet *)anIndexes;

- (void)reloadAll;
- (void)removeAll;

- (void)removeAllOfSelectedSingleBinder;

- (NSUInteger)count;

+ (BOOL)itemIsSingleBinder:(NSArray *)anItems;
- (BOOL)itemIsSingleBinder:(NSArray *)anItems;
- (BOOL)selectedItemIsSingleBinder;

- (BOOL)selectionIsChanged;
- (void)setSelectionIsChanged:(BOOL)aSelectionChanged;

- (BOOL)itemsIsChanged;
- (void)setItemsIsChanged:(BOOL)anItemsChanged;

- (void)discardChangeInfo;

@end
