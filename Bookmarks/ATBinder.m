//
//  ATBinder.m
//  ATBookmarks
//
//  Created by 明史 on 05/10/11.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "ATBinder.h"
#import "ATBookmarks.h"
#import "ATBookmarksEnumerator.h"


@implementation ATBinder

@end

@implementation ATBinder (Initializing)

+ (id)binder
{
    return [[[self alloc] init] autorelease];
}

- (id)initWith:(NSDictionary *)aPropertyList
{
	/*NSEnumerator *anEnumerator = [[aPropertyList objectForKey:@"children"] objectEnumerator];
	NSDictionary *anItem = nil;*/
	
	[super initWith:aPropertyList];
	
	[self setChildren:[NSMutableArray array]];
	
	//while (anItem = [anEnumerator nextObject])
//	{
//		Class aClass = [[anItem objectForKey:@"class"] isEqualToString:@"ATFolder"] ? [ATBinder class] : NSClassFromString([anItem objectForKey:@"class"]);
//		
//		[self insert:[aClass newWith:anItem] at:[[self children] count]];
//	}
	
	[self setIsOpen:[[aPropertyList objectForKey:@"isOpen"] boolValue]];
	
	return self;
}

- (id)init
{
	[super init];
	
	[self setChildren:[NSMutableArray array]];
	
	return self;
}

- (void)dealloc
{
    [children release];
	
	[super dealloc];
}

@end

@implementation ATBinder (Coding)

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    [aCharacter addOOPIvarWithName:@"children"];
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [super encodeWithAliaser:aChildminder];
    
    [aChildminder encodeObject:children];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    [super initWithAliaser:aChildminder];
    
    NUSetIvar(&children, [aChildminder decodeObject]);
        
    return self;
}

@end

@implementation ATBinder (Accessing)

- (NSMutableArray *)children
{
    return NUGetIvar(&children);
}

- (NSArray *)bookmarkItems
{
	return [self children];
}

- (void)setBookmarkItems:(NSArray *)anItems
{
	[self setChildren:[[anItems mutableCopy] autorelease]];
}

- (NSUInteger)count
{
	return [[self children] count];
}

- (NSUInteger)countOfDescendant
{
	unsigned aCountOfDescendant = [self count];
	NSEnumerator *anEnumerator = [[self children] objectEnumerator];
	id anItem = nil;
	
	while (anItem = [anEnumerator nextObject])
	{
		if ([anItem isFolder])
			aCountOfDescendant += [anItem countOfDescendant];
	}
	
	return aCountOfDescendant;
}

- (id)at:(NSUInteger)anIndex
{
	return [[self children] objectAtIndex:anIndex];
}

- (id)descendantAt:(unsigned *)anIndexRef
{
	NSEnumerator *anEnumerator = [[self children] objectEnumerator];
	ATItem *aChild = nil, *aDescendant = nil;
	BOOL aDescendantFound = NO;
	
	while (!aDescendantFound && (aChild = [anEnumerator nextObject]))
	{
		if ((*anIndexRef) == 0)
		{
			aDescendant = aChild;
			aDescendantFound = YES;
		}
		else 
		{
			(*anIndexRef)--;
			
			if ([aChild isFolder])
			{
				aDescendant = [aChild descendantAt:anIndexRef];
			
				if (aDescendant)
					aDescendantFound = YES;
			}
		}
	}
			
	return aDescendant;
}

- (id)atIndexPath:(NSIndexPath *)anIndexPath
{
	id anItem = [self at:[anIndexPath indexAtPosition:0]];
	
	if ([anIndexPath length] == 1)
		return anItem;
	else
	{
		NSUInteger *anIndexes = malloc(sizeof(unsigned int) * [anIndexPath length]);
		NSIndexPath *aShrinkedIndexPath = nil;
		
		[anIndexPath getIndexes:anIndexes];
		aShrinkedIndexPath = [NSIndexPath indexPathWithIndexes:(anIndexes + 1) length:([anIndexPath length] - 1)];
		
		free(anIndexes);
		
		return [anItem atIndexPath:aShrinkedIndexPath];
	}
}

- (NSArray *)atIndexes:(NSIndexSet *)anIndexes
{
	NSMutableArray *anItems = [NSMutableArray array];
	NSUInteger i;
	
	for (i = [anIndexes firstIndex]; i != NSNotFound; i = [anIndexes indexGreaterThanIndex:i])
	{
			[anItems addObject:[[self children] objectAtIndex:i]];
	}
	
	return anItems;
}

- (NSUInteger)indexOf:(id)anItem
{
	return [[self children] indexOfObject:anItem];
}

- (NSIndexSet *)indexesOf:(NSArray *)anItems
{
	NSEnumerator *anEnumerator = [anItems objectEnumerator];
	ATItem *anItem = nil;
	NSMutableIndexSet *anIndexes = [NSMutableIndexSet indexSet];
	
	while (anItem = [anEnumerator nextObject])
		[anIndexes addIndex:[self indexOf:anItem]];
		
	return anIndexes;
}

- (id)itemFor:(NSUInteger)anID
{
	if ([super itemFor:anID])
		return self;
	else
	{
		NSEnumerator *anEnumerator = [[self children] objectEnumerator];
		id aChild = nil;
		id anItem = nil;

		while (!anItem && (aChild = [anEnumerator nextObject]))
		{
			anItem = [aChild itemFor:anID];
		}
		
		return anItem;
	}
}

@end

@implementation ATBinder (ItemID)

- (void)itemIDFrom:(ATBookmarks *)aBookmarks
{
	[super itemIDFrom:aBookmarks];
	//[self makeObjectsPerformSelector:@selector(itemIDFrom:) withObject:aBookmarks];
}

- (void)restoreItemIDTo:(ATBookmarks *)aBookmarks
{
	[super restoreItemIDTo:aBookmarks];
	
	[[self children] makeObjectsPerformSelector:@selector(restoreItemIDTo:) withObject:aBookmarks];
}

- (void)releaseItemIDFrom:(ATBookmarks *)aBookmarks;
{
	[[self children] makeObjectsPerformSelector:@selector(releaseItemIDFrom:) withObject:aBookmarks];
	
	[super releaseItemIDFrom:aBookmarks];
}

- (void)invalidateItemID
{
	[super invalidateItemID];
	//[self makeObjectsPerformSelector:@selector(invalidateItemID)];
    
}

@end

@implementation ATBinder (Enumerating)

- (NSEnumerator *)objectEnumerator
{
	return [[self children] objectEnumerator];
}

- (void)makeObjectsPerformSelector:(SEL)aSelector
{
	ATBookmarksEnumerator *anEnumerator = [ATBookmarksEnumerator enumeratorWithBinder:self];
	ATItem *anItem = nil;
		
	while (anItem = [anEnumerator nextObject])
		if (![anItem isEqual:self]) [anItem performSelector:aSelector];	
}

- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)anObject
{
	ATBookmarksEnumerator *anEnumerator = [ATBookmarksEnumerator enumeratorWithBinder:self];
	ATItem *anItem = nil;
		
	while (anItem = [anEnumerator nextObject])
		if (![anItem isEqual:self]) [anItem performSelector:aSelector withObject:anObject];
}

@end

@implementation ATBinder (Testing)

- (BOOL)isFolder
{
	return YES;
}

- (BOOL)isOpen
{
	return isOpen;
}

- (BOOL)setIsOpen:(BOOL)aFlag
{
	if (isOpen != aFlag)
	{
		isOpen = aFlag;
		
		return YES;
	}
	else
		return NO;
}

- (BOOL)canMoveFrom:(ATBinder *)aSourceBinder to:(ATBinder *)aDestinationBinder
{
	if ([aSourceBinder isEqual:aDestinationBinder])
		return YES;
	else
	{
		if ([aDestinationBinder isReachableFrom:self]) return NO;
		
		if (![aSourceBinder isEqual:aDestinationBinder] && [aDestinationBinder indexOf:self] != NSNotFound) return NO;
				
		return YES;
	}
}

- (BOOL)isReachableFrom:(ATBinder *)aBinder
{
	ATBookmarksEnumerator *anEnumerator = [ATBookmarksEnumerator enumeratorWithBinders:[NSArray arrayWithObject:aBinder]];
	ATItem *anItem = nil;
	
	while (anItem = [anEnumerator nextObject])
	{
		if ([anItem isFolder] && [anItem isEqual:self])
			return YES;
	}

	return NO;
}

@end

@implementation ATBinder (Modifying)

- (void)insert:(id)anItem at:(NSUInteger)anIndex on:(ATBookmarks *)aBookmarks
{	
	[[[aBookmarks undoManager] prepareWithInvocationTarget:self] remove:anItem on:aBookmarks];
		
	[self insert:anItem at:anIndex];
}

- (void)remove:(id)anItem on:(ATBookmarks *)aBookmarks
{	
	[[[aBookmarks undoManager] prepareWithInvocationTarget:self] insert:anItem at:[self indexOf:anItem] on:aBookmarks];
			
	[self remove:anItem];
}

- (void)add:(id)anItem
{
	[anItem setParent:self];
	[anItem addBinder:self];
	[[self children] addObject:anItem];
}

- (void)insert:(id)anItem at:(NSUInteger)anIndex
{
	[anItem setParent:self];
	[anItem addBinder:self];
	[[self children] insertObject:anItem atIndex:anIndex];
}

- (void)insert:(NSArray *)anItems atIndexes:(NSIndexSet *)anIndexes
{
    [anItems makeObjectsPerformSelector:@selector(addBinder:) withObject:self];
    [[self children] insertObjects:anItems atIndexes:anIndexes];
    [[[self bell] playLot] markChangedObject:[self children]];
}

- (void)remove:(id)anItem
{
	[anItem setParent:nil];
	[anItem removeBinder:self];
	[[self children] removeObject:anItem];
}

- (void)removeAtIndexes:(NSIndexSet *)anIndexes
{
    [[self atIndexes:anIndexes] makeObjectsPerformSelector:@selector(removeBinder:) withObject:self];
    [[self children] removeObjectsAtIndexes:anIndexes];
    [[[self bell] playLot] markChangedObject:[self children]];
}

@end

@implementation ATBinder (Converting)

- (NSMutableDictionary  *)propertyListRepresentation
{
	NSMutableDictionary *aPlist = [super propertyListRepresentation];
	NSEnumerator *anEnumerator = [[self children] objectEnumerator];
	id anItem = nil;
	
	[aPlist setObject:[NSMutableArray array] forKey:@"children"];
	
	while (anItem = [anEnumerator nextObject])
		[[aPlist objectForKey:@"children"] addObject:[anItem numberWithItemID]];
	
	[aPlist setObject:[NSNumber numberWithBool:[self isOpen]] forKey:@"isOpen"];
	
	return aPlist;
}

@end

@implementation ATBinder (Private)

- (void)setChildren:(NSMutableArray *)aChildren
{
    NUSetIvar(&children, aChildren);
    [[[self bell] playLot] markChangedObject:self];
}

@end