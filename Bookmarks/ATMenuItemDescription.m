//
//  ATMenuItemDescription.m
//  Bookmarks
//
//  Created by P,T,A on 2014/06/21.
//  Copyright (c) 2014年 PEDOPHILIA. All rights reserved.
//

#import "ATMenuItemDescription.h"

@implementation ATMenuItemDescription

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    [aCharacter addOOPIvarWithName:@"localizableTitle"];
    [aCharacter addOOPIvarWithName:@"selector"];
    [aCharacter addBOOLIvarWithName:@"isEnabled"];
}

+ (id)menuItemDescriptionWithLocalizableTitle:(NSString *)aString selector:(SEL)aSelector
{
    return [[[self alloc] initWithLocalizableTitle:aString selector:aSelector] autorelease];
}

- (id)initWithLocalizableTitle:(NSString *)aString selector:(SEL)aSelector
{
    if (self = [super init])
    {
        localizableTitle = [aString copy];
        selector = aSelector;
        isEnabled = YES;
    }
    
    return self;
}

- (void)dealloc
{
    [localizableTitle release];
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    id aCopy = [[[self class] alloc] initWithLocalizableTitle:[self localizableTitle] selector:[self selector]];
    [aCopy setIsEnabled:[self isEnabled]];
    
    return aCopy;
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [aChildminder encodeObject:localizableTitle];
    [aChildminder encodeObject:NSStringFromSelector(selector)];
    [aChildminder encodeBOOL:isEnabled];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    if (self = [super init])
    {
        NUSetIvar(&localizableTitle, [aChildminder decodeObject]);
        selector = NSSelectorFromString([aChildminder decodeObjectReally]);
        isEnabled = [aChildminder decodeBOOL];
    }
    
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

- (NSString *)localizableTitle
{
    return NUGetIvar(&localizableTitle);
}

- (void)setLocalizableTitle:(NSString *)aString
{
    [localizableTitle release];
    localizableTitle = [aString copy];
    [[self bell] markChanged];
}

- (NSString *)localizedTitle
{
    return NSLocalizedString([self localizableTitle], nil);
}

- (SEL)selector
{
    return selector;
}

- (void)setSelector:(SEL)aSelector
{
    selector = aSelector;
    [[self bell] markChanged];
}

- (BOOL)isEnabled
{
    return isEnabled;
}

- (void)setIsEnabled:(BOOL)aFlag
{
    isEnabled = aFlag;
    [[self bell] markChanged];
}

- (BOOL)isEqual:(id)anObject
{
    if (anObject == self) return YES;
    return [self selector] == [anObject selector] && [self isEnabled] == [anObject isEnabled];
}

@end
