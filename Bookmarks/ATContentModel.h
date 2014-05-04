//
//  ATContentModel.h
//  ATBookmarks
//
//  Created by çÇìcÅ@ñæéj on 07/08/09.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATModelGroup;
@class ATProcessIndicator;

@interface ATContentModel : NSObject
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
