//
//  ATDeclaredContent.h
//  Bookmarks
//
//  Created by Akifumi Takata on 07/08/14.
//  Copyright 2007 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ATContent.h"

@class ATProcessIndicator;

@interface ATDeclaredContent : NSObject <ATContent>
{
	NSString *content;
}

+ (id)RCDATA;
+ (id)EMPTY;

- (id)initWithContent:(NSString *)aContent;

- (BOOL)isContentModel;
- (BOOL)isDeclaredContent;

- (BOOL)isCDATA;
- (BOOL)isRCDATA;
- (BOOL)isEMPTY;

- (ATProcessIndicator *)asIndicator;

@end
