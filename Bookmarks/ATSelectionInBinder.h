//
//  ATSelectionInBinder.h
//  ATBookmarks
//
//  Created by 明史 高田 on 12/01/07.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@class ATBinder, ATItemWrapper;

@interface ATSelectionInBinder : NSObject <NUCoding>
{
    NUBell *bell;
    ATBinder *binder;
    NSIndexSet *selectionIndexes;
    ATItemWrapper *binderWrapper;
    NSMutableArray *items;
}

+ (id)selectionInBinderWithBinderWrapper:(ATItemWrapper *)aBinderWrapper;

- (id)initWithBinderWrapper:(ATItemWrapper *)aBinderWrapper;

- (ATBinder *)binder;
- (NSIndexSet *)selectionIndexes;
- (void)setSelectionIndexes:(NSIndexSet *)aSelectionIndexes;
- (ATItemWrapper *)binderWrapper;
- (ATItemWrapper *)itemWrapperAt:(NSUInteger)anIndex;

- (void)reloadItems;

@end

@interface ATSelectionInBinder (Private)

- (void)setBinder:(ATBinder *)aBinder;

- (void)setBinderWrapper:(ATItemWrapper *)aBinderWrapper;

- (NSArray *)items;
- (void)setItems:(NSArray *)anItems;

@end