//
//  ATBrowser.h
//  Bookmarks
//
//  Created by Akifumi Takata  on 12/02/26.
//  Copyright (c) 2012年 Nursery-Framework. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface ATBrowser : NSBrowser
{
    BOOL inDragging;
    BOOL inDraggingEnding;
}

+ (void)installHookMethods;

- (void)browserTableView:(id)tableView draggingEntered:(id <NSDraggingInfo>)aDraggingInfo;
- (void)browserTableView:(id)tableView draggingEnded:(id <NSDraggingInfo>)aDraggingInfo;

@end
