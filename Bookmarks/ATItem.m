//
//  ATItem.m
//  Bookmarks
//
//  Created by P,T,A  on 05/10/11.
//  Copyright 2005 Nursery-Framework. All rights reserved.
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

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
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

- (NSMutableArray *)binders
{
    return NUGetIvar(&binders);
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
    [[[self bell] sandbox] markChangedObject:self];
}

- (NSDate *)addDate
{
    return NUGetIvar(&addDate);
}

- (void)setAddDate:(NSDate *)aDate
{
    NUSetIvar(&addDate, aDate);
    [[[self bell] sandbox] markChangedObject:self];
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

- (NSComparisonResult)compareItemID:(ATItem *)anAnotherItem
{
	if ([self itemID] < [anAnotherItem itemID])
		return NSOrderedAscending;
	else if ([self itemID] > [anAnotherItem itemID])
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
		
        [[[self bell] sandbox] markChangedObject:self];

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

@implementation ATItem (Kidnapping)

- (void)removeToKidnap
{
    NSArray *aBinders = [[[self binders] copy] autorelease];
    [aBinders enumerateObjectsUsingBlock:^(ATBinder *aBinder, NSUInteger idx, BOOL *stop) {
        [aBinder remove:self];
    }];
}

@end
@implementation ATItem (Private)

- (void)setItemID:(NSUInteger)anID
{
	itemID = anID;
    [[[self bell] sandbox] markChangedObject:self];
}

- (void)addBinder:(ATBinder *)aBinder
{
	[[self binders] addObject:aBinder];
    [[[self bell] sandbox] markChangedObject:[self binders]];
}

- (void)removeBinder:(ATBinder *)aBinder
{
	[[self binders] removeObject:aBinder];
    [[[self bell] sandbox] markChangedObject:[self binders]];
}

- (void)setBinders:(NSMutableSet *)aBinders
{
    NUSetIvar(&binders, aBinders);
//    [[[self bell] sandbox] markChangedObject:[self binders]];
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

@end
