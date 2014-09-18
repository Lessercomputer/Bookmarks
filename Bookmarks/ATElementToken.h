//
//  ATElementToken.h
//  ATBookmarks
//
//  Created by çÇìcÅ@ñæéj on 07/08/09.
//  Copyright 2007 Pedophilia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATProcessIndicator;

@interface ATElementToken : NSObject
{
	NSString *elementName;
	NSString *occurrenceIndicator;
}

+ (id)elementTokenWithName:(NSString *)aName;
+ (id)elementTokenWithName:(NSString *)aName occurrenceIndicator:(NSString *)anIndicator;

- (id)initWithName:(NSString *)aName occurrenceIndicator:(NSString *)anIndicator;

- (NSString *)elementName;
- (NSString *)occurrenceIndicator;

- (ATProcessIndicator *)asProcessIndicator;

- (BOOL)isElementToken;
- (BOOL)isPrimitiveContentToken;
- (BOOL)isModelGroup;

@end
