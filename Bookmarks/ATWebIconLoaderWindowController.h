//
//  ATWebIconLoaderWindowController.h
//  ATBookmarks
//
//  Created by 高田 明史 on 08/01/04.
//  Copyright 2008 Pedophilia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ATWebIconLoader.h"

@class ATBookmarks;
@class WebView;

@interface ATWebIconLoaderWindowController : NSWindowController <ATWebIconLoaderDelegate>
{
    ATWebIconLoader *model;
    IBOutlet NSObjectController *controller;
}

+ (id)newWith:(NSArray *)anItems bookmarks:(ATBookmarks *)aBookmarks;
- (id)initWith:(NSArray *)anItems bookmarks:(ATBookmarks *)aBookmarks;

- (ATWebIconLoader *)model;
- (void)setModel:(ATWebIconLoader *)aModel;

- (IBAction)cancelLoading:(id)sender;

@end
