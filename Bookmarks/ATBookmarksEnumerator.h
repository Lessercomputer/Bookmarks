//
//  BookmarksEnumerator.h
//  Bookmarks
//
//  Created by P,T,A on 09/06/20.
//  Copyright 2009 PEDOPHILIA. All rights reserved.
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
