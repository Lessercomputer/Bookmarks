//
//  ATElementDeclaration.m
//  Bookmarks
//
//  Created by Akifumi Takata on 07/08/09.
//  Copyright 2007 Nursery-Framework. All rights reserved.
//

#import "ATElementDeclaration.h"


@implementation ATElementDeclaration

+ (id)elementDeclarationWithElementType:(NSString *)aType content:(id)aContent
{
	return [self elementDeclarationWithElementType:aType startTagMinimization:NO endTagMinimization:NO content:aContent];
}

+ (id)elementDeclarationWithElementType:(NSString *)aType startTagMinimization:(BOOL)aStartTagMinimizationFlag endTagMinimization:(BOOL)anEndTagMinimizationFlag content:(id)aContent
{
	return [[[self alloc] initWithElementType:aType startTagMinimization:aStartTagMinimizationFlag endTagMinimization:anEndTagMinimizationFlag content:aContent] autorelease];
}

- (id)initWithElementType:(NSString *)aType startTagMinimization:(BOOL)aStartTagMinimizationFlag endTagMinimization:(BOOL)anEndTagMinimizationFlag content:(id)aContent
{
	[super init];
	
	elementType = [aType copy];
	startTagMinimization = aStartTagMinimizationFlag;
	endTagMinimization = anEndTagMinimizationFlag;
	content = [aContent retain];
	
	return self;
}

- (void)dealloc
{
	[elementType release];
	[content release];
	
	[super dealloc];
}

- (NSString *)elementType
{
	return elementType;
}

- (id)content
{
	return content;
}

- (BOOL)contentIsDeclaredContent
{
	return [content isDeclaredContent];
}

- (BOOL)contentIsContentModel
{
	return [content isContentModel];
}

- (BOOL)startTagMinimization
{
	return startTagMinimization;
}

- (BOOL)endTagMinimization
{
	return endTagMinimization;
}

@end
