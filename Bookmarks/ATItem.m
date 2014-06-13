//
//  ATItem.m
//  ATBookmarks
//
//  Created by 明史 on 05/10/11.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "ATItem.h"
#import "ATBinder.h"
#import "ATBookmarks.h"
#import <Nursery/NUTypes.h>

@implementation ATItem

@end

@implementation ATItem (Initializing)

+ (id)newWith:(NSDictionary *)aPropertyList
{
	return [[self alloc] initWith:aPropertyList];
}

- (id)initWith:(NSDictionary *)aPropertyList
{
	[super init];
	
	[self setName:[aPropertyList objectForKey:@"name"]];
	[self setItemID:[[aPropertyList objectForKey:@"itemID"] unsignedIntegerValue]];
	[self setAddDate:[aPropertyList objectForKey:@"addDate"]];
	
	[self setBinders:[NSMutableSet set]];
	
	return self;
}

- (id)init
{
	[super init];
	
	[self setItemID:ATItemInvalidItemID];
	[self setBinders:[NSMutableSet set]];
	
	return self;
}

- (void)dealloc
{
    [binders release];
    [name release];
	[comment release];
    [addDate release];
    
	[super dealloc];
}

@end

@implementation ATItem (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{    
    [aCharacter addUInt64IvarWithName:@"itemID"];
    [aCharacter addOOPIvarWithName:@"binders"];
    [aCharacter addOOPIvarWithName:@"name"];
    [aCharacter addOOPIvarWithName:@"comment"];
    [aCharacter addOOPIvarWithName:@"addDate"];
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [aChildminder encodeUInt64:[self itemID]];
    [aChildminder encodeObject:binders];
    [aChildminder encodeObject:name];
    [aChildminder encodeObject:comment];
    [aChildminder encodeObject:addDate];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    [super init];
    
    itemID = [aChildminder decodeUInt64];
    NUSetIvar(&binders, [aChildminder decodeObject]);
    NUSetIvar(&name, [aChildminder decodeObject]);
    NUSetIvar(&comment, [aChildminder decodeObject]);
    NUSetIvar(&addDate, [aChildminder decodeObject]);
    
    return self;
}

- (NUBell *)bell
{
    return bell;
}

- (void)setBell:(NUBell *)anOOP
{
    bell = anOOP;
}

@end

@implementation ATItem (Accessing)

- (NSUInteger)itemID
{
	return itemID;
}

- (NSNumber *)numberWithItemID
{
	return [NSNumber numberWithUnsignedInteger:[self itemID]];
}

- (ATBinder *)parent
{
	return [self isRoot] ? nil : parent;
}

- (NSMutableArray *)binders
{
    return NUGetIvar(&binders);
}

- (ATBookmarks *)bookmarks
{
	if ([self isRoot])
		return (ATBookmarks *)parent;
	else
		return [[self parent] bookmarks];
}

- (void)setName:(NSString *)aName
{
    [self willChangeValueForKey:@"name"];
    NUSetIvar(&name, aName);
    [self didChangeValueForKey:@"name"];
}

- (NSString *)name
{
    return NUGetIvar(&name);
}

- (NSString *)comment
{
    return NUGetIvar(&comment);
}

- (void)setComment:(NSString *)aComment
{
    NUSetIvar(&comment, aComment);
    [[[self bell] playLot] markChangedObject:self];
}

- (NSDate *)addDate
{
    return NUGetIvar(&addDate);
}

- (void)setAddDate:(NSDate *)aDate
{
    NUSetIvar(&addDate, aDate);
    [[[self bell] playLot] markChangedObject:self];
}

- (NSUInteger)index
{
	return [[self parent] indexOf:self];
}

- (ATBinder *)root
{
	id anItem = self;
	
	while (![anItem isRoot])
	{
		anItem = [anItem parent];
	}
	
	return anItem;
}

- (NSIndexPath *)indexPath
{
	if ([self isRoot])
		return nil;
	else
	{
		NSIndexPath *anIndexPath = [[self parent] indexPath];
		
		if (anIndexPath)
			return [anIndexPath indexPathByAddingIndex:[self index]];
		else
			return [NSIndexPath indexPathWithIndex:[self index]];
	}
}

- (void)writeIndexPathOn:(NSMutableArray *)anArray
{
	[anArray addObject:[self indexPath]];
}

- (id)itemFor:(NSUInteger)anID
{
	return [self itemID] == anID ? self : nil;
}

+ (NSArray *)editableValueKeys
{
	return [NSArray arrayWithObjects:@"name", @"comment", @"addDate", nil];
}

- (NSArray *)editableValueKeys
{
	return [[self class] editableValueKeys];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p> id: %lu, name:%@", [self class], self, [self itemID], [self name]];
}

@end

@implementation ATItem (ItemID)

- (void)itemIDFrom:(ATBookmarks *)aBookmarks
{
	[aBookmarks newItemIDTo:self];
}

- (void)restoreItemIDTo:(ATBookmarks *)aBookmarks
{
	[aBookmarks restoreItemIDOf:self];
}

- (void)releaseItemIDFrom:(ATBookmarks *)aBookmarks
{
	[aBookmarks releseItemIDOf:self];
}

- (void)invalidateItemID
{
	[self setItemID:ATItemInvalidItemID];
}

- (void)writeItemIDOn:(NSMutableArray *)anArray
{
	[anArray addObject:[self numberWithItemID]];
}

@end

@implementation ATItem (Modifying)

- (NSUInteger)moveTo:(NSUInteger)anIndex of:(ATBinder *)aDestination from:(ATBinder *)aSource on:(ATBookmarks *)aBookmarks
{
	NSUndoManager *anUndoManager = [aBookmarks undoManager];
	unsigned aFixedIndex = anIndex, anIndexToUndoOrRedo = [aSource indexOf:self];
	
	if ([aSource isEqual:aDestination])
	{
		if (anIndexToUndoOrRedo < anIndex)//現在位置よりも後ろに移動
			aFixedIndex = anIndex - 1;
		else if (anIndex < anIndexToUndoOrRedo)//現在位置よりも前に移動
			anIndexToUndoOrRedo += 1;
	}

	[self retain];
	[[anUndoManager prepareWithInvocationTarget:self] moveTo:anIndexToUndoOrRedo of:aSource from:aDestination on:aBookmarks];
	[aSource remove:self];
	[aDestination insert:self at:aFixedIndex];
	[self release];
	
	return aFixedIndex;
}

@end

@implementation ATItem (Testing)

- (BOOL)isBookmark
{
	return NO;
}

- (BOOL)isFolder
{
	return NO;
}

- (BOOL)isRoot
{
	//return [self parent] ? NO : YES;
	return [parent isKindOfClass:[ATBookmarks class]] || !parent;
}

- (BOOL)hasItemID
{	
	return [self itemID] == ATItemInvalidItemID ? NO : YES;
}

- (BOOL)canMoveFrom:(ATBinder *)aSourceBinder to:(ATBinder *)aDestinationBinder
{
	return [aDestinationBinder isEqual:aSourceBinder] || [aDestinationBinder indexOf:self] == NSNotFound;
}

- (BOOL)canInsertTo:(ATBinder *)aBinder
{
	return [aBinder indexOf:self] == NSNotFound;
}

- (BOOL)isDescendantOf:(ATBinder *)aFolder
{
	ATBinder *aParent = [self parent];
	
	while (aParent && ![aParent isEqual:aFolder])
	{
		aParent = [aParent parent];
	}
	
	return aParent ? YES : NO;
}

- (BOOL)isDescendantIn:(NSArray *)anItems
{
	NSEnumerator *anEnumerator = [anItems objectEnumerator];
	id anItem = nil;
	BOOL anIsDescendant = NO;
	
	while (!anIsDescendant && (anItem = [anEnumerator nextObject]))
	{
		anIsDescendant = [self isDescendantOf:anItem];
	}
	
	return anIsDescendant;
}

- (BOOL)eachAncestorsIsOpen
{
	return [self isRoot] || ([[self parent] isOpen] && [[self parent] eachAncestorsIsOpen]);
}

- (NSComparisonResult)compareItemID:(ATItem *)anAnotherItem
{
	if ([self itemID] < [anAnotherItem itemID])
		return NSOrderedAscending;
	else if ([self itemID] > [anAnotherItem itemID])
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

- (NSComparisonResult)compareIndex:(ATItem *)anAnotherItem	
{
	if ([self index] < [anAnotherItem index])
		return NSOrderedAscending;
	else if ([self index] > [anAnotherItem index])
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

@end

@implementation ATItem (Editing)

- (NSDictionary *)valueToEdit
{
	return [self dictionaryWithValuesForKeys:[self editableValueKeys]];
}

- (NSDictionary *)acceptEdited:(NSDictionary *)aValue
{
	NSDictionary *aChangedValues = [self changedValuesFor:aValue];
	NSDictionary *anOldValues = [self dictionaryWithValuesForKeys:[aChangedValues allKeys]];
	
	if (aChangedValues)
	{        
		[self setValuesForKeysWithDictionary:aChangedValues];
		
        [[[self bell] playLot] markChangedObject:self];

		return anOldValues;
	}
	else
		return nil;
}

- (NSDictionary *)acceptEdited:(NSDictionary *)aValue on:(NSValue *)aBookmarks
{
	NSDictionary *anOldValues = [self acceptEdited:aValue];
	
	if (anOldValues)
		[[[[aBookmarks nonretainedObjectValue] undoManager] prepareWithInvocationTarget:self] acceptEdited:anOldValues on:aBookmarks];
		
	return anOldValues;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey
{
	return [[self editableValueKeys] containsObject:theKey] ? NO : [super automaticallyNotifiesObserversForKey:theKey];
}

@end

@implementation ATItem (Converting)

- (NSMutableDictionary  *)propertyListRepresentation
{
	NSMutableDictionary *aPlist = [NSMutableDictionary dictionaryWithObjectsAndKeys:NSStringFromClass([self class]), @"class", [self numberWithItemID], @"itemID", nil];
	
	if ([self name])
		[aPlist setObject:[self name] forKey:@"name"];
	if ([self addDate])
		[aPlist setObject:[self addDate] forKey:@"addDate"];
	
	return aPlist;
}

- (void)writeOn:(NSMutableArray *)anArray
{
	[anArray addObject:[self propertyListRepresentation]];
}

@end

@implementation ATItem (Selecting)

+ (NSArray *)minimum:(NSArray *)anItems
{
	NSEnumerator *enumerator = [anItems objectEnumerator];
	id item  = nil;
	NSMutableArray *minimumItems = [NSMutableArray array];

	while (item  = [enumerator nextObject])
	{
		if (![item isDescendantIn:anItems])
			[minimumItems addObject:item];
	}
	
	return minimumItems;
}

+ (NSArray *)categorizeByParentAndIndex:(NSArray *)anItems
{
	NSArray *aCategorizedByParentItems = [self categorizeByParent:[self minimum:anItems]];
	NSEnumerator *anEnum = [aCategorizedByParentItems objectEnumerator];
	id anItem = nil;
	NSMutableArray *aCategorizedByParentAndIndexItems = [NSMutableArray array];

	while (anItem = [anEnum nextObject])
	{
		[aCategorizedByParentAndIndexItems addObject:[self categorizeByIndex:anItems]];
	}
	
	return aCategorizedByParentAndIndexItems;
}

+ (NSArray *)categorizeByParent:(NSArray *)anItems
{
	NSMutableDictionary *aCategorizedDict = [NSMutableDictionary dictionary];
	NSEnumerator *anEnum = [anItems objectEnumerator];
	id anItem = nil;

	while (anItem = [anEnum nextObject])
	{
		NSNumber *anItemID = [NSNumber numberWithUnsignedInteger:[anItem itemID]];
		NSMutableArray *aCategorizedItems = [aCategorizedDict objectForKey:anItemID];

		if (!aCategorizedItems)
		{
			aCategorizedItems = [NSMutableArray array];
			[aCategorizedDict setObject:aCategorizedItems forKey:anItemID];
		}

		[aCategorizedItems addObject:anItem];
	}
	
	return [aCategorizedDict allValues];
}

+ (NSArray *)categorizeByIndex:(NSArray *)anItems
{
	NSMutableArray *aCategorizedItems = [NSMutableArray array];
	unsigned i = 0;

	while (i < [anItems count])
	{
		BOOL indexContinued = YES;
		id aFirstItem = [anItems objectAtIndex:i];
		unsigned anIndex = [aFirstItem index];

		[aCategorizedItems addObject:[NSMutableArray array]];
		[[aCategorizedItems lastObject] addObject:aFirstItem];

		for (++i ; i < [anItems count] && indexContinued ; i++)
		{
			id aNextItem = [anItems objectAtIndex:i];

			indexContinued = (++anIndex == [aNextItem index]);

			if (indexContinued)
				[[aCategorizedItems lastObject] addObject:aNextItem];
			else
				i--;
		}
	}
	
	return aCategorizedItems;
}

+ (NSArray *)bindersIn:(NSArray *)anItems
{
	NSMutableArray *aBinders = [NSMutableArray array];
	NSEnumerator *anEnumerator = [anItems objectEnumerator];
	ATItem *anItem = nil;
	
	while (anItem = [anEnumerator nextObject])
	{
		if ([anItem isFolder])
			[aBinders addObject:anItem];
	}
	
	return aBinders;
}

@end

@implementation ATItem (Private)

- (void)setItemID:(NSUInteger)anID
{
	itemID = anID;
    [[[self bell] playLot] markChangedObject:self];
}

- (void)setParent:(ATBinder *)aFolder;
{
	parent = aFolder;
}

- (void)addBinder:(ATBinder *)aBinder
{
	[[self binders] addObject:aBinder];
    [[[self bell] playLot] markChangedObject:[self binders]];
}

- (void)removeBinder:(ATBinder *)aBinder
{
	[[self binders] removeObject:aBinder];
    [[[self bell] playLot] markChangedObject:[self binders]];
}

- (void)setBinders:(NSMutableSet *)aBinders
{
    NUSetIvar(&binders, aBinders);
//    [[[self bell] playLot] markChangedObject:[self binders]];
}

@end

@implementation ATItem (Validating)

- (BOOL)validateName:(id *)ioValue error:(NSError **)outError
{
	id aNewValue = [[NSValueTransformer valueTransformerForName:@"ATNullBetweenNilTransformer"] transformedValue:*ioValue];
	
	*ioValue = aNewValue;
	return YES;
}



- (BOOL)validateEdited:(NSDictionary *)aValue
{
	NSError *anError;
	NSEnumerator *anEnumerator = [aValue keyEnumerator];
	NSString *aKey;
	id aNewValue;
	BOOL aValueIsValid = YES;
	
	while (aValueIsValid && (aKey = [anEnumerator nextObject]))
	{
		aNewValue = [aValue valueForKey:aKey];
		aValueIsValid = [self validateValue:&aNewValue forKey:aKey error:&anError];
	}
	
	return aValueIsValid;
}

- (BOOL)hasChagned:(NSDictionary *)aValue
{
	return [self changedValuesFor:aValue] ? YES : NO;
}

- (NSDictionary *)changedValuesFor:(NSDictionary *)anEditedValues
{
	if ([self validateEdited:anEditedValues])
	{
		NSMutableDictionary *aChangedValues = [NSMutableDictionary dictionary];
		NSEnumerator *anEnumerator = [anEditedValues keyEnumerator];
		NSString *aKey;
		
		while (aKey = [anEnumerator nextObject])
		{
			id anOldValue = [self valueForKey:aKey], aNewValue = [anEditedValues objectForKey:aKey];
			
			anOldValue = [[NSValueTransformer valueTransformerForName:@"ATNullBetweenNilTransformer"] reverseTransformedValue:anOldValue];
			
			if (![anOldValue isEqual:aNewValue])
				[aChangedValues setObject:aNewValue forKey:aKey];
		}
		
		return [aChangedValues count] ? aChangedValues : nil;
	}
	else
		return nil;
}

@end

@implementation ATItem (ScriptingSupport)

- (NSScriptObjectSpecifier *)objectSpecifier
{
	NSScriptObjectSpecifier *aSpecifier = [[self bookmarks] objectSpecifier];
	
	return [[[NSUniqueIDSpecifier alloc] initWithContainerClassDescription:[aSpecifier keyClassDescription] containerSpecifier:aSpecifier key:@"bookmarkItems" uniqueID:[self numberWithItemID]] autorelease];
}

@end