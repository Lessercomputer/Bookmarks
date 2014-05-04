//
//  ATBinderWrapper.m
//  ATBookmarks
//
//  Created by 高田 明史 on 2012/10/13.
//
//

#import "ATBinderWrapper.h"
#import "ATItem.h"

@implementation ATBinderWrapper

- (id)initWithItem:(ATItem *)anItem
{
    [super initWithItem:anItem];
    
    [self setSelectionIndexes:[NSMutableIndexSet indexSet]];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ATBinderWrapper *aCopiedBinderWrapper = [super copyWithZone:zone];
    
    [aCopiedBinderWrapper setSelectionIndexes:[self selectionIndexes]];
    
    if (items)
    {
        NSMutableArray *aCopiedItems = [NSMutableArray array];
        [items enumerateObjectsUsingBlock:^(ATItemWrapper *anItemWrapper, NSUInteger anIndex, BOOL *aStop) {
            [aCopiedItems addObject:[[anItemWrapper copy] autorelease]];
        }];
        [aCopiedBinderWrapper setItems:aCopiedItems];
    }
    
    return aCopiedBinderWrapper;
}

- (void)dealloc
{
    [items release];
    [selectionIndexes release];
    
    [super dealloc];
}

- (ATBinder *)binder
{
    return (ATBinder *)[self item];
}

- (NSMutableArray *)items
{
    if (!items) [self reloadAll];
    
    return items;
}

- (void)setItems:(NSMutableArray *)anItems
{
    NUSetIvar(&items, anItems);
    [self setItemsIsChanged:YES];
    [[[self bell] playLot] markChangedObject:self];
}

- (NSIndexSet *)selectionIndexes
{
    return selectionIndexes;
}

- (void)setSelectionIndexes:(NSIndexSet *)aSelectionIndexes
{
    if ([selectionIndexes isEqualToIndexSet:aSelectionIndexes]) return;
    
//    if ([aSelectionIndexes firstIndex] == 0)
//        NSLog([aSelectionIndexes description]);
    
    NUSetIvar(&selectionIndexes, aSelectionIndexes);
    [self setSelectionIsChanged:YES];
    [[[self bell] playLot] markChangedObject:self];
}

- (ATItemWrapper *)itemAt:(NSUInteger)anIndex
{
    return [[self items] objectAtIndex:anIndex];
}

- (NSArray *)itemsAt:(NSIndexSet *)anIndexes
{
    return [[self items] objectsAtIndexes:anIndexes];
}

- (NSUInteger)indexOf:(ATItemWrapper *)anItemWrapper
{
    return [[self items] indexOfObject:anItemWrapper];
}

- (NSIndexSet *)indexesOf:(NSArray *)anItems
{
    NSMutableIndexSet *anIndexSet = [NSMutableIndexSet indexSet];
    
    [anItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [anIndexSet addIndex:[[self items] indexOfObject:obj]];
    }];
    
    return anIndexSet;
}

- (BOOL)isBinderWrapper
{
    return YES;
}

- (NSArray *)selectedItems
{
    return  [self itemsAt:[self selectionIndexes]];
}

- (void)setSelectedItems:(NSArray *)anItems
{
    [self setSelectionIndexes:[self indexesOf:anItems]];
}

- (void)insertItems:(NSArray *)anItems at:(NSIndexSet *)anIndexes
{
    [[self items] insertObjects:anItems atIndexes:anIndexes];
    
    [self setItemsIsChanged:YES];
    [[[self bell] playLot] markChangedObject:[self items]];
}

- (void)removeAtIndexes:(NSIndexSet *)anIndexes
{
    [[self items] removeObjectsAtIndexes:anIndexes];
    
    [self setItemsIsChanged:YES];
    [[[self bell] playLot] markChangedObject:[self items]];
}

- (void)reloadAll
{
    NSMutableArray *anItems = [NSMutableArray array];
    
    [[[self binder] children] enumerateObjectsUsingBlock:^(ATItem *anItem, NSUInteger anIndex, BOOL *aStop) {
        if ([anItem isFolder])
            [anItems addObject:[ATBinderWrapper itemWrapperWithItem:anItem]];
        else
            [anItems addObject:[ATItemWrapper itemWrapperWithItem:anItem]];
    }];
    
    [self setItems:anItems];
}

- (void)removeAll
{
    [self setItems:nil];
    [self setSelectionIndexes:[NSMutableIndexSet indexSet]];
}

- (void)removeAllOfSelectedSingleBinder
{
    [[[self selectedItems] lastObject] removeAll];
}

- (NSUInteger)count
{
    return [[self items] count];
}

+ (BOOL)itemIsSingleBinder:(NSArray *)anItems
{
    return [anItems count] == 1 && [[anItems lastObject] isBinderWrapper];
}

- (BOOL)itemIsSingleBinder:(NSArray *)anItems
{
    return [ATBinderWrapper itemIsSingleBinder:anItems];
}

- (BOOL)selectedItemIsSingleBinder
{
    return [[self selectionIndexes] count] == 1 && [self itemIsSingleBinder:[self selectedItems]];
}

- (BOOL)selectionIsChanged
{
    return selectionIsChanged;
}

- (void)setSelectionIsChanged:(BOOL)aSelectionChanged
{
    selectionIsChanged = aSelectionChanged;
}

- (BOOL)itemsIsChanged
{
    return itemsIsChanged;
}

- (void)setItemsIsChanged:(BOOL)anItemsChanged
{
    itemsIsChanged = anItemsChanged;
}

- (void)discardChangeInfo
{
    [self setSelectionIsChanged:NO];
    [self setItemsIsChanged:NO];
}

@end

@implementation ATBinderWrapper (Coding)

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
	[aCharacter addOOPIvarWithName:@"items"];
    [aCharacter addOOPIvarWithName:@"selectionIndexes"];
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [super encodeWithAliaser:aChildminder];
    
    [aChildminder encodeObject:items];
    [aChildminder encodeObject:selectionIndexes];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    [super initWithAliaser:aChildminder];
    
    NUSetIvar(&items, [aChildminder decodeObjectReally]);
    NUSetIvar(&selectionIndexes, [aChildminder decodeObjectReally]);
    
    return self;
}


@end