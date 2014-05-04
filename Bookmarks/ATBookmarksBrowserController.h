//
//  ATBookmaksBrowserController.h
//  ATBookmarks
//
//  Created by 明史 高田 on 11/12/30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATBookmarksPresentation;

@interface ATBookmarksBrowserController : NSViewController
{
    NSBrowser *browser;
    ATBookmarksPresentation *bookmarksPresentaion;
    NSUInteger disableCountOfUpdating;
}

- (NSBrowser *)browser;
- (void)setBrowser:(NSBrowser *)aBrowser;

- (ATBookmarksPresentation *)bookmarksPresentation;
- (void)setBookmarksPresentation:(ATBookmarksPresentation *)aBookmarksPresentation;

- (void)presentationDidChange:(NSNotification *)aNotification;

- (void)browser:(id)sender draggingEntered:(id <NSDraggingInfo>)aDraggingInfo;
- (void)browser:(id)sender draggingEnded:(id <NSDraggingInfo>)aDraggingInfo;

- (void)updateBrowser:(BOOL)aRootChanged;

- (BOOL)updatingIsEnabled;

- (void)disableUpdating;
- (void)enableUpdating;

- (NSMenu *)menuForEvent:(NSEvent *)theEvent;

- (IBAction)openItem:(id)sender;

@end
