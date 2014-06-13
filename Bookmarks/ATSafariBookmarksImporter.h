//
//  ATSafariBookmarksImporter.h
//  Bookmarks
//
//  Created by 高田 明史 on 2014/06/07.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
//

#import "ATBookmarksImporter.h"

@class ATBookmark;

@interface ATSafariBookmarksImporter : ATBookmarksImporter

- (ATBinder *)importBinderFrom:(NSDictionary *)aList;
- (ATBookmark *)importBookmarkFrom:(NSDictionary *)aLeaf;

@end
