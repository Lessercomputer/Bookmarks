//
//  ATBookmark.m
//  ATBookmarks
//
//  Created by 明史 on 05/10/11.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "ATBookmark.h"


@implementation ATBookmark

@end

@implementation ATBookmark (Initializing)

+ (void)initialize
{
    [self setKeys:[NSArray arrayWithObject:@"url"] triggerChangeNotificationsForDependentKey:@"urlString"];
}

+ (id)bookmark
{
    return [[[self alloc] init] autorelease];
}

- (id)initWith:(NSDictionary *)aPropertyList
{	
	[super initWith:aPropertyList];
	
	[self setUrlString:[aPropertyList objectForKey:@"urlString"]];
	[self setIconDataType:[aPropertyList objectForKey:@"iconDataType"]];
	[self setIconData:[aPropertyList objectForKey:@"iconData"]];
	[self setLastVisitDate:[aPropertyList objectForKey:@"lastVisitDate"]];
	[self setLastModifiedDate:[aPropertyList objectForKey:@"lastModifiedDate"]];
	[self setComment:[aPropertyList objectForKey:@"comment"]];
		
	return self;
}

+ (id)newWithName:(NSString *)aName urlString:(NSString *)aURLString
{
	return [[[self alloc] initWithName:aName urlString:aURLString] autorelease];
}

- (id)initWithName:(NSString *)aName urlString:(NSString *)aURLString
{
	[super init];
	
	[self setName:aName];
	[self setUrlString:aURLString];
	
	return self;
}

- (void)dealloc
{    
    [url release];
    [iconData release];
    [iconDataType release];
    [icon release];
	
	[super dealloc];
}

@end

@implementation ATBookmark (Coding)

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{    
    [aCharacter addOOPIvarWithName:@"url"];
    [aCharacter addOOPIvarWithName:@"iconData"];
    [aCharacter addOOPIvarWithName:@"iconDataType"];
    [aCharacter addOOPIvarWithName:@"lastVisitDate"];
    [aCharacter addOOPIvarWithName:@"lastModifiedDate"];
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [super encodeWithAliaser:aChildminder];
    
    [aChildminder encodeObject:url];
    [aChildminder encodeObject:iconData];
    [aChildminder encodeObject:iconDataType];
    [aChildminder encodeObject:lastVisitDate];
    [aChildminder encodeObject:lastModifiedDate];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    [super initWithAliaser:aChildminder];
    
    NUSetIvar(&url, [aChildminder decodeObject]);
    NUSetIvar(&iconData, [aChildminder decodeObject]);
    NUSetIvar(&iconDataType, [aChildminder decodeObject]);
    NUSetIvar(&lastVisitDate, [aChildminder decodeObject]);
    NUSetIvar(&lastModifiedDate, [aChildminder decodeObject]);
    
    return self;
}

@end

@implementation ATBookmark (Accessing)

- (void)setUrl:(NSURL *)aUrl
{
    [self willChangeValueForKey:@"url"];
    NUSetIvar(&url, aUrl);
    [self didChangeValueForKey:@"url"];
    [[[self bell] playLot] markChangedObject:self];
}

- (NSURL *)url
{
    return NUGetIvar(&url);
}

- (void)setUrlString:(NSString *)aUrlString
{
	if (aUrlString)
		[self setUrl:[NSURL URLWithString:aUrlString]];
	else
		[self setUrl:nil];
}

- (NSString *)urlString
{
	return [[self url] absoluteString];
}

- (NSData *)iconData
{
    return NUGetIvar(&iconData);
}

- (void)setIconData:(NSData *)aData
{
    NUSetIvar(&iconData, aData);
    
    if (!iconData)
        [self setIcon:nil];
    
    [[[self bell] playLot] markChangedObject:self];
}

- (NSString *)iconDataType
{
    return NUGetIvar(&iconDataType);
}

- (void)setIconDataType:(NSString *)aType
{
    NUSetIvar(&iconDataType, aType);
    [[[self bell] playLot] markChangedObject:self];
}

- (NSImage *)icon
{
	return icon ? icon : [self getIcon];
}

- (NSImage *)getIcon
{
	icon = [[NSImage alloc] initWithData:[self iconData]];
	[icon setScalesWhenResized:YES];
	[icon setSize:NSMakeSize(16, 16)];
	
	return icon;
}

- (void)setIcon:(NSImage *)anIcon
{
    NUSetIvar(&icon, anIcon);
}

- (NSDate *)lastVisitDate
{
    return NUGetIvar(&lastVisitDate);
}

- (void)setLastVisitDate:(NSDate *)aDate
{
    NUSetIvar(&lastVisitDate, aDate);
    [[[self bell] playLot] markChangedObject:self];
}

- (NSDate *)lastModifiedDate
{
    return NUGetIvar(&lastModifiedDate);
}

- (void)setLastModifiedDate:(NSDate *)aDate
{
    NUSetIvar(&lastModifiedDate, aDate);
    [[[self bell] playLot] markChangedObject:self];
}

+ (NSArray *)editableValueKeys
{
	return [[super editableValueKeys] arrayByAddingObjectsFromArray:[NSArray arrayWithObjects:@"urlString", @"icon", nil]];
}

@end

@implementation ATBookmark (Testing)

- (BOOL)isBookmark
{
	return YES;
}

@end

@implementation ATBookmark (Editing)

@end

@implementation ATBookmark (Converting)

- (NSMutableDictionary  *)propertyListRepresentation
{
	NSMutableDictionary *aPlist = [super propertyListRepresentation];
	
	if ([self urlString])
		[aPlist setObject:[self urlString] forKey:@"urlString"];
		
	if ([self iconData])
	{
		[aPlist setObject:[self iconData] forKey:@"iconData"];
		[aPlist setObject:[self iconDataType] forKey:@"iconDataType"];
	}
	
	if ([self lastVisitDate])
		[aPlist setObject:[self lastVisitDate] forKey:@"lastVisitDate"];
	
	if ([self lastModifiedDate])
		[aPlist setObject:[self lastModifiedDate] forKey:@"lastModifiedDate"];
	
	if ([self comment])
		[aPlist setObject:[self comment] forKey:@"comment"];
		
	return aPlist;
}

@end

@implementation ATBookmark (Validating)

- (BOOL)validateUrlString:(id *)ioValue error:(NSError **)outError
{
	id aNewValue = [[NSValueTransformer valueTransformerForName:@"ATNullBetweenNilTransformer"] transformedValue:*ioValue];
	
	if (!aNewValue || [NSURL URLWithString:*ioValue])
	{
		*ioValue = aNewValue;
		return YES;
	}
	else
	{
		*outError = [NSError  errorWithDomain:@"ATBookmarksErrorDomain" code:0 userInfo:nil];
		
		return NO;
	}
}
		
@end