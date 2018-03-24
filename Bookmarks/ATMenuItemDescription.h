//
//  ATMenuItemDescription.h
//  Bookmarks
//
//  Created by Akifumi Takata on 2014/06/21.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@interface ATMenuItemDescription : NSObject <NUCoding, NSCopying>
{
    NUBell *bell;
    NSString *localizableTitle;
    SEL selector;
    BOOL isEnabled;
}

+ (id)menuItemDescriptionWithLocalizableTitle:(NSString *)aString selector:(SEL)aSelector;

- (id)initWithLocalizableTitle:(NSString *)aString selector:(SEL)aSelector;

- (NSString *)localizableTitle;
- (void)setLocalizableTitle:(NSString *)aString;

- (NSString *)localizedTitle;

- (SEL)selector;
- (void)setSelector:(SEL)aSelector;

- (BOOL)isEnabled;
- (void)setIsEnabled:(BOOL)aFlag;

@end
