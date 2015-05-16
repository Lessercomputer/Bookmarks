//
//  ATSubtreeEnumerator.h
//  Bookmarks
//
//  Created by P,T,A on 07/08/22.
//  Copyright 2007 PEDOPHILIA. All rights reserved.
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
