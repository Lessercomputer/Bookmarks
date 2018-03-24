//
//  ATApplication.m
//  Bookmarks
//
//  Created by Akifumi Takata on 2014/09/19.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import "ATApplication.h"

@implementation ATApplication

- (void)reportException:(NSException *)theException
{
    (*NSGetUncaughtExceptionHandler())(theException);
}

@end
