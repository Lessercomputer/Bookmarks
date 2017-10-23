//
//  ATMoveOperationItem.h
//  Bookmarks
//
//  Created by P,T,A on 09/08/13.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATItem;

@interface ATMoveOperationItem : NSObject
{
	ATItem *item;
	BOOL canMove;
}

+ (id)moveOperationItemWith:(ATItem *)anItem canMove:(BOOL)aCanMove;
- (id)initWithItem:(ATItem *)anItem canMove:(BOOL)aCanMove;

- (ATItem *)item;
- (BOOL)canMove;

@end
