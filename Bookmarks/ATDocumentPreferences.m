//
//  ATDocumentPreferences.m
//  Bookmarks
//
//  Created by P,T,A on 2014/06/21.
//  Copyright (c) 2014年 PEDOPHILIA. All rights reserved.
//

#import "ATDocumentPreferences.h"
#import "ATMenuItemDescription.h"

NSString *ATDocumentPreferencesDidChangeWindowAlphaValueNotification = @"ATDocumentPreferencesDidChangeWindowAlphaValueNotification";
NSString *ATDocumentPreferencesDidChangeMenuItemDescriptionsForOpenBookmarksWithNotification = @"ATDocumentPreferencesDidChangeMenuItemDescriptionsForOpenBookmarksWithNotification";
NSString *ATDocumentPreferencesDidChangeMenuItemDescriptionWhenDoubleClickNotification = @"ATDocumentPreferencesDidChangeMenuItemDescriptionWhenDoubleClickNotification";
NSString *ATDocumentPreferencesDidChangeNotification = @"ATDocumentPreferencesDidChangeNotification";

@implementation ATDocumentPreferences

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    [aCharacter addFloatIvarWithName:@"windowAlphaValue"];
    [aCharacter addOOPIvarWithName:@"menuItemDescriptionsForOpenBookmarksWith"];
    [aCharacter addOOPIvarWithName:@"menuItemDescriptionsForDoubleClick"];
    [aCharacter addOOPIvarWithName:@"menuItemDescriptionWhenDoubleClick"];
}

- (id)init
{
    if (self = [super init])
    {
        windowAlphaValue = 1;
        menuItemDescriptionsForOpenBookmarksWith = [[[self class] defaultMenuItemDescriptionsForOpenBookmarksWith] mutableCopy];
        menuItemDescriptionsForDoubleClick = [[[self class] menuItemDescriptionsForDoubleClick:menuItemDescriptionsForOpenBookmarksWith] copy];
        menuItemDescriptionWhenDoubleClick = [menuItemDescriptionsForDoubleClick[0] retain];
    }
    
    return self;
}

- (void)dealloc
{
    [menuItemDescriptionsForOpenBookmarksWith release];
    [menuItemDescriptionsForDoubleClick release];
    [menuItemDescriptionWhenDoubleClick release];
    
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    id aCopy = [[self class] new];
    __block NSMutableArray *aCopiedMenuItemDescriptions = [NSMutableArray array];
    
    [aCopy setWindowAlphaValue:[self windowAlphaValue]];
    
    [[self menuItemDescriptionsForOpenBookmarksWith] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [aCopiedMenuItemDescriptions addObject:[[obj copy] autorelease]];
    }];
    [aCopy setMenuItemDescriptionsForOpenBookmarksWith:aCopiedMenuItemDescriptions];
    
    [aCopy setMenuItemDescriptionsForDoubleClick:[[self class] menuItemDescriptionsForDoubleClick:[aCopy menuItemDescriptionsForOpenBookmarksWith]]];
    
    __block ATMenuItemDescription *aMenuItemDescriptionWhenDoubleClick = nil;
    [[aCopy menuItemDescriptionsForDoubleClick] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj selector] == [[self menuItemDescriptionWhenDoubleClick] selector])
        {
            aMenuItemDescriptionWhenDoubleClick = obj;
            *stop = YES;
        }
    }];
    [aCopy setMenuItemDescriptionWhenDoubleClick:aMenuItemDescriptionWhenDoubleClick];
    
    return aCopy;
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [aChildminder encodeFloat:windowAlphaValue];
    [aChildminder encodeObject:menuItemDescriptionsForOpenBookmarksWith];
    [aChildminder encodeObject:menuItemDescriptionsForDoubleClick];
    [aChildminder encodeObject:menuItemDescriptionWhenDoubleClick];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    if (self = [super init])
    {
        windowAlphaValue = [aChildminder decodeFloat];
        NUSetIvar(&menuItemDescriptionsForOpenBookmarksWith, [aChildminder decodeObject]);
        NUSetIvar(&menuItemDescriptionsForDoubleClick, [aChildminder decodeObject]);
        NUSetIvar(&menuItemDescriptionWhenDoubleClick, [aChildminder decodeObject]);
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

+ (NSArray *)defaultMenuItemDescriptionsForOpenBookmarksWith
{
    return @[[ATMenuItemDescription menuItemDescriptionWithLocalizableTitle:@"Open Bookmarks Of Selected Binder With Safari" selector:@selector(openBookmarksInSelectedBinderWithSafari:)]
             ,[ATMenuItemDescription menuItemDescriptionWithLocalizableTitle:@"Open Selected Bookmarks With Safari" selector:@selector(openSelectedBookmarksWithSafari:)]
             ,[ATMenuItemDescription menuItemDescriptionWithLocalizableTitle:@"Open Selected Bookmarks With Safari With New Tabs" selector:@selector(openSelectedBookmarksWithSafariWithNewTabs:)]
             ,[ATMenuItemDescription menuItemDescriptionWithLocalizableTitle:@"Open Bookmarks Of Selected Binder With Chrome" selector:@selector(openBookmarksInSelectedBinderWithChrome:)]
             ,[ATMenuItemDescription menuItemDescriptionWithLocalizableTitle:@"Open Selected Bookmarks With Chrome" selector:@selector(openSelectedBookmarksWithChrome:)]
             ,[ATMenuItemDescription menuItemDescriptionWithLocalizableTitle:@"Open Selected Bookmarks With Chrome With New Tabs" selector:@selector(openSelectedBookmarksWithChromeWithNewTabs:)]
             ,[ATMenuItemDescription menuItemDescriptionWithLocalizableTitle:@"Open Bookmarks Of Selected Binder With Firefox" selector:@selector(openBookmarksInSelectedBinderWithFirefox:)]
             ,[ATMenuItemDescription menuItemDescriptionWithLocalizableTitle:@"Open Selected Bookarmks With Firefox With New Tabs" selector:@selector(openSelectedBookmarksWithFirefoxWithNewTabs:)]];
}

+ (NSArray *)menuItemDescriptionsForDoubleClick:(NSArray *)anArray
{
    NSMutableArray *aMenuItemDescriptions = [NSMutableArray array];
    
    [anArray enumerateObjectsUsingBlock:^(ATMenuItemDescription *aMenuItemDescription, NSUInteger idx, BOOL *stop) {
        SEL anAction = [aMenuItemDescription selector];
        if (anAction == @selector(openSelectedBookmarksWithSafari:)
            || anAction == @selector(openSelectedBookmarksWithSafariWithNewTabs:)
            || anAction == @selector(openSelectedBookmarksWithChrome:)
            || anAction == @selector(openSelectedBookmarksWithChromeWithNewTabs:)
            || anAction == @selector(openSelectedBookmarksWithFirefoxWithNewTabs:))
            [aMenuItemDescriptions addObject:aMenuItemDescription];
    }];

    return aMenuItemDescriptions;
}

- (CGFloat)windowAlphaValue
{
    return windowAlphaValue;
}

- (void)setWindowAlphaValue:(CGFloat)aValue
{
    windowAlphaValue = aValue;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATDocumentPreferencesDidChangeWindowAlphaValueNotification object:self];
}

- (NSMutableArray *)menuItemDescriptionsForOpenBookmarksWith
{
    return NUGetIvar(&menuItemDescriptionsForOpenBookmarksWith);
}

- (void)setMenuItemDescriptionsForOpenBookmarksWith:(NSArray *)anArray
{
    [menuItemDescriptionsForOpenBookmarksWith release];
    menuItemDescriptionsForOpenBookmarksWith = [anArray mutableCopy];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATDocumentPreferencesDidChangeMenuItemDescriptionsForOpenBookmarksWithNotification object:self];
}

- (NSArray *)menuItemDescriptionsForDoubleClick
{
    return NUGetIvar(&menuItemDescriptionsForDoubleClick);
}

- (void)setMenuItemDescriptionsForDoubleClick:(NSArray *)anArray
{
    [menuItemDescriptionsForDoubleClick release];
    menuItemDescriptionsForDoubleClick = [anArray copy];
    
    if ([anArray count])
        [self setMenuItemDescriptionWhenDoubleClick:anArray[0]];
}

- (ATMenuItemDescription *)menuItemDescriptionWhenDoubleClick
{
    return NUGetIvar(&menuItemDescriptionWhenDoubleClick);
}

- (void)setMenuItemDescriptionWhenDoubleClick:(ATMenuItemDescription *)aMenuItemDescription
{
    [menuItemDescriptionWhenDoubleClick autorelease];
    menuItemDescriptionWhenDoubleClick = [aMenuItemDescription retain];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATDocumentPreferencesDidChangeMenuItemDescriptionWhenDoubleClickNotification object:self];
}

- (void)moveMenuItemDescriptionsAtIndexes:(NSIndexSet *)anIndexSet toIndex:(NSUInteger)anIndex
{
    NSArray *anItemsToDrag = [[self menuItemDescriptionsForOpenBookmarksWith] objectsAtIndexes:anIndexSet];
    anIndex -= [anIndexSet countOfIndexesInRange:NSMakeRange(0, anIndex)];
    
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:anIndexSet forKey:@"menuItemDescriptionsForOpenBookmarksWith"];
    [[self menuItemDescriptionsForOpenBookmarksWith] removeObjectsAtIndexes:anIndexSet];
    
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:anIndexSet forKey:@"menuItemDescriptionsForOpenBookmarksWith"];
    [[self menuItemDescriptionsForOpenBookmarksWith] insertObjects:anItemsToDrag atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(anIndex, [anIndexSet count])]];
    
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:anIndexSet forKey:@"menuItemDescriptionsForOpenBookmarksWith"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:anIndexSet forKey:@"menuItemDescriptionsForOpenBookmarksWith"];
}

- (BOOL)isEqual:(id)anObject
{
    if (anObject == self) return YES;
    if ([self windowAlphaValue] != [anObject windowAlphaValue]) return NO;
    if (![[self menuItemDescriptionsForOpenBookmarksWith] isEqualToArray:[anObject menuItemDescriptionsForOpenBookmarksWith]]) return NO;
    if (![[self menuItemDescriptionWhenDoubleClick] isEqual:[anObject menuItemDescriptionWhenDoubleClick]]) return NO;
    
    return YES;
}

- (void)acceptIfChanged:(ATDocumentPreferences *)aPreferences
{
    if ([self isEqual:aPreferences]) return;
    
    [self setWindowAlphaValue:[aPreferences windowAlphaValue]];
    [self setMenuItemDescriptionsForOpenBookmarksWith:[aPreferences menuItemDescriptionsForOpenBookmarksWith]];
    [self setMenuItemDescriptionWhenDoubleClick:[aPreferences menuItemDescriptionWhenDoubleClick]];
    
    [[self bell] markChanged];
    [[[self bell] playLot] markChangedObject:[self menuItemDescriptionsForOpenBookmarksWith]];
    [[self menuItemDescriptionsForOpenBookmarksWith] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj bell] markChanged];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATDocumentPreferencesDidChangeNotification object:self];
}

@end
