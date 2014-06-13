//
//  ATFirefoxBookmraksImporter.h
//  Bookmarks
//
//  Created by 高田 明史 on 2014/06/07.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
//

#import "ATBookmarksImporter.h"

@class ATBookmark;

@interface ATFirefoxBookmarksImporter : ATBookmarksImporter

- (NSString *)bookmarkbackupsDirectoryPath;

- (ATBinder *)importBinderFrom:(NSDictionary *)aContainer;
- (ATBookmark *)importBookmarkFrom:(NSDictionary *)aPlace;

- (NSDate *)dateFromFirefoxDate:(double)aFirefoxDate;

@end
