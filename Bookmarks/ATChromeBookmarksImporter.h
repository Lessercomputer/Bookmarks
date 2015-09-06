//
//  ATChromeBookmarksImporter.h
//  Bookmarks
//
//  Created by P,T,A on 2014/06/08.
//  Copyright (c) 2014年 PEDOPHILIA. All rights reserved.
//

#import "ATBookmarksImporter.h"

@class ATItem;
@class ATBookmark;

@interface ATChromeBookmarksImporter : ATBookmarksImporter

- (ATBinder *)importBinderFrom:(NSDictionary *)aFolder;
- (ATBookmark *)importBookmarkFrom:(NSDictionary *)aUrl;

- (void)setDateToItem:(ATItem *)anItem fromDictionary:(NSDictionary *)aDictionary;
- (NSDate *)dateFromChromeDate:(NSString *)aChromeDateString;

@end
