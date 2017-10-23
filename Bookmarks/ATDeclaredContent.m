//
//  ATDeclaredContent.m
//  Bookmarks
//
//  Created by P,T,A on 07/08/14.
//  Copyright 2007 Nursery-Framework. All rights reserved.
//

#import "ATDeclaredContent.h"
#import "ATProcessIndicator.h"

@implementation ATDeclaredContent

+ (id)RCDATA
{	
	return [[[self alloc] initWithContent:@"RCDATA"] autorelease];
}

+ (id)EMPTY
{	
	return [[[self alloc] initWithContent:@"EMPTY"] autorelease];
}

- (id)initWithContent:(NSString *)aContent
{
	[super init];
	
	content = [aContent copy];
	
	return self;
}

- (void)dealloc
{
	[content release];
	
	[super dealloc];
}

- (BOOL)isDeclaredContent
{
	return YES;
}

- (BOOL)isContentModel
{
	return NO;
}

- (BOOL)isCDATA
{
	return [content isEqualToString:@"CDATA"];
}

- (BOOL)isRCDATA
{
	return [content isEqualToString:@"RCDATA"];
}

- (BOOL)isEMPTY
{
	return [content isEqualToString:@"EMPTY"];
}

- (ATProcessIndicator *)asIndicator
{
	return [[[ATProcessIndicator alloc] initWithContent:self] autorelease];
}

@end
