//
//  ATDocumentPreferences.h
//  Bookmarks
//
//  Created by Akifumi Takata on 2014/06/21.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@class ATMenuItemDescription;

extern NSString *ATDocumentPreferencesDidChangeWindowAlphaValueNotification;
extern NSString *ATDocumentPreferencesDidChangeMenuItemDescriptionsForOpenBookmarksWithNotification;
extern NSString *ATDocumentPreferencesDidChangeMenuItemDescriptionWhenDoubleClickNotification;
extern NSString *ATDocumentPreferencesDidChangeNotification;

@interface ATDocumentPreferences : NSObject <NUCoding, NSCopying>
{
    NUBell *bell;
    CGFloat windowAlphaValue;
    NSMutableArray *menuItemDescriptionsForOpenBookmarksWith;
    NSArray *menuItemDescriptionsForDoubleClick;
    ATMenuItemDescription *menuItemDescriptionWhenDoubleClick;
}

+ (NSArray *)defaultMenuItemDescriptionsForOpenBookmarksWith;

- (CGFloat)windowAlphaValue;
- (void)setWindowAlphaValue:(CGFloat)aValue;

- (NSMutableArray *)menuItemDescriptionsForOpenBookmarksWith;
- (void)setMenuItemDescriptionsForOpenBookmarksWith:(NSArray *)anArray;

- (NSArray *)menuItemDescriptionsForDoubleClick;
- (void)setMenuItemDescriptionsForDoubleClick:(NSArray *)anArray;

- (ATMenuItemDescription *)menuItemDescriptionWhenDoubleClick;
- (void)setMenuItemDescriptionWhenDoubleClick:(ATMenuItemDescription *)aMenuItemDescription;

- (void)moveMenuItemDescriptionsAtIndexes:(NSIndexSet *)anIndexSet toIndex:(NSUInteger)anIndex;

- (void)acceptIfChanged:(ATDocumentPreferences *)aPreferences;

@end
