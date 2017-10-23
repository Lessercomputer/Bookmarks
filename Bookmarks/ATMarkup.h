//
//  ATMarkup.h
//  Bookmarks
//
//  Created by P,T,A on 07/08/07.
//  Copyright 2007 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ATMarkup : NSObject
{
	NSString *name;
	NSDictionary *attributeList;
	NSString *comment;
}

+ (ATMarkup *)documentTypeDeclarationWithName:(NSString *)aName;
+ (ATMarkup *)commentDeclarationWithComment:(NSString *)aComment;
+ (ATMarkup *)startTagWithName:(NSString *)aName;
+ (ATMarkup *)startTagWithName:(NSString *)aName attributeList:(NSDictionary *)anAttributeDict;
+ (ATMarkup *)endTagWithName:(NSString *)aName;

- (id)initWithName:(NSString *)aName attributeList:(NSDictionary *)anAttributeList comment:(NSString *)aComment;

- (NSString *)name;
- (NSDictionary *)attributeList;

- (BOOL)nameIs:(NSString *)aName;

@end
