//
//  BookmarksEnumerator.h
//  Bookmarks
//
//  Created by Akifumi Takata on 09/06/20.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATBinder;

@interface ATBookmarksEnumerator : NSObject
{
	NSArray *binders;
	NSMutableSet *visitedItems;
	NSMutableArray *stack;
}

+ (id)enumeratorWithBinder:(ATBinder *)aBinder;
+ (id)enumeratorWithBinders:(NSArray *)aBinders;

- (id)initWithBinder:(ATBinder *)aBinder;
- (id)initWithBinders:(NSArray *)aBinders;

- (id)nextObject;

@end
