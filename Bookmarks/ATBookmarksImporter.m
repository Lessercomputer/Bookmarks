//
//  ATBookmarksImporter.m
//  Bookmarks
//
//  Created by 高田 明史 on 2014/06/07.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
//

#import "ATBookmarksImporter.h"

@implementation ATBookmarksImporter

+ (id)importer
{
    return [[[self alloc] init] autorelease];
}

- (NSString *)bookmarksFilepath
{
    return bookmarksFilepath;
}

- (void)setBookmarksFilepath:(NSString *)aFilepath
{
    [bookmarksFilepath release];
    bookmarksFilepath = [aFilepath copy];
}

- (NSString *)defaultBookmarksFilepath
{
    return nil;
}

- (ATBinder *)importBookmarksFromContentsOfFile:(NSString *)aFilepath
{
    [self setBookmarksFilepath:aFilepath];
    return [self importBookmarks];
}

- (ATBinder *)importBookmarks
{
    return nil;
}

@end
