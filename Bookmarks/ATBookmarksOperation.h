//
//  ATBookmarksOperation.h
//  ATBookmarks
//
//  Created by 明史 高田 on 12/01/08.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
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
