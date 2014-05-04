//
//  ATElementToken.m
//  ATBookmarks
//
//  Created by çÇìcÅ@ñæéj on 07/08/09.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ATElementToken.h"
#import "ATProcessIndicator.h"

@implementation ATElementToken

+ (id)elementTokenWithName:(NSString *)aName
{
	return [self elementTokenWithName:aName occurrenceIndicator:nil];
}

+ (id)elementTokenWithName:(NSString *)aName occurrenceIndicator:(NSString *)anIndicator
{
	return [[[self alloc] initWithName:aName occurrenceIndicator:anIndicator] autorelease];
}

- (id)initWithName:(NSString *)aName occurrenceIndicator:(NSString *)anIndicator
{
	[super init];
	
	elementName = [aName copy];
	occurrenceIndicator = [anIndicator retain];
	
	return self;
}

- (void)dealloc
{
	[elementName release];
	[occurrenceIndicator release];
	
	[super dealloc];
}

- (NSString *)elementName
{
	return elementName;
}

- (NSString *)occurrenceIndicator
{
	return occurrenceIndicator;
}

- (ATProcessIndicator *)asProcessIndicator
{
	return [[[ATProcessIndicator alloc] initWithContent:self] autorelease];
}

- (BOOL)isElementToken
{
	return YES;
}

- (BOOL)isPrimitiveContentToken
{
	return NO;
}

- (BOOL)isModelGroup
{
	return NO;
}

@end
