//
//  BookmarksTreeEnumerator.h
//  Bookmarks
//
//  Created by P,T,A on 09/05/02.
//  Copyright 2009 PEDOPHILIA. All rights reserved.
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
