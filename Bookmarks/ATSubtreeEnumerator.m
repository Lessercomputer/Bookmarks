//
//  ATSubtreeEnumerator.m
//  Bookmarks
//
//  Created by Akifumi Takata on 07/08/22.
//  Copyright 2007 Nursery-Framework. All rights reserved.
//

#import "ATSubtreeEnumerator.h"
#import "ATElement.h"

@implementation ATSubtreeEnumerator

+ (ATSubtreeEnumerator *)enumeratorWithElement:(ATElement *)anElement
{
	return [[[self class] alloc] initWithElement:anElement];
}

- (ATSubtreeEnumerator *)initWithElement:(ATElement *)anElement
{
	[super init];
	
	element = [anElement retain];
	enumeratorStack = [[NSMutableArray alloc] initWithObjects:[element objectEnumerator], nil];
	
	return self;
}

- (void)dealloc
{
	[element release];
	[enumeratorStack release];
	
	[super dealloc];
}

- (id)nextObject
{	
	ATElement *anElement = nil;
	
	while (!anElement && [enumeratorStack count])
	{
		anElement = [[enumeratorStack lastObject] nextObject];
		
		if (anElement)
		{
			if ([anElement hasChildElement])
				[enumeratorStack addObject:[anElement objectEnumerator]];
		}
		else
			[enumeratorStack removeLastObject];
			
	}
	
	return anElement;
}

@end
