//
//  ATSafariBookmarksImporter.h
//  Bookmarks
//
//  Created by P,T,A on 2014/06/07.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import "ATBookmarksImporter.h"

@class ATBookmark;

@interface ATSafariBookmarksImporter : ATBookmarksImporter

- (ATBinder *)importBinderFrom:(NSDictionary *)aList;
- (ATBookmark *)importBookmarkFrom:(NSDictionary *)aLeaf;

@end
