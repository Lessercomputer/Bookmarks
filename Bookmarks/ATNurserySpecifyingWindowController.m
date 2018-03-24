//
//  ATNurserySpecifyingWindowController.m
//  Bookmarks
//
//  Created by Akifumi Takata on 2015/07/24.
//  Copyright (c) 2015年 Nursery-Framework. All rights reserved.
//

#import "ATNurserySpecifyingWindowController.h"
#import "ATNurserySpecifyingInfo.h"

@interface ATNurserySpecifyingWindowController ()

@end

@implementation ATNurserySpecifyingWindowController

- (instancetype)init
{
    self = [super initWithWindowNibName:@"ATNurserySpecifyingWindow"];
    if (self) {
        
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)clear
{
    [self willChangeValueForKey:@"nurserySpecifyingInfo"];
    [nurserySpecifyingInfo autorelease];
    nurserySpecifyingInfo = [ATNurserySpecifyingInfo new];
    [self didChangeValueForKey:@"nurserySpecifyingInfo"];
}

-(void)openNursery:(id)sender
{
//    [self performSelectorOnMainThread:@selector(openSpecifiedNursery) withObject:nil waitUntilDone:NO modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
    [self openSpecifiedNursery];
}

- (void)openSpecifiedNursery
{
//    NSString *aDocumentTypeForURL = [[NSDocumentController sharedDocumentController] typeForContentsOfURL:[nurserySpecifyingInfo nurseryURL] error:nil];
//    NSDocument *aDocument = [[NSDocumentController sharedDocumentController] makeDocumentWithContentsOfURL:[nurserySpecifyingInfo nurseryURL] ofType:aDocumentTypeForURL error:nil];
//    [[NSDocumentController sharedDocumentController] addDocument:aDocument];
//    [aDocument makeWindowControllers];
//    [aDocument showWindows];
    
    [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:[nurserySpecifyingInfo nurseryURL] display:YES completionHandler:^(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error) {
        [[self window] orderOut:nil];
    }];
}

@end
