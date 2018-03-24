//
//  ATNetscapeBookmarkFile1Scanner.h
//  Bookmarks
//
//  Created by Akifumi Takata on 07/08/03.
//  Copyright 2007 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATMarkup;

@interface ATNetscapeBookmarkFile1Scanner : NSObject
{
	NSScanner *scanner;
}

- (id)initWithString:(NSString *)aString;

- (unichar)currentCharacter;
- (ATMarkup *)scanMarkupFor:(NSString *)aName;
- (ATMarkup *)scanMarkup;
- (ATMarkup *)scanMarkupDeclaration;
- (ATMarkup *)scanStartTagFor:(NSString *)aName;
- (ATMarkup *)scanStartTag;
- (ATMarkup *)scanEndTagFor:(NSString *)aName;
- (ATMarkup *)scanEndTag;

- (BOOL)scanMDO;
- (BOOL)scanMDC;
- (BOOL)scanCOM;
- (BOOL)scanSTAGO;
- (BOOL)scanTAGC;
- (BOOL)scanETAGO;
- (void)scanDOCTYPE;

- (NSString *)scanGI;
- (NSString *)scanGenericIdentifier;
- (BOOL)scanAttributeSpecificationInto:(NSString **)aName into:(NSString **)anAttribute;
- (NSString *)scanName;
- (NSString *)scanAttributeValueLiteral;
- (NSString *)scanRCDATA;
- (NSString *)scanAMP;
- (NSString *)scanNumber;
- (NSString *)scanReplaceableCharacterData;
- (NSString *)scanDataCharacter;
- (NSString *)scanCharacterReference;
- (NSString *)replaceCharacterReference:(NSString *)aString;

@end
