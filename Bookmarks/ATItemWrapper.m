//
//  ATItemWrapper.m
//  Bookmarks
//
//  Created by Akifumi Takata  on 12/07/21.
//  Copyright (c) 2012年 Nursery-Framework. All rights reserved.
//

#import "ATItemWrapper.h"
#import "ATItem.h"
#import "ATBinderWrapper.h"

@implementation ATItemWrapper

+ (id)itemWrapperWithItem:(ATItem *)anItem
{
    return [[[self alloc] initWithItem:anItem] autorelease];
}

- (id)initWithItem:(ATItem *)anItem
{
    [super init];
    
    [self setItem:anItem];
    
    return self;
}

- (ATItem *)item
{
    return item;
}

- (void)setItem:(ATItem *)anItem
{
    NUSetIvar(&item, anItem);
}

//- (BOOL)isEqual:(id)anObject
//{
//    return self == anObject || [[self item] isEqual:[anObject item]];
//}

- (BOOL)itemIsEqualItemOf:(ATItemWrapper *)aWrapper
{
    return [[self item] isEqual:[aWrapper item]];
}

- (BOOL)isBinderWrapper
{
    return NO;
}

+ (NSArray *)wrappersFrom:(NSArray *)anItems
{
    NSMutableArray *aWrappers = [NSMutableArray array];
    [anItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isBookmark])
            [aWrappers addObject:[ATItemWrapper itemWrapperWithItem:obj]];
        else
            [aWrappers addObject:[ATBinderWrapper itemWrapperWithItem:obj]];
    }];
    return aWrappers;
}

- (id)copyWithZone:(NSZone *)zone
{
    //NSLog(@"ATItemWrapper #copyWithZone:");
    
    ATItemWrapper *aCopiedItemWrapper = [[self class] itemWrapperWithItem:[self item]];
    
    return [aCopiedItemWrapper retain];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p> item:%@", [self class], self, item];
}

- (void)dealloc
{
    [item release];
    
    [super dealloc];
}

@end

@implementation ATItemWrapper (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
{
	[aCharacter addOOPIvarWithName:@"item"];
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [aChildminder encodeObject:[self item]];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    [super init];
    
    [self setItem:[aChildminder decodeObjectReally]];
    
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
