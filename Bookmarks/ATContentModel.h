//
//  ATContentModel.h
//  Bookmarks
//
//  Created by Akifumi Takata on 07/08/09.
//  Copyright 2007 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ATContent.h"

@class ATModelGroup;
@class ATProcessIndicator;

@interface ATContentModel : NSObject <ATContent>
{
	ATModelGroup *modelGroup;
}

+ (id)contentModelWithModelGroup:(ATModelGroup *)aModelGroup;

- (id)initWithModelGroup:(ATModelGroup *)aModelGroup;

- (ATProcessIndicator *)asProcessIndicator;

- (BOOL)isContentModel;
- (BOOL)isDeclaredContent;
- (BOOL)isModelGroup;
- (BOOL)isAny;

@end
