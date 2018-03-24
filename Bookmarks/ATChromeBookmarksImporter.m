//
//  ATChromeBookmarksImporter.m
//  Bookmarks
//
//  Created by Akifumi Takata on 2014/06/08.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import "ATChromeBookmarksImporter.h"
#import "ATJSONParser.h"
#import "ATBinder.h"
#import "ATBookmark.h"

@implementation ATChromeBookmarksImporter

- (NSString *)defaultBookmarksFilepath
{
    NSArray *aDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *anApplicationSupportDirectoryPath = aDirectoryPaths[0];
    NSString *aBookmarksFilepath = [anApplicationSupportDirectoryPath stringByAppendingPathComponent:@"Google/Chrome/Default/Bookmarks"];
    return aBookmarksFilepath;
}

- (ATBinder *)importBookmarks
{    
    NSString *aJSONText = [NSString stringWithContentsOfFile:[self bookmarksFilepath] encoding:NSUTF8StringEncoding error:nil];
    ATJSONParser *jsonParser = [ATJSONParser parserWithString:aJSONText];
    NSDictionary *aBookmarksDictionary = [jsonParser parse];
    
    ATBinder *aRoot = [ATBinder binder];
    [aRoot setName:@"Chrome's bookmarks"];
    
    NSDictionary *aRoots = aBookmarksDictionary[@"roots"];
    
    ATBinder *aBinder = nil;
    NSDictionary *aFolder = aRoots[@"bookmark_bar"];
    if (aFolder)
    {
        aBinder = [self importBinderFrom:aFolder];
        if (aBinder) [aRoot add:aBinder];
    }
    
    aFolder = aRoots[@"other"];
    if (aFolder)
    {
        aBinder = [self importBinderFrom:aFolder];
        if (aBinder) [aRoot add:aBinder];
    }
    
    return aRoot;
}

- (ATBinder *)importBinderFrom:(NSDictionary *)aFolder
{
    ATBinder *aBinder = [ATBinder binder];
    NSArray *aChildern = aFolder[@"children"];
    
    [aBinder setName:aFolder[@"name"]];
    [self setDateToItem:aBinder fromDictionary:aFolder];
    
    [aChildern enumerateObjectsUsingBlock:^(NSDictionary *aDictionary, NSUInteger idx, BOOL *stop) {
        
        id anItem = nil;
        
        if ([aDictionary[@"type"] isEqualToString:@"folder"])
            anItem = [self importBinderFrom:aDictionary];
        else if ([aDictionary[@"type"] isEqualToString:@"url"])
            anItem = [self importBookmarkFrom:aDictionary];
        
        if (anItem) [aBinder add:anItem];
    }];
    
    return aBinder;
}

- (ATBookmark *)importBookmarkFrom:(NSDictionary *)aUrl
{
    ATBookmark *aBookmark = [ATBookmark bookmark];
    
    [aBookmark setName:aUrl[@"name"]];
    [aBookmark setUrlString:aUrl[@"url"]];
    [self setDateToItem:aBookmark fromDictionary:aUrl];
    
    return aBookmark;
}

- (void)setDateToItem:(ATItem *)anItem fromDictionary:(NSDictionary *)aDictionary
{
    [anItem setAddDate:[self dateFromChromeDate:aDictionary[@"date_added"]]];
    
    if ([anItem isBookmark] && aDictionary[@"date_modified"])
        [(ATBookmark *)anItem setLastModifiedDate:[self dateFromChromeDate:aDictionary[@"date_modified"]]];
}

- (NSDate *)dateFromChromeDate:(NSString *)aChromeDateString
{
//    NSDateComponents *aBaseDateComponents = [[[NSDateComponents alloc] init] autorelease];
//    [aBaseDateComponents setYear:1601];
//    [aBaseDateComponents setMonth:1];
//    [aBaseDateComponents setDay:1];
//
//    NSDate *aBaseDate = [[NSCalendar calendarWithIdentifier:NSGregorianCalendar] dateFromComponents:aBaseDateComponents];
//    NSTimeInterval aTimestamp = [aChromeDateString doubleValue] / 10000000.0;
//    
//    return [aBaseDate dateByAddingTimeInterval:aTimestamp];
    
//    NSTimeInterval aTimeInterval = ([aChromeDateString doubleValue] - 116444736000000) / 10000000;
    NSTimeInterval aTimeInterval = [aChromeDateString doubleValue] / 1000000 - 11644473600;
    return [NSDate dateWithTimeIntervalSince1970:aTimeInterval];
}

@end
