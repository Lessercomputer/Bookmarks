//
//  ATContentModel.h
//  Bookmarks
//
//  Created by 高田 明史 on 07/08/09.
//  Copyright 2007 Pedophilia. All rights reserved.
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
