//
//  ATDocumentPreferencesWindowController.h
//  Bookmarks
//
//  Created by P,T,A on 2014/06/21.
//  Copyright (c) 2014年 PEDOPHILIA. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATDocumentPreferences;
@class ATDocumentPreferencesPresentation;

@interface ATDocumentPreferencesWindowController : NSWindowController
{
    ATDocumentPreferences *preferences;
    IBOutlet ATDocumentPreferencesPresentation *preferencesPresentation;
    IBOutlet NSObjectController *preferencesPresentationController;
    IBOutlet NSArrayController *menuItemDescriptionsController;
    IBOutlet NSTableView *openWithBrowserMenuItemsView;
}

+ (id)windowControllerWithPreferences:(ATDocumentPreferences *)aPreferences;

- (id)initWithPreferences:(ATDocumentPreferences *)aPreferences;

- (IBAction)ok:(id)sender;
- (IBAction)cancel:(id)sender;

@end
