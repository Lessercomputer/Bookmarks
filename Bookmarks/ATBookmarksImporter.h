//
//  BookmarksImporter.h
//  Bookmarks
//
//  Created by P,T,A on 2014/06/07.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATBinder;

@interface ATBookmarksImporter : NSObject
{
    NSString *bookmarksFilepath;
}

+ (id)importer;

- (NSString *)defaultBookmarksFilepath;

- (NSString *)bookmarksFilepath;
- (void)setBookmarksFilepath:(NSString *)aFilepath;

- (ATBinder *)importBookmarksFromContentsOfFile:(NSString *)aFilepath;
- (ATBinder *)importBookmarks;

@end
