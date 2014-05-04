//
//  ATSelectionInBinder.m
//  ATBookmarks
//
//  Created by 明史 高田 on 12/01/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATSelectionInBinder.h"
#import "ATBinder.h"
#import "ATItemWrapper.h"

@implementation ATSelectionInBinder

+ (id)selectionInBinderWithBinderWrapper:(ATItemWrapper *)aBinderWrapper
{
    return [[[self alloc] initWithBinderWrapper:aBinderWrapper] autorelease];
}

- (id)initWithBinderWrapper:(ATItemWrapper *)aBinderWrapper
{
    [super init];
    
    [self setBinderWrapper:aBinderWrapper];
    [self setSelectionIndexes:[NSIndexSet indexSet]];
    [self reloadItems];
    
    return self;
}

- (ATBinder *)binder
{
    return [[self binderWrapper] item];
}

- (NSIndexSet *)selectionIndexes
{
    return selectionIndexes;
}

- (void)setSelectionIndexes:(NSIndexSet *)aSelectionIndexes
{
    [selectionIndexes release];
    selectionIndexes = [aSelectionIndexes copy];
    
    [[[self bell] playLot] markChangedObject:self];
}

- (ATItemWrapper *)binderWrapper
{
    return binderWrapper;
}

- (ATItemWrapper *)itemWrapperAt:(NSUInteger)anIndex
{
    return [[self items] objectAtIndex:anIndex];
}

- (void)reloadItems
{
    NSLog(@"#reloadItems");
    NSMutableArray *anItems = [NSMutableArray array];
    
    [[[self binder] children] enumerateObjectsUsingBlock:^(id anItem, NSUInteger anIndex, BOOL *aStop) {
        [anItems addObject:[ATItemWrapper itemWrapperWithItem:anItem]];
    }];
    
    [self setItems:anItems];
}

- (void)dealloc
{
    [self setSelectionIndexes:nil];
    [self setBinderWrapper:nil];
    [self setItems:nil];
    
    [super dealloc];
}

@end

@implementation ATSelectionInBinder (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
	[aCharacter addOOPIvarWithName:@"binderWrapper"];
    [aCharacter addOOPIvarWithName:@"items"];
    [aCharacter addOOPIvarWithName:@"selectionIndexes"];
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [aChildminder encodeObject:[self binderWrapper]];
    [aChildminder encodeObject:[self items]];
    [aChildminder encodeObject:[self selectionIndexes]];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    [super init];
    
    binderWrapper = [[aChildminder decodeObjectReally] retain];
    items = [[aChildminder decodeObjectReally] retain];
    selectionIndexes = [[aChildminder decodeObjectReally] retain];
    
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

@implementation ATSelectionInBinder (Private)

- (void)setBinderWrapper:(ATItemWrapper *)aBinderWrapper
{
    [binderWrapper autorelease];
    binderWrapper = [aBinderWrapper retain];
}

- (NSArray *)items
{
    return items;
}

- (void)setItems:(NSArray *)anItems
{
    [items autorelease];
    items = [anItems mutableCopy];
    
    [[[self bell] playLot] markChangedObject:self];
}

@end