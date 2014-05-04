//
//  ATContentModel.m
//  ATBookmarks
//
//  Created by çÇìcÅ@ñæéj on 07/08/09.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ATContentModel.h"
#import "ATModelGroup.h"


@implementation ATContentModel

+ (id)contentModelWithModelGroup:(ATModelGroup *)aModelGroup
{
	return [[[self alloc] initWithModelGroup:aModelGroup] autorelease];
}

- (id)initWithModelGroup:(ATModelGroup *)aModelGroup
{
	[super init];
	
	modelGroup = [aModelGroup retain];
	
	return self;
}

- (void)dealloc
{
	[modelGroup release];
	
	[super dealloc];
}

- (ATProcessIndicator *)asProcessIndicator
{
	return [[[ATProcessIndicator alloc] initWithContent:modelGroup] autorelease];
}

- (BOOL)isContentModel
{
	return YES;
}

- (BOOL)isDeclaredContent
{
	return NO;
}

- (BOOL)isModelGroup
{
	return NO;
}

- (BOOL)isAny
{
	return NO;
}

@end
