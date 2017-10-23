//
//  BookmarksInsertOperation.h
//  Bookmarks
//
//  Created by P,T,A  on 12/01/08.
//  Copyright (c) 2012年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATBookmarksOperation.h"


@interface ATBookmarksInsertOperation : ATBookmarksOperation

+ (id)insertOperationWithItems:(NSArray *)anItems index:(NSUInteger)anIndex binder:(ATBinder *)aBinder contextInfo:(id)anInfo;

+ (id)insertOperationWithItems:(NSArray *)anItems indexes:(NSIndexSet *)anIndexes binder:(ATBinder *)aBinder contectInfo:(id)anInfo;

- (id)initWithItems:(NSArray *)anItems index:(NSUInteger)anIndex binder:(ATBinder *)aBinder contextInfo:(id)anInfo;

- (id)initWithItems:(NSArray *)anItems indexes:(NSIndexSet *)anIndexes binder:(ATBinder *)aBinder contectInfo:(id)anInfo;

@end
