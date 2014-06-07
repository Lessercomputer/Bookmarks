//
//  ATJSONParser.m
//  Bookmarks
//
//  Created by 高田 明史 on 2014/05/24.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
//

#import "ATJSONParser.h"

static NSString *ATJSONParserLeftSquareBracket = @"[";
static NSString *ATJSONParserLeftCurlyBracket = @"{";
static NSString *ATJSONParserRightSquareBracket = @"]";
static NSString *ATJSONParserRightCurlyBracket = @"}";
static NSString *ATJSONParserColon = @":";
static NSString *ATJSONParserComma = @",";
static NSString *ATJSONParserQuotationMark = @"\"";
static NSString *ATJSONParserEscape = @"\\";
static NSCharacterSet *ATJSONParserUnescaped;
static NSString *ATJSONParserReverseSolidus = @"\\";
static NSString *ATJSONParserSolidus = @"/";
static NSString *ATJSONParserBackspace = @"\b";
static NSString *ATJSONParserFormFeed = @"\f";
static NSString *ATJSONParserLineFeed = @"\n";
static NSString *ATJSONParserCarriageReturn = @"\r";
static NSString *ATJSONParserTab = @"\t";
static NSCharacterSet *ATJSONParserHexDig;
static NSCharacterSet *ATJSONParserDigit1To9;

@implementation ATJSONParser

+ (void)initialize
{
    NSMutableCharacterSet *aCharacterSet = [NSMutableCharacterSet characterSetWithRange:NSMakeRange(0x20, 0x21 - 0x20 + 1)];
    [aCharacterSet addCharactersInRange:NSMakeRange(0x23, 0x5B - 0x23 + 1)];
    [aCharacterSet addCharactersInRange:NSMakeRange(0x5D, 0x10FFFF - 0x5D + 1)];
    ATJSONParserUnescaped = [aCharacterSet copy];
    
    ATJSONParserHexDig = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"] copy];
    
    ATJSONParserDigit1To9 = [[NSCharacterSet characterSetWithCharactersInString:@"123456789"] copy];
}

+ (id)parserWithString:(NSString *)aString
{
    return [[[self alloc] initWithString:aString] autorelease];
}

- (id)initWithString:(NSString *)aString
{
    if (self = [super init])
    {
        scanner = [[NSScanner alloc] initWithString:aString];
        [scanner setCharactersToBeSkipped:nil];
    }
    
    return self;
}

- (id)parse
{
    return [self parseJSONText];
}

- (void)dealloc
{
    [scanner release];
    
    [super dealloc];
}

@end

@implementation ATJSONParser (Parsing)

- (id)parseJSONText
{
    id anObjectOrArray = nil;
    
    if ([self parseObjectInto:&anObjectOrArray])
        return anObjectOrArray;
    else if ([self parseArrayInto:&anObjectOrArray])
        return anObjectOrArray;
    
    return anObjectOrArray;
}

- (BOOL)parseObjectInto:(NSMutableDictionary **)anObject
{
    if ([self scanBeginObject])
    {
        *anObject = [NSMutableDictionary dictionary];
    
        [self parseMembersInto:*anObject];
        
        return [self scanEndObject];
    }
    else
        return NO;
}

- (BOOL)parseArrayInto:(NSMutableArray **)anArray
{
    if ([self scanBeginArray])
    {
        *anArray = [NSMutableArray array];
        NSUInteger aLocation = [scanner scanLocation];
    
        [self parseValuesInto:*anArray];
        
        return [self scanEndArray];
    }
    else
        return NO;
}

- (BOOL)scanBeginArray
{
    return [self scanStructualCharacters:ATJSONParserLeftSquareBracket];
}

- (BOOL)scanBeginObject
{
    return [self scanStructualCharacters:ATJSONParserLeftCurlyBracket];
}

- (BOOL)scanEndArray
{
    return [self scanStructualCharacters:ATJSONParserRightSquareBracket];
}

- (BOOL)scanEndObject
{
    return [self scanStructualCharacters:ATJSONParserRightCurlyBracket];
}

- (BOOL)scanNameSeparator
{
    return [self scanStructualCharacters:ATJSONParserColon];
}

- (BOOL)scanValueSeparator
{
    return [self scanStructualCharacters:ATJSONParserComma];
}

- (BOOL)scanWs
{
    return [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
}

- (BOOL)scanStructualCharacters:(NSString *)aCharacter
{
    BOOL scanned;
    
    [self scanWs];
    scanned = [scanner scanString:aCharacter intoString:NULL];
    [self scanWs];
    
    return scanned;
}

- (BOOL)scanFalse
{
    return [scanner scanString:@"false" intoString:NULL];
}

- (BOOL)scanNull
{
    return [scanner scanString:@"null" intoString:NULL];
}

- (BOOL)scanTrue
{
    return [scanner scanString:@"true" intoString:NULL];
}

- (BOOL)parseMembersInto:(NSMutableDictionary *)anObject
{
    if (![self parseMemberInto:anObject]) return YES;
    
    while ([self scanValueSeparator])
        if (![self parseMemberInto:anObject])
            return NO;

    return YES;
}

- (BOOL)parseMemberInto:(NSMutableDictionary *)anObject
{
    NSMutableString *aString = nil;
    id aValue = nil;
    
    if (![self parseStringInto:&aString]) return NO;
    
    if (![self scanNameSeparator]) return NO;
    
    if (![self parseValueInto:&aValue]) return NO;
    
    [anObject setObject:aValue forKey:aString];
    
    return YES;
}

- (BOOL)parseValuesInto:(NSMutableArray *)anArray
{
    if (![self parseValueIntoArray:anArray]) return YES;
    
    while ([self scanValueSeparator])
        if (![self parseValueIntoArray:anArray])
            return NO;
    
    return YES;
}

- (BOOL)parseValueIntoArray:(NSMutableArray *)anArray
{
    id aValue;
    NSUInteger aLocation = [scanner scanLocation];
    
    if ([self parseValueInto:&aValue])
    {
        [anArray addObject:aValue];
        return YES;
    }
    else
        return NO;
}

- (BOOL)parseStringInto:(NSMutableString **)aString
{
    if (![scanner scanString:ATJSONParserQuotationMark intoString:NULL]) return NO;
    
    [self parseCharsInto:aString];
    
    if (![scanner scanString:ATJSONParserQuotationMark intoString:NULL]) return NO;
    
    return YES;
}

- (BOOL)parseValueInto:(id *)aValue
{
    NSMutableDictionary *anObject;
    NSMutableArray *anArray;
    NSNumber *aNumber;
    NSMutableString *aString;
    
    if ([self scanFalse])
    {
        *aValue = [NSNumber numberWithBool:NO];
        return YES;
    }
    else if ([self scanNull])
    {
        *aValue = [NSNull null];
        return YES;
    }
    else if ([self scanTrue])
    {
        *aValue = [NSNumber numberWithBool:YES];
        return YES;
    }
    else if ([self parseObjectInto:&anObject])
    {
        *aValue = anObject;
        return YES;
    }
    else if ([self parseArrayInto:&anArray])
    {
        *aValue = anArray;
        return YES;
    }
    else if ([self parseNumberInto:&aNumber])
    {
        *aValue = aNumber;
        return YES;
    }
    else if ([self parseStringInto:&aString])
    {
        *aValue = aString;
        return YES;
    }
    
    return NO;
}

- (BOOL)parseCharsInto:(NSMutableString **)aChars
{
    NSMutableString *aString = [NSMutableString string];
    NSMutableString *aTemporaryString;
    
    while ([self parseUnescapedInto:&aTemporaryString] || [self parseEscapeInto:&aTemporaryString])
        [aString appendString:aTemporaryString];
    
    *aChars = aString;
    if ([aString length]) return YES;
    else return NO;
}

- (BOOL)parseUnescapedInto:(NSString **)aChars
{
    return [scanner scanCharactersFromSet:ATJSONParserUnescaped intoString:aChars];
}

- (BOOL)parseEscapeInto:(NSString **)aChars
{
    if (![scanner scanString:ATJSONParserEscape intoString:NULL]) return NO;

    if ([scanner scanString:ATJSONParserQuotationMark intoString:aChars]
            || [scanner scanString:ATJSONParserReverseSolidus intoString:aChars]
            || [scanner scanString:ATJSONParserSolidus intoString:aChars]
            || [scanner scanString:ATJSONParserBackspace intoString:aChars]
            || [scanner scanString:ATJSONParserFormFeed intoString:aChars]
            || [scanner scanString:ATJSONParserLineFeed intoString:aChars]
            || [scanner scanString:ATJSONParserCarriageReturn intoString:aChars]
            || [scanner scanString:ATJSONParserTab intoString:aChars])
        return YES;
    else if ([scanner scanString:@"u" intoString:NULL])
    {
        NSUInteger aLocation = [scanner scanLocation];
        unsigned int aHexValue;
        NSString *aString = [scanner string];
        NSUInteger i = 0;

        for (; i < 4 && aLocation + i < [[scanner string] length] && [ATJSONParserHexDig characterIsMember:[aString characterAtIndex:aLocation + i]]; i++)
            ;
        
        if (i == 4)
        {
            NSString *a4Hexdig = [aString substringWithRange:NSMakeRange(aLocation, i)];
            [[NSScanner scannerWithString:a4Hexdig] scanHexInt:&aHexValue];
            unichar aUnichar = (unichar)aHexValue;
            *aChars = [NSString stringWithCharacters:&aUnichar length:1];
            [scanner setScanLocation:aLocation + 4];
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)parseNumberInto:(NSNumber **)aNumber
{
    NSUInteger aLocation = [scanner scanLocation];
    BOOL aNumberHasFracOrExp = NO;
    
    [self scanMinus];
    
    if (![self scanInt]) return NO;
    
    if ([self scanFrac]) aNumberHasFracOrExp = YES;
    if ([self scanExp]) aNumberHasFracOrExp = YES;
    
    [scanner setScanLocation:aLocation];
    
    if (aNumberHasFracOrExp)
    {
        double aDouble;
        [scanner scanDouble:&aDouble];
        *aNumber = @(aDouble);
        return YES;
    }
    else
    {
        NSInteger anInteger;
        [scanner scanInteger:&anInteger];
        *aNumber = @(anInteger);
        return YES;
    }
}

- (BOOL)scanMinus
{
    return [scanner scanString:@"-" intoString:NULL];
}

- (BOOL)scanPlus
{
    return [scanner scanString:@"+" intoString:NULL];
}

- (BOOL)scanZero
{
    return [scanner scanString:@"0" intoString:NULL];
}

- (BOOL)scanInt
{
    if ([self scanZero])
        return YES;
    else
    {
        if (![scanner scanCharactersFromSet:ATJSONParserDigit1To9 intoString:NULL])
            return NO;
        
        [scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:NULL];
        return YES;
    }
}

- (BOOL)scanFrac
{
    if (![scanner scanString:@"." intoString:NULL]) return NO;
    
    return [scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:NULL];
}

- (BOOL)scanExp
{
    if (!([scanner scanString:@"e" intoString:NULL] || [scanner scanString:@"E" intoString:NULL])) return NO;
    
    [self scanMinus] || [self scanPlus];
    
    return [scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:NULL];
}

@end