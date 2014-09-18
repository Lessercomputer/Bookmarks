//
//  ATNetscapeBookmarkFile1Scanner.m
//  Bookmarks
//
//  Created by 高田 明史 on 07/08/03.
//  Copyright 2007 Pedophilia. All rights reserved.
//

#import "ATNetscapeBookmarkFile1Scanner.h"
#import "ATMarkup.h"

static NSCharacterSet *nameStartCharacterSet;
static NSCharacterSet *numberCharacterSet;
static NSCharacterSet *nameCharacterSet;

static NSCharacterSet *dataCharacterSet;
static NSCharacterSet *SGMLCharacterSet;
static NSCharacterSet *SGMLCharacterSetExceptingHyphen;

static NSDictionary *characterReferenceDictionary;

@implementation ATNetscapeBookmarkFile1Scanner

+ (void)initialize
{
	static BOOL initialized = NO;

	if (!initialized)
	{
		NSRange aLowercaseCharRange = NSMakeRange((NSUInteger)'a', (NSUInteger)('z' - 'a') + 1);
		NSRange anUppercaseCharRange = NSMakeRange((NSUInteger)'A', (NSUInteger)('Z' - 'A') + 1);
		NSRange aNumberCharRange =  NSMakeRange((NSUInteger)'0', 10);
		
		NSMutableCharacterSet *aTempCharSet = [NSCharacterSet characterSetWithRange:aLowercaseCharRange];
		numberCharacterSet = [[NSCharacterSet characterSetWithRange:aNumberCharRange] copy];
		[aTempCharSet addCharactersInRange:anUppercaseCharRange];
		nameStartCharacterSet = [aTempCharSet copy];
		
		aTempCharSet = [nameStartCharacterSet mutableCopy];
		[aTempCharSet formUnionWithCharacterSet:numberCharacterSet];
		[aTempCharSet addCharactersInString:@".-_:"];
		[aTempCharSet removeCharactersInString:@">"];
		nameCharacterSet = [aTempCharSet copy];
		
		characterReferenceDictionary = [[NSDictionary dictionaryWithObjectsAndKeys:@"\"",@"quot", @"&",@"amp", @"<",@"lt", @">",@"gt", nil] copy];
		
		aTempCharSet = [NSMutableCharacterSet characterSetWithRange:NSMakeRange(9, 20)];
		[aTempCharSet addCharactersInRange:NSMakeRange(13, 1)];
		[aTempCharSet addCharactersInRange:NSMakeRange(32, 95)];
		[aTempCharSet addCharactersInRange:NSMakeRange(160, 55136)];
		[aTempCharSet addCharactersInRange:NSMakeRange(57344, 1056768)];
		SGMLCharacterSet = [aTempCharSet copy];
		
		[aTempCharSet removeCharactersInString:@"-"];
		SGMLCharacterSetExceptingHyphen = [aTempCharSet copy];
		
		[aTempCharSet addCharactersInString:@"-"];
		[aTempCharSet removeCharactersInString:@"\"&<>"];
		dataCharacterSet = [aTempCharSet copy];
		
		initialized = YES;
	}
}

- (id)initWithString:(NSString *)aString
{
	[super init];
	
	scanner = [[NSScanner alloc] initWithString:aString];
	[scanner setCharactersToBeSkipped:nil];
	
	return self;
}

- (void)dealloc
{
	[scanner release];
	
	[super dealloc];
}

- (unichar)currentCharacter
{
	return [[scanner string] characterAtIndex:[scanner scanLocation]];
}

- (ATMarkup *)scanStartTagFor:(NSString *)aName
{
	NSUInteger aPrevLoc = [scanner scanLocation];
	ATMarkup *aMarkup = [self scanStartTag];
	
	if (aMarkup && [aMarkup nameIs:aName])
	{
		//NSLog(aName);
		return aMarkup;
	}
	else
	{
		[scanner setScanLocation:aPrevLoc];
		
		return nil;
	}
}

- (ATMarkup *)scanEndTagFor:(NSString *)aName
{
	NSUInteger aPrevLoc = [scanner scanLocation];
	ATMarkup *aMarkup = [self scanEndTag];
	
	if (aMarkup && [aMarkup nameIs:aName])
	{
		//NSLog([@"/" stringByAppendingString:aName]);
		return aMarkup;
	}
	else
	{
		[scanner setScanLocation:aPrevLoc];
		
		return nil;
	}
}

- (ATMarkup *)scanMarkupFor:(NSString *)aName
{
	NSUInteger aPrevLoc = [scanner scanLocation];
	ATMarkup *aMarkup = [self scanMarkup];
	
	if (aMarkup && [aMarkup nameIs:aName])
		return aMarkup;
	else
	{
		[scanner setScanLocation:aPrevLoc];
		
		return nil;
	}
}

- (ATMarkup *)scanMarkup
{
	ATMarkup *aMarkup = nil;
	
	[scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
	
	if ((aMarkup = [self scanMarkupDeclaration]))
		return aMarkup;
	else if ((aMarkup = [self scanStartTag]))
		return aMarkup;
	else if ((aMarkup = [self scanEndTag]))
		return aMarkup;
	else
		return nil;
}

- (ATMarkup *)scanMarkupDeclaration
{
	if ([self scanMDO])
	{
		if ([scanner scanString:@"DOCTYPE" intoString:nil])
		{
			NSString *aName = nil;
			
			[scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
			
			aName = [self scanGenericIdentifier];
			
			if (aName && [self scanMDC])
				return [ATMarkup documentTypeDeclarationWithName:aName];
			else
				return nil;
		}
		else if ([self scanCOM])
		{
			NSString *aComment = nil;
			
			[scanner scanCharactersFromSet:SGMLCharacterSetExceptingHyphen intoString:&aComment];
			
			if ([self scanCOM] && [self scanMDC])
				return [ATMarkup commentDeclarationWithComment:aComment];
			else
				return nil;
		}
        else
            return nil;
	}
	else
		return nil;
}

- (ATMarkup *)scanStartTag
{
	NSUInteger aPrevLoc = [scanner scanLocation];
	BOOL aScanningSucceed = NO;
	ATMarkup *aMarkup = nil;
	
	[scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
	
	if ([self scanSTAGO])
	{
		NSString *aName = [self scanGI];
		
		if (aName)
		{
			NSDictionary *anAttributeDict = [self scanAttributeList];
			
			//NSLog(aName);
			
			if ([self scanTAGC])
			{
				aMarkup = anAttributeDict ? [ATMarkup startTagWithName:aName attributeList:anAttributeDict] : [ATMarkup startTagWithName:aName];
				aScanningSucceed = YES;
			}
		}
	}
	
	if (!aScanningSucceed)
		[scanner setScanLocation:aPrevLoc];
		
	return aMarkup;
}

- (ATMarkup *)scanEndTag
{
	NSString *aName = nil;
	
	[scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
	
	if ([self scanETAGO] && (aName = [self scanGI]) && [self scanTAGC])
		return [ATMarkup endTagWithName:aName];
	else
		return nil;
}

- (BOOL)scanMDO
{
	return [scanner scanString:@"<!" intoString:nil];
}

- (BOOL)scanMDC
{
	return [scanner scanString:@">" intoString:nil];
}

- (BOOL)scanCOM
{
	return [scanner scanString:@"--" intoString:nil];
}

- (BOOL)scanSTAGO
{
	return [scanner scanString:@"<" intoString:nil];
}

- (BOOL)scanTAGC
{
	return [scanner scanString:@">" intoString:nil];
}

- (BOOL)scanETAGO
{
	return [scanner scanString:@"</" intoString:nil];
}

- (void)scanDOCTYPE
{
	[self scanMDO];
}

- (NSString *)scanGI
{
	return [self scanGenericIdentifier];
}

- (NSString *)scanGenericIdentifier
{
	return [self scanName];
}

- (NSDictionary *)scanAttributeList
{
	NSString *aName = nil, *anAttribute = nil;
	NSMutableDictionary *anAttributeDict = [NSMutableDictionary dictionary];
	
	while ([self scanAttributeSpecificationInto:&aName into:&anAttribute])
		[anAttributeDict setObject:anAttribute forKey:aName];
		
	if ([anAttributeDict count])
	{
		[scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:nil];
		return anAttributeDict;
	}
	else
		return nil;
}

- (BOOL)scanAttributeSpecificationInto:(NSString **)aName into:(NSString **)anAttribute
{
	NSString *aReturningName = nil;
	NSString *aReturningAttribute = nil;
	NSUInteger aPrevLoc = [scanner scanLocation];
	BOOL aWhitespacesSkipped = NO;
	
	aWhitespacesSkipped = [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:nil];
	
	if ((aReturningName = [self scanName]) && [scanner scanString:@"=" intoString:nil] && (aReturningAttribute = [self scanAttributeValueLiteral]))
	{
		*aName = aReturningName;
		*anAttribute = aReturningAttribute;
		
		return YES;
	}
	else
	{
		if (aWhitespacesSkipped)
			[scanner setScanLocation:aPrevLoc];
			
		return NO;
	}
}

- (NSString *)scanName
{
	if (![scanner isAtEnd] && [nameStartCharacterSet characterIsMember:[self currentCharacter]])
	{
		NSUInteger aLoc = [scanner scanLocation];
		
		[scanner scanCharactersFromSet:nameCharacterSet intoString:nil];
		
		return [[scanner string] substringWithRange:NSMakeRange(aLoc, [scanner scanLocation] - aLoc)];
	}
	else
		return nil;
}

- (NSString *)scanAttributeValueLiteral
{
	NSString *aString = nil;
	
	if ([scanner scanString:@"\"" intoString:nil] && (aString = [self scanReplaceableCharacterData]) && [scanner scanString:@"\"" intoString:nil])
		return aString;
	else
		return nil;
}

- (NSString *)scanRCDATA
{
	return [self scanReplaceableCharacterData];
}

- (NSString *)scanReplaceableCharacterData
{
	NSMutableString *aReplaceableCharacterData = [NSMutableString string];
	NSString *aString = nil;
	
	while ((aString = [self scanDataCharacter]) || (aString = [self scanCharacterReference]) || (aString = [self scanAMP]))
	{
		[aReplaceableCharacterData appendString:aString];
	}
	
	return aReplaceableCharacterData;
}

- (NSString *)scanDataCharacter
{
	NSString *aString = nil;
	[scanner scanCharactersFromSet:dataCharacterSet intoString:&aString];
	return aString;
}

- (NSString *)scanCharacterReference
{
	NSUInteger aPrevLoc = [scanner scanLocation];
	NSString *aName = nil;
	
	if (([scanner scanString:@"&#" intoString:nil] || [scanner scanString:@"&" intoString:nil]) && ((aName = [self scanName]) || (aName = [self scanNumber])) && [scanner scanString:@";" intoString:nil])
		return [self replaceCharacterReference:aName];
	else
	{
		[scanner setScanLocation:aPrevLoc];
		
		return nil;
	}
}

- (NSString *)scanNumber
{
	NSString *aNumber = nil;
	
	[scanner scanCharactersFromSet:numberCharacterSet intoString:&aNumber];
	
	return aNumber;
}

- (NSString *)scanAMP
{
	NSString *aString = nil;
	
	[scanner scanString:@"&" intoString:&aString];
	
	return aString;
}

- (NSString *)replaceCharacterReference:(NSString *)aString
{
	NSString *aReferencedString = [characterReferenceDictionary objectForKey:aString];
	
	if (!aReferencedString)
	{
		unichar aChar = (unichar)[aString intValue];
		
		return [NSString stringWithCharacters:&aChar length:1];
	}
	else
		return aReferencedString;
}

@end
