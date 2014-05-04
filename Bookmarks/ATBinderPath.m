//
//  ATBinderPath.m
//  ATBookmarks
//
//  Created by 高田 明史 on 09/07/04.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ATBinderPath.h"
#import "ATBinder.h"


@implementation ATBinderPath

+ (id)binderPathWithRoot:(ATBinder *)aBinder
{
	return [[[self alloc] initWithRoot:aBinder] autorelease];
}

- (id)initWithRoot:(ATBinder *)aBinder
{
	[super init];
	
	[self setRoot:aBinder];
	
	return self;
}

- (void)dealloc
{
	[self setBinderPath:nil];
	
	[super dealloc];
}

- (ATBinder *)root
{
	return [self binderForColumn:0];
}

- (void)setRoot:(ATBinder *)aBinder
{
	if (aBinder)
		[self setBinderPath:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithObject:aBinder forKey:@"binder"]]];
	else
		[self setBinderPath:nil];
}

- (void)addColumnForBranch:(int)aRow inColumn:(int)aColumn
{
	NSLog(@"row: %d, column: %d", aRow, aColumn);
	
	[self setBranch:aRow inColumn:aColumn];
	[self addBinderPathComponentForRow:aRow inColumn:aColumn];
}

- (void)setSelections:(NSIndexSet *)aRows inColumn:(int)aColumn
{
	if (aColumn < 0) return;
	
	[self removeColumnsStartingAt:aColumn + 1];

	if ([aRows count] == 1 && [[[self binderForColumn:aColumn] at:[aRows lastIndex]] isFolder])
	{
		[self addColumnForBranch:[aRows lastIndex] inColumn:aColumn];
	}
	
	[[self binderPathComponentForColumn:aColumn] setObject:[[self binderForColumn:aColumn] atIndexes:aRows] forKey:@"selections"];
}

- (void)setSelectedItems:(NSArray *)aSelections inColumn:(int)aColumn
{
	[[self binderPathComponentForColumn:aColumn] setObject:[[aSelections copy] autorelease] forKey:@"selections"];
}

- (void)removeSelectedItems:(NSArray *)anItems from:(int)aColumn
{
	if (aColumn >= 0)
	{
		NSMutableArray *aSelections = [[[self selectedItemsInColumn:aColumn] mutableCopy] autorelease];
		
		if ([[self selectedItemsInColumn:aColumn] count] == 1 && [anItems containsObject:[[self selectedItemsInColumn:aColumn] lastObject]])
			[self removeColumnsStartingAt:aColumn + 1];
			
		[aSelections removeObjectsInArray:anItems];
		[self setSelectedItems:aSelections inColumn:aColumn];
		
		if ([[self selectedItemsInColumn:aColumn] count] == 1)
			[self setSelections:[NSIndexSet indexSetWithIndex:[[self binderForColumn:aColumn] indexOf:[[self selectedItemsInColumn:aColumn] lastObject]]] inColumn:aColumn];
	}
}

- (int)count
{
	return [[self binderPath] count];
}

- (NSArray *)binders
{
	NSMutableArray *aBinders = [NSMutableArray array];
	NSEnumerator *anEnumerator = [[self binderPath] objectEnumerator];
	NSDictionary *aDictionary = nil;
	
	while (aDictionary = [anEnumerator nextObject])
		[aBinders addObject:[aDictionary objectForKey:@"binder"]];
		
	return aBinders;
}

- (ATBinder *)lastBinder
{
	return [[self binders] lastObject];
}

- (BOOL)contains:(ATBinder *)aBinder
{
	return [self columnForBinder:aBinder] != -1;
}

- (ATBinder *)binderForColumn:(int)aColumn
{
	return [[self binderPathComponentForColumn:aColumn] objectForKey:@"binder"];
}

- (ATBinder *)binderBefore:(ATBinder *)aBinder
{
	int aColumn = [self columnBefore:aBinder];
	
	return aColumn >= 0 ? [self binderForColumn:aColumn] : nil;
}

- (ATBinder *)selectedBinder
{
	int aSelectedColumn = [self selectedColumn];
	
	return aSelectedColumn >= 0 ? [self binderForColumn:aSelectedColumn] : nil;
}

- (int)columnForBinder:(ATBinder *)aBinder
{
	NSUInteger aBinderIndex = [[self binders] indexOfObject:aBinder];
	
	return aBinderIndex == NSNotFound ? -1 : aBinderIndex;
}

- (int)selectedColumn
{
	if ([[self selectedItemsInColumn:[self lastColumn]] count])
		return [self lastColumn];
	else if ([self lastColumn] > 0)
		return [self lastColumn] - 1;
	else
		return 0;
}

- (int)lastColumn
{
	return [self count] - 1;
}

- (int)columnBefore:(ATBinder *)aBinder
{
	int aColumn = [self columnForBinder:aBinder];
	
	return aColumn > 0 ? aColumn - 1 : -1;
}

- (int)selectionInColumn:(int)aColumn
{
	NSDictionary *aPathComponent = [self binderPathComponentForColumn:aColumn];
	
	return [[aPathComponent objectForKey:@"binder"] indexOf:[aPathComponent objectForKey:@"selection"]];
}

- (NSIndexSet *)selectionsInColumn:(int)aColumn
{
	return [[self binderForColumn:aColumn] indexesOf:[self selectedItemsInColumn:aColumn]];
}

- (NSArray *)selectedItemsInColumn:(int)aColumn
{
	NSArray *aSelectedItems = [[self binderPathComponentForColumn:aColumn] objectForKey:@"selections"];
	
	return aSelectedItems ? aSelectedItems : [NSArray array];
}

- (NSArray *)selectedItems
{
	int aSelectedColumn = [self selectedColumn];
	
	return aSelectedColumn >= 0 ? [self selectedItemsInColumn:aSelectedColumn] : [NSArray array];
}

- (NSMutableDictionary *)binderPathComponentForColumn:(int)aColumn
{
	return [[self binderPath] objectAtIndex:aColumn];
}

- (void)setBranch:(int)aRow inColumn:(int)aColumn
{
	NSMutableDictionary *aPathComponent = [self binderPathComponentForColumn:aColumn];
	ATBinder *aBinder = [self binderForColumn:aColumn];
	
	[aPathComponent setObject:[aBinder at:aRow] forKey:@"selection"];
}

- (void)addBinderPathComponentForRow:(int)aRow inColumn:(int)aColumn
{
	ATBinder *aSelectedBinder = [[self binderForColumn:aColumn] at:aRow];
	
	[[self binderPath] addObject:[NSMutableDictionary dictionaryWithObject:aSelectedBinder forKey:@"binder"]];
}

- (void)removeColumnsStartingAt:(int)aColumn
{
	NSRange aRemoveRange = NSMakeRange(aColumn, [self count] - aColumn);
	
	if (aRemoveRange.length)
		[[self binderPath] removeObjectsInRange:aRemoveRange];	
}

- (void)removeColumnsStartingWith:(ATBinder *)aBinder
{
	[self removeColumnsStartingAt:[self columnForBinder:aBinder]];
}

- (int)firstColumnIn:(NSArray *)aBinders
{
	NSUInteger aFirstColumn = NSNotFound;
	NSEnumerator *anEnumerator = [aBinders objectEnumerator];
	ATBinder *aBinder = nil;
	
	while (aBinder = [anEnumerator nextObject])
	{
		int aColumn = [self columnForBinder:aBinder];
		
		if (aColumn != -1 && aColumn < aFirstColumn)
			aFirstColumn = aColumn;
	}
	
	return aFirstColumn != NSNotFound ? aFirstColumn : -1;
}

- (void)items:(NSArray *)anItems didInsertFrom:(ATBinder *)aSource to:(ATBinder *)aDestination
{
	//[self removeSelectedItems:anItems from:[self columnForBinder:aSource]];
}

- (void)items:(NSArray *)anItems didMoveFrom:(ATBinder *)aSource to:(ATBinder *)aDestination
{
	NSArray *aBinders = [ATItem bindersIn:anItems];
	NSEnumerator *anEnumerator = [aBinders objectEnumerator];
	ATBinder *aBinder = nil;
	
	while (aBinder = [anEnumerator nextObject])
	{
		if ([self contains:aBinder])
		{
			ATBinder *aBeforeBinder = [self binderBefore:aBinder];
			
			if (![aSource isEqual:aDestination] && ![aBeforeBinder isEqual:aDestination])
				[self setSelections:[NSIndexSet indexSet] inColumn:[self columnBefore:aBinder]];
		}
	}
	
	if (![aSource isEqual:aDestination] && [self contains:aSource])
		[self removeSelectedItems:anItems from:[self columnForBinder:aSource]];
}

- (void)items:(NSArray *)anItems didRemoveFrom:(ATBinder *)aSource
{
	[self removeSelectedItems:anItems from:[self columnForBinder:aSource]];
}

- (NSMutableArray *)binderPath
{
	return binderPath;
}

- (void)setBinderPath:(NSMutableArray *)aBinderPath
{
	[binderPath release];
	binderPath = [aBinderPath retain];
}

@end
