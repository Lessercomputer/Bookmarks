//
//  ATBookmarksEnumerator.h
//  ATBookmarks
//
//  Created by 高田 明史 on 09/06/20.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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
