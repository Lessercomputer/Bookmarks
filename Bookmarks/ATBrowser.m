//
//  ATBrowser.m
//  ATBookmarks
//
//  Created by 明史 高田 on 12/02/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATBrowser.h"
#import "NSObject+NSBrowserTableViewDragDrop.h"
#import <objc/runtime.h>

@implementation ATBrowser

+ (void)installHookMethods
{
    Class theNSBrowserTableViewClass = objc_getClass("NSBrowserTableView");
    Class theNSObjectClass = [NSObject class];
    
    Method theDraggingEndedMethodOfNSBrowserTableView = class_getInstanceMethod(theNSBrowserTableViewClass, @selector(draggingEnded:));
    Method theDraggingEndedMethodOfNSObject = class_getInstanceMethod(theNSObjectClass, @selector(ATDraggingEnded:));
    method_exchangeImplementations(theDraggingEndedMethodOfNSBrowserTableView, theDraggingEndedMethodOfNSObject);
    
    Method theDraggingEnteredMethodOfNSBrowserTableView = class_getInstanceMethod(theNSBrowserTableViewClass, @selector(draggingEntered:));
    Method theDraggingEnteredMethodOfNSObject = class_getInstanceMethod(theNSObjectClass, @selector(ATDraggingEntered:));
    method_exchangeImplementations(theDraggingEnteredMethodOfNSBrowserTableView, theDraggingEnteredMethodOfNSObject);
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
    return [[self delegate] menuForEvent:theEvent];
}

- (void)draggingEnded:(id < NSDraggingInfo >)sender
{
    //NSLog(@"draggingEnded:");
    //[super draggingEnded:sender];
}

- (void)browserTableView:(id)tableView draggingEntered:(id <NSDraggingInfo>)aDraggingInfo
{
    //NSLog(@"browserTableView:draggingEntered:");
    
    if (inDragging) return;
    
    inDragging = YES;
    [[self delegate] browser:self draggingEntered:aDraggingInfo];
}

- (void)browserTableView:(id)tableView draggingEnded:(id <NSDraggingInfo>)aDraggingInfo
{
    //NSLog(@"browserTableView:draggingEnded:");
    
    if (inDraggingEnding) return;
    
    inDraggingEnding = YES;
    [self performSelector:@selector(afterDraggingEnded:) withObject:aDraggingInfo afterDelay:0.03];
}

- (void)afterDraggingEnded:(id <NSDraggingInfo>)aDraggingInfo
{
    //NSLog(@"afterDraggingEnded");
    
    [[self delegate] browser:self draggingEnded:aDraggingInfo];
    inDragging = NO;
    inDraggingEnding = NO;
}

@end
