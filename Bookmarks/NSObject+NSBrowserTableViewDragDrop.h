//
//  NSObject+NSBrowserTableViewDragDrop.h
//  Bookmarks
//
//  Created by Akifumi Takata on 2012/11/03.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (NSBrowserTableViewDragDrop)

- (NSDragOperation)ATDraggingEntered:(id < NSDraggingInfo >)sender;
- (void)ATDraggingEnded:(id < NSDraggingInfo >)sender;

@end
