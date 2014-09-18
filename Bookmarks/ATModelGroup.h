//
//  ATModelGroup.h
//  Bookmarks
//
//  Created by 高田 明史 on 07/08/09.
//  Copyright 2007 Pedophilia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ATContent.h"

@class ATProcessIndicator;

@interface ATModelGroup : NSObject <ATContent>
{
	NSArray *contentTokens;
	NSString *occurrenceIndicator;
}

+ (id)modelGroupWithContentTokens:(NSArray *)aContentTokens;
+ (id)modelGroupWithContentTokens:(NSArray *)aContentTokens occurrenceIndicator:(NSString *)anIndicator;

- (id)initWithContentTokens:(NSArray *)aContentTokens;
- (id)initWithContentTokens:(NSArray *)aContentTokens occurrenceIndicator:(NSString *)anIndicator;

- (ATProcessIndicator *)asProcessIndicator;

- (BOOL)isDeclaredContent;

- (BOOL)isPrimitiveContentToken;
- (BOOL)isModelGroup;

- (NSString *)occurrenceIndicator;

- (NSEnumerator *)objectEnumerator;

@end
