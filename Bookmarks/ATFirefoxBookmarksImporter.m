//
//  ATFirefoxBookmraksImporter.m
//  Bookmarks
//
//  Created by 高田 明史 on 2014/06/07.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
//

#import "ATFirefoxBookmarksImporter.h"
#import "ATJSONParser.h"
#import "ATBinder.h"
#import "ATBookmark.h"

@implementation ATFirefoxBookmarksImporter

- (NSString *)defaultBookmarksFilepath
{
    NSString *aBookmarkbackupsDirectoryPath = [self bookmarkbackupsDirectoryPath];
    NSArray *aFilepathsOnBackupsDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:aBookmarkbackupsDirectoryPath error:nil];
    __block NSDate *aMaxDate = [NSDate distantPast];
    __block NSString *aBookmarkFilepath = nil;
    
    NSMutableArray *aBookmarkbackupFilepaths = [NSMutableArray array];
    [aFilepathsOnBackupsDirectory enumerateObjectsUsingBlock:^(NSString *aFilepath, NSUInteger idx, BOOL *stop) {
        if ([aFilepath hasSuffix:@".json"])
            [aBookmarkbackupFilepaths addObject:aFilepath];
    }];
    
    [aBookmarkbackupFilepaths enumerateObjectsUsingBlock:^(NSString *aBookmarkbackupFilepath, NSUInteger idx, BOOL *stop) {
        NSInteger aYear = 0, aMonth = 0, aDay = 0;
        NSScanner *aScanner = [NSScanner scannerWithString:aBookmarkbackupFilepath];
        [aScanner scanString:@"bookmarks-" intoString:NULL];
        [aScanner scanInteger:&aYear];
        [aScanner scanString:@"-" intoString:NULL];
        [aScanner scanInteger:&aMonth];
        [aScanner scanString:@"-" intoString:NULL];
        [aScanner scanInteger:&aDay];
        
        NSDateComponents *aDateComponents = [[NSDateComponents alloc] init];
        [aDateComponents setYear:aYear];
        [aDateComponents setMonth:aMonth];
        [aDateComponents setDay:aDay];
        NSDate *aDate = [[NSCalendar currentCalendar] dateFromComponents:aDateComponents];
        
        if ([aDate isGreaterThan:aMaxDate])
        {
            aMaxDate = aDate;
            aBookmarkFilepath = aBookmarkbackupFilepath;
        }
    }];
    
    return [aBookmarkbackupsDirectoryPath stringByAppendingPathComponent:aBookmarkFilepath];
}

- (NSString *)bookmarkbackupsDirectoryPath
{
    NSArray *aDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *anApplicationSupportDirectoryPath = aDirectoryPaths[0];
    NSString *aProfilesDirectoryPath = [anApplicationSupportDirectoryPath stringByAppendingPathComponent:@"Firefox/Profiles/"];
    NSArray *aContentsOfProfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:aProfilesDirectoryPath error:nil];
    __block NSString *aDefaultDirectoryPath = nil;
    
    [aContentsOfProfiles enumerateObjectsUsingBlock:^(NSString *aPath, NSUInteger idx, BOOL *stop) {
        if ([[aPath pathExtension] isEqualToString:@"default"])
        {
            aDefaultDirectoryPath = aPath;
            *stop = YES;
        }
    }];
    
    if (!aDefaultDirectoryPath) return nil;
    
    NSString *aBookmarkbackupsDirectoryPath = [[aProfilesDirectoryPath stringByAppendingPathComponent:aDefaultDirectoryPath] stringByAppendingPathComponent:@"bookmarkbackups"];
    return aBookmarkbackupsDirectoryPath;
}

- (ATBinder *)importBookmarks
{    
    NSString *aJSONText = [NSString stringWithContentsOfFile:[self bookmarksFilepath] encoding:NSUTF8StringEncoding error:nil];
    ATJSONParser *jsonParser = [ATJSONParser parserWithString:aJSONText];
    NSDictionary *aBookmarksDictionary = [jsonParser parse];
    ATBinder *aRoot = [self importBinderFrom:aBookmarksDictionary];
    [aRoot setName:@"Firefox's bookmarks"];
    
    return aRoot;
}

- (ATBinder *)importBinderFrom:(NSDictionary *)aContainer
{
    ATBinder *aBinder = [ATBinder binder];
    NSArray *aChildern = aContainer[@"children"];
    
    [aBinder setName:aContainer[@"title"]];
    [self setDateToItem:aBinder fromDictionary:aContainer];
    
    [aChildern enumerateObjectsUsingBlock:^(NSDictionary *aDictionary, NSUInteger idx, BOOL *stop) {
        
        id anItem = nil;
        
        if ([aDictionary[@"type"] isEqualToString:@"text/x-moz-place-container"])
            anItem = [self importBinderFrom:aDictionary];
        else if ([aDictionary[@"type"] isEqualToString:@"text/x-moz-place"])
            anItem = [self importBookmarkFrom:aDictionary];
        
        if (anItem) [aBinder add:anItem];
    }];
    
    return aBinder;
}

- (ATBookmark *)importBookmarkFrom:(NSDictionary *)aPlace
{
    ATBookmark *aBookmark = [ATBookmark bookmark];
    
    [aBookmark setName:aPlace[@"title"]];
    [aBookmark setUrlString:aPlace[@"uri"]];
    [self setDateToItem:aBookmark fromDictionary:aPlace];
    
    return aBookmark;
}

- (void)setDateToItem:(ATItem *)anItem fromDictionary:(NSDictionary *)aDictionary
{
    NSDate *aDate = [self dateFromFirefoxDate:[aDictionary[@"dateAdded"] doubleValue]];
    if (aDate) [anItem setAddDate:aDate];
    
    if ([anItem isBookmark])
    {
        aDate = [self dateFromFirefoxDate:[aDictionary[@"lastModified"] doubleValue]];
        if (aDate) [(ATBookmark *)anItem setLastModifiedDate:aDate];
    }
}

- (NSDate *)dateFromFirefoxDate:(double)aFirefoxDate
{
    double aTimestamp = aFirefoxDate / 1000 / 1000;
    
    if (aTimestamp != 0)
        return [NSDate dateWithTimeIntervalSince1970:aTimestamp];
    else
        return nil;
}

@end
