//
//  ATEditor.h
//  Bookmarks
//
//  Created by Akifumi Takata on 05/10/12.
//  Copyright 2005 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATBookmarksPresentation;

@interface ATEditor : NSObject
{
	id item;
	NSMutableDictionary *value;
	NSMutableDictionary *status;
	ATBookmarksPresentation *bookmarksPresentation;
    BOOL isMakingNewItem;
}

@end

@interface ATEditor (Initializing)
+ (id)editorFor:(id)anItem  on:(ATBookmarksPresentation *)aBookmarksPresentaion;

- (id)initWith:(id)anItem on:(ATBookmarksPresentation *) aBookmarksPresentaion;
@end

@interface ATEditor (Accessing)
- (id)item;
- (NSMutableDictionary *)value;
- (NSMutableDictionary *)status;
@end

@interface ATEditor (Testing)
- (BOOL)isValid;
- (BOOL)isMakingNewItem;
@end

@interface ATEditor (Accepting)
- (void)accept;

- (void)acceptIfValid;

- (void)cancel;
@end
