//
//  ATDocumentController.m
//  Bookmarks
//
//  Created by 髙田　明史 on 2015/07/25.
//  Copyright (c) 2015年 Pedophilia. All rights reserved.
//

#import "ATDocumentController.h"

@implementation ATDocumentController

- (NSString *)typeForContentsOfURL:(NSURL *)url error:(NSError **)outError
{
    if ([[url scheme] isEqualToString:@"nursery"])
        return @"jp.pedophilia.bookmarksn";
    else
        return [super typeForContentsOfURL:url error:outError];
}

@end
