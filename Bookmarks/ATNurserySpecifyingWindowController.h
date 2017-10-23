//
//  ATNurserySpecifyingWindowController.h
//  Bookmarks
//
//  Created by P,T,A on 2015/07/24.
//  Copyright (c) 2015年 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATNurserySpecifyingInfo;

@interface ATNurserySpecifyingWindowController : NSWindowController
{
    ATNurserySpecifyingInfo *nurserySpecifyingInfo;
}

- (void)clear;

- (IBAction)openNursery:(id)sender;

@end
