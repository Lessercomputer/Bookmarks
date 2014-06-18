//
//  ATBookmark.h
//  ATBookmarks
//
//  Created by 明史 on 05/10/11.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "ATItem.h"


@interface ATBookmark : ATItem
{
	NSURL *url;
	NSData *iconData;
	NSString *iconDataType;
	NSImage *icon;
	NSDate *lastVisitDate;
	NSDate *lastModifiedDate;
}

@end

@interface ATBookmark (Initializing)

+ (id)bookmark;

+ (id)bookmarkWithName:(NSString *)aName urlString:(NSString *)aURLString;
- (id)initWithName:(NSString *)aName urlString:(NSString *)aURLString;

@end

@interface ATBookmark (Accessing)
- (void)setUrl:(NSURL *)aUrl;
- (NSURL *)url;

- (void)setUrlString:(NSString *)aUrlString;
- (NSString *)urlString;

- (NSData *)iconData;
- (void)setIconData:(NSData *)aData;

- (NSString *)iconDataType;
- (void)setIconDataType:(NSString *)aType;

- (NSImage *)icon;
- (void)setIcon:(NSImage *)anIcon;
- (NSImage *)getIcon;

- (NSDate *)lastVisitDate;
- (void)setLastVisitDate:(NSDate *)aDate;

- (NSDate *)lastModifiedDate;
- (void)setLastModifiedDate:(NSDate *)aDate;

@end

@interface ATBookmark (Validating)
- (BOOL)validateUrlString:(id *)ioValue error:(NSError **)outError;
@end