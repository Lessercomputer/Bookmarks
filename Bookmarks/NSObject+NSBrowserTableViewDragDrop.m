//
//  NSObject+NSBrowserTableViewDragDrop.m
//  ATBookmarks
//
//  Created by 高田 明史 on 2012/11/03.
//
//

#import "NSObject+NSBrowserTableViewDragDrop.h"

@implementation NSObject (NSBrowserTableViewDragDrop)

- (NSDragOperation)ATDraggingEntered:(id < NSDraggingInfo >)sender
{
    //NSLog(@"ATDraggingEntered:");
    NSDragOperation aDragOperation = [self ATDraggingEntered:sender];
    [[self browser] browserTableView:self draggingEntered:sender];
    return aDragOperation;
}

- (void)ATDraggingEnded:(id < NSDraggingInfo >)sender
{
    //NSLog(@"ATDraggingEnded:");
    //[self ATDraggingEnded:sender];
    [[self browser] browserTableView:self draggingEnded:sender];
}

@end
