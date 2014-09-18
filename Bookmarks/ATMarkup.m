//
//  ATMarkup.m
//  ATBookmarks
//
//  Created by çÇìcÅ@ñæéj on 07/08/07.
//  Copyright 2007 Pedophilia. All rights reserved.
//

#import "ATMarkup.h"


@implementation ATMarkup

+ (ATMarkup *)documentTypeDeclarationWithName:(NSString *)aName
{
	return [[[self alloc] initWithName:aName attributeList:nil comment:nil] autorelease];
}

+ (ATMarkup *)commentDeclarationWithComment:(NSString *)aComment;
{
	return [[[self alloc] initWithName:nil attributeList:nil comment:aComment] autorelease];
}

+ (ATMarkup *)startTagWithName:(NSString *)aName;
{
	return [[[self alloc] initWithName:aName attributeList:nil comment:nil] autorelease];
}

+ (ATMarkup *)startTagWithName:(NSString *)aName attributeList:(NSDictionary *)anAttributeDict;
{
	return [[[self alloc] initWithName:aName attributeList:anAttributeDict comment:nil] autorelease];
}

+ (ATMarkup *)endTagWithName:(NSString *)aName
{
	return [[[self alloc] initWithName:aName attributeList:nil comment:nil] autorelease];
}

- (id)initWithName:(NSString *)aName attributeList:(NSDictionary *)anAttributeList comment:(NSString *)aComment
{
	[super init];
	
	name = [aName copy];
	attributeList = [anAttributeList retain];
	comment = [aComment copy];
	
	return self;
}

- (void)dealloc
{
	[name release];
	[attributeList release];
	[comment release];
	
	[super dealloc];
}

- (NSString *)name
{
	return name;
}

- (NSDictionary *)attributeList
{
	return attributeList;
}

- (BOOL)nameIs:(NSString *)aName
{
	return [[name uppercaseString] isEqualToString:[aName uppercaseString]];
}

@end
