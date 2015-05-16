//
//  ATJSONParser.h
//  Bookmarks
//
//  Created by P,T,A on 2014/05/24.
//  Copyright (c) 2014年 PEDOPHILIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATJSONParser : NSObject
{
    NSScanner *scanner;
}

+ (id)parserWithString:(NSString *)aString;

- (id)initWithString:(NSString *)aString;

- (id)parse;

@end

@interface ATJSONParser (Parsing)

- (id)parseJSONText;
- (BOOL)parseObjectInto:(NSMutableDictionary **)anObject;
- (BOOL)parseArrayInto:(NSMutableArray **)anArray;
- (BOOL)scanBeginArray;
- (BOOL)scanBeginObject;
- (BOOL)scanEndArray;
- (BOOL)scanEndObject;
- (BOOL)scanNameSeparator;
- (BOOL)scanValueSeparator;
- (BOOL)scanWs;
- (BOOL)scanStructualCharacters:(NSString *)aCharacter;
- (BOOL)scanFalse;
- (BOOL)scanNull;
- (BOOL)scanTrue;
- (BOOL)parseMembersInto:(NSMutableDictionary *)anObject;
- (BOOL)parseMemberInto:(NSMutableDictionary *)anObject;
- (BOOL)parseValuesInto:(NSMutableArray *)anArray;
- (BOOL)parseValueIntoArray:(NSMutableArray *)anArray;
- (BOOL)parseStringInto:(NSMutableString **)aString;
- (BOOL)parseValueInto:(id *)aValue;
- (BOOL)parseCharsInto:(NSMutableString **)aChars;
- (BOOL)parseUnescapedInto:(NSString **)aChars;
- (BOOL)parseEscapeInto:(NSString **)aChars;
- (BOOL)parseNumberInto:(NSNumber **)aNumber;
- (BOOL)scanMinus;
- (BOOL)scanPlus;
- (BOOL)scanZero;
- (BOOL)scanInt;
- (BOOL)scanFrac;
- (BOOL)scanExp;

@end