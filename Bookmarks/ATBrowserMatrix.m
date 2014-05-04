//
//  ATBrowserMatrix.m
//  ATBookmarks
//
//  Created by 高田 明史 on 2012/11/03.
//
//

#import "ATBrowserMatrix.h"

@implementation ATBrowserMatrix

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender
{
    //NSLog(@"#draggingEntered:");
    return [super draggingEntered:sender];
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender
{
    return [super prepareForDragOperation:sender];
}

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender
{
    //NSLog(@"#concludeDragOperation:");
    [super concludeDragOperation:sender];
}

- (void)draggingEnded:(id < NSDraggingInfo >)sender
{
    //NSLog(@"draggingEnded:");
    [super draggingEnded:sender];
}

@end
