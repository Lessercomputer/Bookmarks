//
//  ATItemWrapper.h
//  Bookmarks
//
//  Created by 高田 明史  on 12/07/21.
//  Copyright (c) 2012年 Pedophilia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@class ATItem;
@class ATBinderWrapper;

@interface ATItemWrapper : NSObject <NSCopying>
{
    NUBell *bell;
    ATItem *item;
}

+ (id)itemWrapperWithItem:(ATItem *)anItem;

- (id)initWithItem:(ATItem *)anItem;

- (ATItem *)item;
- (void)setItem:(ATItem *)anItem;

- (BOOL)itemIsEqualItemOf:(ATItemWrapper *)aWrapper;

- (BOOL)isBinderWrapper;

+ (NSArray *)wrappersFrom:(NSArray *)anItems;

@end

@interface ATItemWrapper (Coding) <NUCoding>

@end