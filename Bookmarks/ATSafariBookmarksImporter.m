//
//  ATSafariBookmarksImporter.m
//  Bookmarks
//
//  Created by Akifumi Takata on 2014/06/07.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import "ATSafariBookmarksImporter.h"
#import "ATBookmark.h"
#import "ATBinder.h"

@implementation ATSafariBookmarksImporter

- (NSString *)defaultBookmarksFilepath
{
    NSArray *aDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *aUserLibraryDirectoryPath = aDirectoryPaths[0];
    NSString *aBookmarksFilepath = [aUserLibraryDirectoryPath stringByAppendingPathComponent:@"Safari/Bookmarks.plist"];
    return aBookmarksFilepath;
}

- (ATBinder *)importBookmarks
{    
    NSDictionary *aBookmarksDictionary = [NSDictionary dictionaryWithContentsOfFile:[self bookmarksFilepath]];
    ATBinder *aRoot = [self importBinderFrom:aBookmarksDictionary];
    [aRoot setName:@"Safari's bookmarks"];
    
    return aRoot;
}

- (ATBinder *)importBinderFrom:(NSDictionary *)aList
{
    NSNumber *aShouldOmitFromUI = aList[@"ShouldOmitFromUI"];
    if ([aShouldOmitFromUI boolValue]) return nil;
    
    __block ATBinder *aBinder = [ATBinder binder];
    NSArray *aChildren = aList[@"Children"];
    
    [aBinder setName:aList[@"Title"]];
    
    [aChildren enumerateObjectsUsingBlock:^(NSDictionary *aDictionary, NSUInteger idx, BOOL *stop) {
        
        NSString *aWebBookmarkType = aDictionary[@"WebBookmarkType"];
        id anItem = nil;
        
        if ([aWebBookmarkType isEqualToString:@"WebBookmarkTypeList"])
            anItem = [self importBinderFrom:aDictionary];
        else if ([aWebBookmarkType isEqualToString:@"WebBookmarkTypeLeaf"])
            anItem = [self importBookmarkFrom:aDictionary];
        
        if (anItem) [aBinder add:anItem];
    }];
    
    return aBinder;
}

- (ATBookmark *)importBookmarkFrom:(NSDictionary *)aLeaf
{
    ATBookmark *aBookmark = [ATBookmark bookmark];
    
    [aBookmark setName:aLeaf[@"URIDictionary"][@"title"]];
    [aBookmark setUrlString:aLeaf[@"URLString"]];
    
    return aBookmark;
}

@end
