//
//  ATProcessIndicator.m
//  Bookmarks
//
//  Created by P,T,A on 07/08/10.
//  Copyright 2007 PEDOPHILIA. All rights reserved.
//

#import "ATProcessIndicator.h"
#import "ATContentModel.h"
#import "ATElementToken.h"

@implementation ATProcessIndicator

- (id)initWithContent:(id)aContent
{
	[super init];
	
	content = [aContent retain];
	
	if ([content isModelGroup])
	{
		NSEnumerator *anEnumerator = [content objectEnumerator];
		id aSubContent = nil;
		
		indicators = [NSMutableArray new];
		
		while (aSubContent = [anEnumerator nextObject])
		{
			if (![aSubContent isKindOfClass:[NSString class]])
				[indicators addObject:[aSubContent asProcessIndicator]];
			else if (!connector)
				connector = [aSubContent copy];
		}
		
		[indicators makeObjectsPerformSelector:@selector(setParent:) withObject:self];
	}
		
	return self;
}

- (void)dealloc
{
	[content release];
	[indicators release];
	[connector release];
	
	[super dealloc];
}

- (void)setParent:(ATProcessIndicator *)aParent
{
	[parent release];
	parent = [aParent retain];
}

- (id)nextIndicator
{
	if ([self isEvaluated])
	{
		return nil;
	}
	else if ([self isModelGroupIndicator])
	{
		NSEnumerator *anEnumerator = [indicators objectEnumerator];
		id anIndicator = nil;
		
		while ((anIndicator = [anEnumerator nextObject]) && [anIndicator isEvaluated])
			;
	
		return [anIndicator nextIndicator];
	}
	else
	{
		return self;
	}
}

- (void)evaluated:(ATProcessIndicator *)aChildIndicator
{
	if ([aChildIndicator isSuccess])
	{
		if (([self isOR] || [self allIndicatorsProcessed]) && ![[content occurrenceIndicator] isEqualToString:@"*"])
			[self succeed];
		
		if ([[content occurrenceIndicator] isEqualToString:@"*"] && ([self allIndicatorsProcessed] || [self isOR]))
			[self initializeProcessingStatus];
	}
	else
	{
		if ([self isOrdered] || [self allIndicatorsProcessed])
		{
			if ([[content occurrenceIndicator] isEqualToString:@"*"])
				[self succeed];
			else
				[self failed];
		}
	}
}

- (void)initializeProcessingStatus
{
	isEvaluated = NO;
	isSuccess = NO;
	
	[indicators makeObjectsPerformSelector:@selector(initializeProcessingStatus)];
}

- (BOOL)allIndicatorsProcessed
{
	return ![self hasIndicatorToBeEvaluated];
}

- (BOOL)isAtEnd
{
	return ![self hasIndicatorToBeEvaluated];
}

- (BOOL)hasIndicatorToBeEvaluated
{
	return [self nextIndicator] ? YES : NO;
}

- (void)succeed
{
	isEvaluated = YES;
	isSuccess = YES;
	
	if (parent)
		[parent evaluated:self];
}

- (void)failed
{
	isEvaluated = YES;
	isSuccess = NO;
	
	if (parent)
		[parent evaluated:self];
}

- (void)contentOccurred
{
	if (![content occurrenceIndicator] || [[content occurrenceIndicator] isEqualToString:@"?"])
		[self succeed];
}

- (void)contentDoesNotOccurred
{
	if (![content occurrenceIndicator])
		[self failed];
	else if ([[content occurrenceIndicator] isEqualToString:@"*"] || [[content occurrenceIndicator] isEqualToString:@"?"])
		[self succeed];
}

- (BOOL)isEvaluated
{
	return isEvaluated;
}

- (BOOL)isSuccess
{
	return isSuccess;
}

- (BOOL)isModelGroupIndicator
{
	return [content isModelGroup];
}

- (BOOL)isElementTokenIndicator
{
	return [content isElementToken];
}

- (BOOL)isOrdered
{
	return [connector isEqualToString:@","];
}

- (BOOL)isOR
{
	return [connector isEqualToString:@"|"];
}

- (NSString *)elementName
{
	return [content elementName];
}

@end
