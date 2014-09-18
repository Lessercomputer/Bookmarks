//
//  ATNetscapeBookmarkFile1DocumentEntity.m
//  ATBookmarks
//
//  Created by 高田　明史 on 07/08/07.
//  Copyright 2007 Pedophilia. All rights reserved.
//

#import "ATNetscapeBookmarkFile1DocumentEntity.h"
#import "ATMarkup.h"
#import "ATNetscapeBookmarkFile1Scanner.h"
#import "ATDTD.h"
#import "ATElement.h"

@implementation ATNetscapeBookmarkFile1DocumentEntity

- (id)initWithContentsOfFile:(NSString *)aPath
{
	[self initWithFilePath:aPath];
	
	[self load];
	
	return self;
}

- (id)initWithFilePath:(NSString *)aPath
{
	[super init];
	
	filePath = [aPath copy];
	
	return self;
}

- (id)initWithString:(NSString *)aString
{
	[super init];
	
	scanner = [[ATNetscapeBookmarkFile1Scanner alloc] initWithString:aString];
	dtd = [ATDTD new];
	
	return self;
}

- (void)dealloc
{
	[filePath release];
	[scanner release];
	[netscapeBookmarkFile1Element release];
	[dtd release];
	
	[super dealloc];
}

- (void)load
{
	NSData *aData = [NSData dataWithContentsOfFile:filePath];
	NSString *aString = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
		
	scanner = [[ATNetscapeBookmarkFile1Scanner alloc] initWithString:aString];
	dtd = [ATDTD new];
}

- (BOOL)parse
{
	ATMarkup *aMarkup = [scanner scanMarkup];//DOCTYPEを読み飛ばす
	aMarkup = [scanner scanMarkup];//コメントを読み飛ばす
	aMarkup = [scanner scanMarkup];//METAを読み飛ばす
	
	netscapeBookmarkFile1Element = (ATNETSCAPEBookmarkFile1Element *)[[ATElement alloc] initWithName:@"netscape-bookmark-file-1" documentEntity:self scanner:scanner];
	
	return [netscapeBookmarkFile1Element parse];
}

- (ATDTD *)DTD
{
	return dtd;
}

- (NSUInteger)countOfElementNamed:(NSString *)aName
{
	return [netscapeBookmarkFile1Element countOfElementNamed:aName];
}

- (NSEnumerator *)objectEnumerator
{
	return [netscapeBookmarkFile1Element subtreeEnumerator];
}

- (NSString *)description
{
	return [netscapeBookmarkFile1Element description];
}

@end
