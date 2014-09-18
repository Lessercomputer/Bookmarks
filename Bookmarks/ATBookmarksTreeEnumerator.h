//
//  BookmarksTreeEnumerator.h
//  Bookmarks
//
//  Created by 高田 明史 on 09/05/02.
//  Copyright 2009 Pedophilia. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ATBookmarksTreeEnumerator : NSObject
{
	NSDictionary *root;
	NSMutableArray *stack;
	id delegate;
	SEL upSelector;
}

- (id)initWithRoot:(NSDictionary *)aRoot delegate:(id)aDelegate upSelector:(SEL)aSelector;

- (id)nextObject;

@end
