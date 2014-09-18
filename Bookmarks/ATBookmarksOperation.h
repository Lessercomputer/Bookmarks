//
//  ATBookmarksOperation.h
//  ATBookmarks
//
//  Created by 高田 明史  on 12/01/08.
//  Copyright (c) 2012年 Pedophilia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATBinder;

@interface ATBookmarksOperation : NSObject
{
    NSMutableArray *items;
    NSMutableIndexSet *indexes;
    ATBinder *binder;
    id contextInfo;
}

- (NSMutableArray *)items;
- (NSMutableIndexSet *)indexes;
- (ATBinder *)binder;
- (id)contextInfo;

- (ATBookmarksOperation *)undoOperation;

@end
