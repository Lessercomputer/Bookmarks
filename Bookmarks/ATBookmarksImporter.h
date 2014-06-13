//
//  ATBookmarksImporter.h
//  Bookmarks
//
//  Created by 高田 明史 on 2014/06/07.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
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
