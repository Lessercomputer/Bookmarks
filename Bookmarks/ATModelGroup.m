//
//  ATModelGroup.m
//  Bookmarks
//
//  Created by Akifumi Takata on 07/08/09.
//  Copyright 2007 Nursery-Framework. All rights reserved.
//

#import "ATModelGroup.h"

#import "ATProcessIndicator.h"

@implementation ATModelGroup

+ (id)modelGroupWithContentTokens:(NSArray *)aContentTokens
{
	return [[[self alloc] initWithContentTokens:aContentTokens] autorelease];
}

+ (id)modelGroupWithContentTokens:(NSArray *)aContentTokens occurrenceIndicator:(NSString *)anIndicator
{
	return [[[self alloc] initWithContentTokens:aContentTokens occurrenceIndicator:anIndicator] autorelease];
}

- (id)initWithContentTokens:(NSArray *)aContentTokens
{
	return [self initWithContentTokens:aContentTokens occurrenceIndicator:nil];
}

- (id)initWithContentTokens:(NSArray *)aContentTokens occurrenceIndicator:(NSString *)anIndicator
{
	[super init];
	
	contentTokens = [aContentTokens retain];
	occurrenceIndicator = [anIndicator retain];

	return self;
}

- (void)dealloc
{
	[contentTokens release];
	[occurrenceIndicator release];
	
	[super dealloc];
}

- (ATProcessIndicator *)asProcessIndicator
{
	return [[[ATProcessIndicator alloc] initWithContent:self] autorelease];
}

- (BOOL)isDeclaredContent
{
	return NO;
}

- (BOOL)isPrimitiveContentToken
{
	return NO;
}

- (BOOL)isModelGroup
{
	return YES;
}

- (NSString *)occurrenceIndicator
{
	return occurrenceIndicator;
}

- (NSEnumerator *)objectEnumerator
{
	return [contentTokens objectEnumerator];
}

@end
