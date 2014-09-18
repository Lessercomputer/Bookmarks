//
//  ATWebIconLoaderWindowController.m
//  Bookmarks
//
//  Created by 高田 明史 on 08/01/04.
//  Copyright 2008 Pedophilia. All rights reserved.
//

#import "ATWebIconLoaderWindowController.h"
#import "ATBookmarks.h"
#import "ATWebIconLoader.h"

@implementation ATWebIconLoaderWindowController

+ (id)newWith:(NSArray *)anItems bookmarks:(ATBookmarks *)aBookmarks
{
	return [[[self alloc] initWith:anItems bookmarks:aBookmarks] autorelease];
}

- (id)initWith:(NSArray *)anItems bookmarks:(ATBookmarks *)aBookmarks
{
	[super initWithWindowNibName:@"ATWebIconLoaderWindow"];
	
	[self setModel:[ATWebIconLoader newWith:anItems bookmarks:aBookmarks]];
    
	return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [controller setContent:[self model]];
}

- (void)dealloc
{
	[self setModel:nil];
	
	[super dealloc];
}

- (ATWebIconLoader *)model
{
    return model;
}

- (void)setModel:(ATWebIconLoader *)aModel
{
    [controller setContent:nil];
    [model setDelegate:nil];
    
    [model release];
    model = [aModel retain];
    
    [model setDelegate:self];
    [controller setContent:aModel];
}

- (void)start
{
    [[self model] start];
    [self showWindow:nil];
}

- (void)cancel
{
    [[self model] cancel];
}

- (IBAction)cancelLoading:(id)sender
{
	[self cancel];
    [[self window] performClose:nil];
}

- (void)webIconLoaderDidFinishLoading:(id)sender
{
    [[self window] performClose:nil];
}

@end
