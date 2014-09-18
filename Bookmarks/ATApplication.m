//
//  ATApplication.m
//  Bookmarks
//
//  Created by 高田 明史 on 2014/09/19.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
//

#import "ATApplication.h"

@implementation ATApplication

- (void)reportException:(NSException *)theException
{
    (*NSGetUncaughtExceptionHandler())(theException);
}

@end
