//
//  ATElement.m
//  Bookmarks
//
//  Created by 高田 明史 on 07/08/09.
//  Copyright 2007 Pedophilia. All rights reserved.
//

#import "ATElement.h"
#import "ATNetscapeBookmarkFile1DocumentEntity.h"
#import "ATElementDeclaration.h"
#import "ATProcessIndicator.h"
#import "ATElementToken.h"
#import "ATNetscapeBookmarkFile1Scanner.h"
#import "ATSubtreeEnumerator.h"
#import "ATDTD.h"
#import "ATDeclaredContent.h"

@implementation ATElement

+ (id)elementWithName:(NSString *)aName documentEntity:(ATNetscapeBookmarkFile1DocumentEntity *)aDocument scanner:(ATNetscapeBookmarkFile1Scanner *)aScanner
{
	return [[[self alloc] initWithName:aName documentEntity:aDocument scanner:aScanner] autorelease];
}

- (id)initWithName:(NSString *)aName documentEntity:(ATNetscapeBookmarkFile1DocumentEntity *)aDocument scanner:(ATNetscapeBookmarkFile1Scanner *)aScanner
{
	[super init];
	
	name = [aName copy];
	documentEntity = aDocument;
	scanner = [aScanner retain];
	
	return self;
}

- (void)dealloc
{
	[startTag release];
	[endTag release];
	[name release];
	[content release];
	[scanner release];
	
	[super dealloc];
}

- (BOOL)parse
{
	BOOL aParsingSucceed = NO;
	ATElementDeclaration *anElementDeclaration = [[documentEntity DTD] elementDeclarationForName:name];
	ATMarkup *aStartTag = [scanner scanStartTagFor:name];
	
	if (aStartTag || [anElementDeclaration startTagMinimization])
	{
		startTag = [aStartTag retain];
		
		if ([self parseContentFor:[anElementDeclaration content]])
		{
			ATMarkup *anEndTag = [scanner scanEndTagFor:name];
			
			if (anEndTag || [anElementDeclaration endTagMinimization])
			{
				endTag = [anEndTag retain];
				aParsingSucceed = YES;
			}
		}
	}
			
	return aParsingSucceed;
}

- (BOOL)parseContentFor:(id)aContent
{
	if ([aContent isDeclaredContent])
	{
		BOOL aProcessSucceed = NO;
		
		if ([aContent isEMPTY])
			aProcessSucceed = YES;
		else
		{
			NSString *aRCDATA = [scanner scanReplaceableCharacterData];
							
			if (aRCDATA)
			{
				//NSLog(aRCDATA);
				[self setContent:aRCDATA];
			}
			else
				NSLog(@"No RCDATA");
			
			aProcessSucceed = YES;
		}
		
		return aProcessSucceed;
	}
	else
	{
		ATProcessIndicator *anIndicator = [aContent asProcessIndicator];
		id aSubIndicator = nil;
		NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
		
		while ((aSubIndicator = [anIndicator nextIndicator]))
		{
			if ([aSubIndicator isElementTokenIndicator])
			{
				ATElement *aChildElement = [ATElement elementWithName:[aSubIndicator elementName] documentEntity:documentEntity scanner:scanner]; 
				
				if ([aChildElement parse])
				{
					[self add:aChildElement];
					[aSubIndicator contentOccurred];
				}
				else
					[aSubIndicator contentDoesNotOccurred];
			}
		}
		
		[aPool release];
		
		return [anIndicator isSuccess];
	}
}

- (NSDictionary *)attributeList
{
	return [startTag attributeList];
}

- (void)setContent:(id)aContent
{
	[content release];
	content = [aContent retain];
}

- (id)content
{
	return content;
}

- (void)add:(id)aContent
{
	if (!content)
		content = [NSMutableArray new];
	
	[content addObject:aContent];
}

- (BOOL)nameIs:(NSString *)aName
{
	return startTag ? [startTag nameIs:aName] : [[name uppercaseString] isEqualToString:[aName uppercaseString]];
}

- (BOOL)hasChildElement
{
	return [content isKindOfClass:[NSArray class]];
}

- (NSUInteger)countOfElementNamed:(NSString *)aName;
{
	if ([self hasChildElement])
	{
		unsigned aCount = 0;
		NSEnumerator *anEnumerator = [self objectEnumerator];
		ATElement *anElement = nil;
		
		while (anElement = [anEnumerator nextObject])
		{
			if ([anElement nameIs:aName])
				++aCount;
				
			if ([anElement hasChildElement])
				aCount += [anElement countOfElementNamed:aName];
		}
				
		return aCount;
	}
	else
		return 0;
}

- (NSEnumerator *)objectEnumerator
{
	return [content objectEnumerator];
}

- (NSEnumerator *)subtreeEnumerator
{
	return [ATSubtreeEnumerator enumeratorWithElement:self];
}

- (NSString *)description
{
	NSMutableString *aString = [NSMutableString string];
	
	[self writeDescriptionTo:aString level:0];
	
	return aString;
}

- (void)writeDescriptionTo:(NSMutableString *)aString level:(NSUInteger)aLevel
{
	NSMutableString *anIndent = [NSMutableString string];
	unsigned i = 0;

	for ( ; i < aLevel ; i++)
	{
		[anIndent appendString:@" "];
	}
		
	if (startTag)
		[aString appendFormat:@"%@<%@>\n", anIndent, name];
	
	if (content)
	{
		if ([content isKindOfClass:[NSArray class]])
		{
			NSEnumerator *anEnumerator = [content objectEnumerator];
			id aContent = nil;
			
			while (aContent = [anEnumerator nextObject])
				[aContent writeDescriptionTo:aString level:aLevel +  1];
		}
		else
		{
			[aString appendFormat:@"%@ %@\n", anIndent, content];
		}
	}
	
	if (endTag)
		[aString appendFormat:@"%@</%@>\n", anIndent, name];
}

@end
