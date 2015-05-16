//
//  ATContentModel.h
//  Bookmarks
//
//  Created by P,T,A on 07/08/09.
//  Copyright 2007 PEDOPHILIA. All rights reserved.
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
