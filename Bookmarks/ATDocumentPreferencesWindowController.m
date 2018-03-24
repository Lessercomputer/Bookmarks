//
//  ATDocumentPreferencesWindowController.m
//  Bookmarks
//
//  Created by Akifumi Takata on 2014/06/21.
//  Copyright (c) 2014年 Nursery-Framework. All rights reserved.
//

#import "ATDocumentPreferencesWindowController.h"
#import "ATDocumentPreferences.h"
#import "ATDocumentPreferencesPresentation.h"

@implementation ATDocumentPreferencesWindowController

+ (id)windowControllerWithPreferences:(ATDocumentPreferences *)aPreferences
{
    return [[[self alloc] initWithPreferences:aPreferences] autorelease];
}

- (id)initWithPreferences:(ATDocumentPreferences *)aPreferences
{
    if (self = [super initWithWindowNibName:@"ATDocumentPreferencesWindow"])
    {
        preferences = [aPreferences retain];
        if (!preferences)
        {
            [self autorelease];
            self = nil;
        }
    }
    
    return self;
}

- (void)dealloc
{
    [preferences release];
    
    [super dealloc];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [preferencesPresentation setPreferences:[[preferences copy] autorelease]];
    [preferencesPresentationController setContent:preferencesPresentation];
    [openWithBrowserMenuItemsView setDataSource:preferencesPresentation];
    [openWithBrowserMenuItemsView registerForDraggedTypes:@[ATDocumentPreferencesPrivateIndexSet]];
}

- (IBAction)ok:(id)sender
{
    [preferences acceptIfChanged:[preferencesPresentation preferences]];
    
    [self close];
}

- (IBAction)cancel:(id)sender
{
    [self close];
}

@end
