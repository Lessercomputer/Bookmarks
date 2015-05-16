//
//  ATBookmarkItemsMoveOperation.h
//  Bookmarks
//
//  Created by P,T,A on 09/08/13.
//  Copyright 2009 PEDOPHILIA. All rights reserved.
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
