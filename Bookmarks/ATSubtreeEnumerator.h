//
//  ATSubtreeEnumerator.h
//  Bookmarks
//
//  Created by 高田 明史 on 07/08/22.
//  Copyright 2007 Pedophilia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATElement;

@interface ATSubtreeEnumerator : NSEnumerator
{
	ATElement *element;
	NSMutableArray *enumeratorStack;
}

+ (ATSubtreeEnumerator *)enumeratorWithElement:(ATElement *)anElement;

- (ATSubtreeEnumerator *)initWithElement:(ATElement *)anElement;

@end
