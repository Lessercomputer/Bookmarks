//
//  ATDTD.m
//  Bookmarks
//
//  Created by 高田 明史 on 07/08/09.
//  Copyright 2007 Pedophilia. All rights reserved.
//

#import "ATDTD.h"
#import "ATElementToken.h"
#import "ATModelGroup.h"
#import "ATContentModel.h"
#import "ATElementDeclaration.h"
#import "ATDeclaredContent.h"

@implementation ATDTD

- (id)init
{
	NSMutableDictionary *anElementDeclarationDic = [NSMutableDictionary dictionary];
	
	//netscape-bookmark-file-1
	NSArray *aContentTokens = [NSArray arrayWithObjects:[ATElementToken elementTokenWithName:@"title"], @",", [ATElementToken elementTokenWithName:@"h1"],
								@",", [ATElementToken elementTokenWithName:@"dd" occurrenceIndicator:@"?"],
								@",", [ATElementToken elementTokenWithName:@"dl"], @",", [ATElementToken elementTokenWithName:@"p"], nil];
	NSArray *aContentTokens2 = nil;
	ATModelGroup *aModelGroup = [ATModelGroup modelGroupWithContentTokens:aContentTokens];
	ATContentModel *aContentModel = [ATContentModel contentModelWithModelGroup:aModelGroup];
	ATElementDeclaration *anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"netscape-bookmark-file-1" startTagMinimization:YES endTagMinimization:YES content:aContentModel];	
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	//title
	anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"title" content:[ATDeclaredContent RCDATA]];
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	//h1
	anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"h1" content:[ATDeclaredContent RCDATA]];
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	//dd
	anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"dd" startTagMinimization:NO endTagMinimization:YES content:[ATDeclaredContent RCDATA]];
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	//dl (p,(dt | hr)*)
	aContentTokens = [NSArray arrayWithObjects:[ATElementToken elementTokenWithName:@"dt"], @"|", [ATElementToken elementTokenWithName:@"hr"], nil];
	aContentTokens = [NSArray arrayWithObjects:[ATElementToken elementTokenWithName:@"p"], @",", [ATModelGroup modelGroupWithContentTokens:aContentTokens occurrenceIndicator:@"*"], nil];
	aModelGroup = [ATModelGroup modelGroupWithContentTokens:aContentTokens];
	anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"dl" content:aModelGroup];
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	//dt
	aContentTokens = [NSArray arrayWithObjects:[ATElementToken elementTokenWithName:@"h3"], @",", [ATElementToken elementTokenWithName:@"dd" occurrenceIndicator:@"?"], @",", [ATElementToken elementTokenWithName:@"dl"], @",", [ATElementToken elementTokenWithName:@"p"], nil];
	aContentTokens2 = [NSArray arrayWithObjects:[ATElementToken elementTokenWithName:@"a"], @",", [ATElementToken elementTokenWithName:@"dd" occurrenceIndicator:@"?"], nil];
	aModelGroup = [ATModelGroup modelGroupWithContentTokens:[NSArray arrayWithObjects:[ATModelGroup modelGroupWithContentTokens:aContentTokens2], @"|", [ATModelGroup modelGroupWithContentTokens:aContentTokens], nil]];
	anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"dt" startTagMinimization:NO endTagMinimization:YES content:aModelGroup];
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	//a
	anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"a" content:[ATDeclaredContent RCDATA]];
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	//p
	anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"p" startTagMinimization:NO endTagMinimization:YES content:[ATDeclaredContent EMPTY]];
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	//h3
	anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"h3" content:[ATDeclaredContent RCDATA]];
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	//hr
	anElementDeclaration = [ATElementDeclaration elementDeclarationWithElementType:@"hr" startTagMinimization:NO endTagMinimization:YES content:[ATDeclaredContent EMPTY]];
	[anElementDeclarationDic setObject:anElementDeclaration forKey:[anElementDeclaration elementType]];
	
	declarationDictionary = [anElementDeclarationDic copy];
	
	return self;
}

- (void)dealloc
{
	[declarationDictionary release];
	
	[super dealloc];
}

- (ATElementDeclaration *)elementDeclarationForName:(NSString *)aName
{
	return [declarationDictionary objectForKey:aName];
}

@end
