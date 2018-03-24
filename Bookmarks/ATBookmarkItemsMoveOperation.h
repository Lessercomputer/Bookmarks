//
//  ATBookmarkItemsMoveOperation.h
//  Bookmarks
//
//  Created by Akifumi Takata on 09/08/13.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATItem;

@interface ATBookmarkItemsMoveOperation : NSObject
{
	NSMutableArray *items;
}

+ (id)operation;

- (void)add:(ATItem *)anItem movable:(BOOL)aMovable;

- (NSEnumerator *)objectEnumerator;

@end
