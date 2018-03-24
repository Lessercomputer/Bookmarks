//
//  BookmarksTreeUnarchiver.h
//  Bookmarks
//
//  Created by Akifumi Takata on 09/05/02.
//  Copyright 2009 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATBinder;

@interface ATBookmarksTreeUnarchiver : NSObject
{
	NSDictionary *archive;
	ATBinder *root;
	ATBinder *currentBinder;
	NSMutableDictionary *itemsDictionary;
}

- (id)initWithArchive:(id)anArchive;

- (id)unarchive;

@end
