//
//  ATElementDeclaration.h
//  Bookmarks
//
//  Created by P,T,A on 07/08/09.
//  Copyright 2007 PEDOPHILIA. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ATContent.h"

@class ATContentModel;

@interface ATElementDeclaration : NSObject
{
	NSString *elementType;
	BOOL startTagMinimization;
	BOOL endTagMinimization;
	id <ATContent> content;
}

+ (id)elementDeclarationWithElementType:(NSString *)aType content:(id)aContent;
+ (id)elementDeclarationWithElementType:(NSString *)aType startTagMinimization:(BOOL)aStartTagMinimizationFlag endTagMinimization:(BOOL)anEndTagMinimizationFlag content:(id)aContent;

- (id)initWithElementType:(NSString *)aType startTagMinimization:(BOOL)aStartTagMinimizationFlag endTagMinimization:(BOOL)anEndTagMinimizationFlag content:(id)aContent;

- (NSString *)elementType;
- (id)content;

- (BOOL)contentIsDeclaredContent;
- (BOOL)contentIsContentModel;

- (BOOL)startTagMinimization;
- (BOOL)endTagMinimization;

@end
