//
//  ATEditor.m
//  Bookmarks
//
//  Created by P,T,A on 05/10/12.
//  Copyright 2005 Nursery-Framework. All rights reserved.
//

#import "ATEditor.h"
#import "ATItem.h"
#import "ATBookmarksPresentation.h"

@implementation ATEditor

@end

@implementation ATEditor (Initializing)

+ (id)editorFor:(id)anItem  on:(ATBookmarksPresentation *)aBookmarksPresentaion
{
	return [[[self alloc] initWith:anItem on:aBookmarksPresentaion] autorelease];
}

- (id)initWith:(id)anItem on:(ATBookmarksPresentation *)aBookmarksPresentaion
{
	NSEnumerator *anEnumerator = nil;
	id aKey = nil;

	[super init];
	
	item = [anItem retain];
	value = [NSMutableDictionary new];
	status = [NSMutableDictionary new];
	bookmarksPresentation = aBookmarksPresentaion;
	
	anEnumerator = [[item editableValueKeys] objectEnumerator];
	
	while (aKey = [anEnumerator nextObject])
	{
		[[self value] addObserver:self forKeyPath:aKey options:NSKeyValueObservingOptionOld context:nil];
	}

	[value setDictionary:[anItem valueToEdit]];
    
    isMakingNewItem = ![anItem hasItemID];
	
    if ([self isMakingNewItem])
        [bookmarksPresentation beginMakingNewItem:self];
	
	return self;
}

- (void)dealloc
{
	NSEnumerator *anEnumerator = [[item editableValueKeys] objectEnumerator];
	id aKey = nil;
	
	while (aKey = [anEnumerator nextObject])
	{				
		[[self value] removeObserver:self forKeyPath:aKey];
	}

	[item release];
	[value release];
	[status release];
	
	[super dealloc];
}

@end

@implementation ATEditor (Accessing)

- (id)item
{
    return item;
}

- (NSMutableDictionary *)value
{
	return value;
}

- (NSMutableDictionary *)status
{
	return status;
}

@end

@implementation ATEditor (Testing)

- (BOOL)isValid
{
	return [[[self status] objectForKey:@"isValid"] boolValue];
}

- (BOOL)isMakingNewItem
{
    return isMakingNewItem;
}

@end

@implementation ATEditor (Accepting)

- (void)observeValueForKeyPath:(NSString *)keyPath
              ofObject:(id)object 
                        change:(NSDictionary *)change
                       context:(void *)context
{		
	[[self status] setValue:[NSNumber numberWithBool:[item validateEdited:[self value]]] forKeyPath:@"isValid"];
	//NSLog([[self status] description]);
}
	
- (void)accept
{
	[bookmarksPresentation accept:item edited:[self value]];
	
	if ([self isMakingNewItem])
        [bookmarksPresentation endMakingNewItem:self];
}

- (void)acceptIfValid
{
	if ([self isValid])
		[self accept];
}

- (void)cancel
{
    if ([self isMakingNewItem])
        [bookmarksPresentation endMakingNewItem:self];
}

@end
