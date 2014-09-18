//
//  ATBinder.h
//  ATBookmarks
//
//  Created by 高田 明史  on 05/10/11.
//  Copyright 2005 Pedophilia. All rights reserved.
//

#import "ATItem.h"


@interface ATBinder : ATItem
{
	NSMutableArray *children;
}

@end

@interface ATBinder (Initializing)

+ (id)binder;

@end

@interface ATBinder (Accessing)

- (NSMutableArray *)children;
- (NSArray *)bookmarkItems;
- (void)setBookmarkItems:(NSArray *)anItems;

- (NSUInteger)count;
- (NSUInteger)countOfDescendant;

- (id)at:(NSUInteger)anIndex;
- (id)descendantAt:(NSUInteger *)anIndexRef;

- (id)atIndexPath:(NSIndexPath *)anIndexPath;

- (NSArray *)atIndexes:(NSIndexSet *)anIndexes;

- (NSUInteger)indexOf:(id)anItem;

- (NSIndexSet *)indexesOf:(NSArray *)anItems;

- (NSIndexSet *)allIndexesOfItem:(ATItem *)anItem;

- (id)itemFor:(NSUInteger)anID;

@end

@interface ATBinder (ItemID)

- (void)itemIDFrom:(ATBookmarks *)aBookmarks;

- (void)restoreItemIDTo:(ATBookmarks *)aBookmarks;

- (void)releaseItemIDFrom:(ATBookmarks *)aBookmarks;

@end

@interface ATBinder (Enumerating)

- (NSEnumerator *)objectEnumerator;

- (void)makeObjectsPerformSelector:(SEL)aSelector;
- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject;

@end

@interface ATBinder (Modifying)
- (void)insert:(id)anItem at:(NSUInteger)anIndex on:(ATBookmarks *)aBookmarks;
- (void)remove:(id)anItem on:(ATBookmarks *)aBookmarks;

- (void)add:(id)anItem;
- (void)insert:(id)anItem at:(NSUInteger)anIndex;
- (void)insert:(NSArray *)anItems atIndexes:(NSIndexSet *)anIndexes;
- (void)remove:(id)anItem;
- (void)removeAtIndexes:(NSIndexSet *)anIndexes;
@end

@interface ATBinder (Testing)
- (BOOL)isReachableFrom:(ATBinder *)aBinder;
@end

@interface ATBinder (Private)
- (void)setChildren:(NSMutableArray *)aChildren;
@end