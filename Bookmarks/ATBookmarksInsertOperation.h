//
//  ATBookmarksInsertOperation.h
//  ATBookmarks
//
//  Created by 明史 高田 on 12/01/08.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATBookmarksOperation.h"


@interface ATBookmarksInsertOperation : ATBookmarksOperation

+ (id)insertOperationWithItems:(NSArray *)anItems index:(NSUInteger)anIndex binder:(ATBinder *)aBinder contextInfo:(id)anInfo;

+ (id)insertOperationWithItems:(NSArray *)anItems indexes:(NSIndexSet *)anIndexes binder:(ATBinder *)aBinder contectInfo:(id)anInfo;

- (id)initWithItems:(NSArray *)anItems index:(NSUInteger)anIndex binder:(ATBinder *)aBinder contextInfo:(id)anInfo;

- (id)initWithItems:(NSArray *)anItems indexes:(NSIndexSet *)anIndexes binder:(ATBinder *)aBinder contectInfo:(id)anInfo;

@end
