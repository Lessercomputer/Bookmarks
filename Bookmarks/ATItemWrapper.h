//
//  ATItemWrapper.h
//  ATBookmarks
//
//  Created by 明史 高田 on 12/07/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
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