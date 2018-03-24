//
//  Bookmarks.m
//  Bookmarks
//
//  Created by Akifumi Takata  on 05/10/11.
//  Copyright 2005 Nursery-Framework. All rights reserved.
//

#import "ATBookmarks.h"
#import "ATBinder.h"
#import "ATBookmark.h"
#import "ATIDPool.h"
#import "ATBookmarksDocument.h"
#import "ATBookmarksItemsArchiver.h"
#import "ATBookmarksItemsUnarchiver.h"
#import "ATBookmarksUnarchiver.h"
#import "ATBookmarkItemsMoveOperation.h"
#import "ATMoveOperationItem.h"
#import "ATBookmarksEnumerator.h"
#import "ATBookmarksArchiver.h"
#import "ATBookmarksInsertOperation.h"
#import "ATBookmarksRemoveOperation.h"
#import "ATBookmarksMoveOperation.h"

NSString *ATBookmarksWillInsertNotification = @"ATBookmarksWillInsertNotification";
NSString *ATBookmarksDidInsertNotification = @"ATBookmarksDidInsertNotification";

NSString *ATBookmarksWillMovetNotification = @"ATBookmarksWillMovetNotification";
NSString *ATBookmarksDidMoveNotification = @"ATBookmarksDidMoveNotification";

NSString *ATBookmarksWillMoveOrInsertNotification = @"ATBookmarksWillMoveOrInsertNotification";
NSString *ATBookmarksDidMoveOrInsertNotification = @"ATBookmarksDidMoveOrInsertNotification";

NSString *ATBookmarksWillRemovetNotification = @"ATBookmarksWillRemovetNotification";
NSString *ATBookmarksDidRemoveNotification = @"ATBookmarksDidRemoveNotification";

NSString *ATBookmarksWillChangeNotification = @"ATBookmarksWillChangeNotification";
NSString *ATBookmarksDidChangeNotification = @"ATBookmarksDidChangeNotification";

NSString *ATBookmarksDidOpenFolderNotification = @"ATBookmarksDidOpenFolderNotification";
NSString *ATBookmarksDidCloseFolderNotification = @"ATBookmarksDidCloseFolderNotification";

NSString *ATBookmarksWillEditItemNotification = @"ATBookmarksWillEditItemNotification";
NSString *ATBookmarksDidEditItemNotification = @"ATBookmarksDidEditItemNotification";

NSString *ATBookmarksItemIDsPasteBoardType = @"ATBookmarksItemIDsPasteBoardType";
NSString *ATBookmarksItemsPropertyListRepresentaionPasteBoardType = @"ATBookmarksItemsPropertyListRepresentaionPasteBoardType";


@implementation ATBookmarks

@end

@implementation ATBookmarks (Initializing)

+ (id)bookmarksWithArchive:(NSDictionary *)anArchive
{
	return [ATBookmarksUnarchiver unarchive:anArchive];
}

- (id)initWithIDPool:(ATIDPool *)anIDPool items:(NSMutableDictionary *)anItemsDictionary root:(ATBinder *)aRoot
{
	[super init];
	
	idPool = [anIDPool retain];
    [self setItemLibrary:[NULibrary library]];
    [anItemsDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [[self itemLibrary] setObject:obj forKey:key];
    }];
	[self setRoot:aRoot];
	undoManager = [NSUndoManager new];
	changeCountOfDraggingPasteBoard = -1;
	
	return self;
}

- (id)init
{
	[super init];
	
	[self setRoot:[[ATBinder new] autorelease]];
    [self setIDPool:[ATIDPool idPool]];
//	[self setItems:[NSMutableArray array]];
//	[self setItemsDictionary:[NSMutableDictionary dictionary]];
    [self setItemLibrary:[NULibrary library]];
	undoManager = [NSUndoManager new];
	changeCountOfDraggingPasteBoard = -1;
	
	[self newItemIDTo:[self root]];
    [self registerItems:[NSArray arrayWithObject:[self root]]];
	
	return self;
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"ATBookmarks #dealloc");
#endif
    
    [self setDraggingSourceBinder:nil];
    [self setDraggingItemIndexes:nil];
    [self releaseItems];
	[self setRoot:nil];
    [self setIDPool:nil];
    [self setItemLibrary:nil];
	[undoManager release];
	
	[super dealloc];
}

- (id)retain
{
    return [super retain];
}

- (oneway void)release
{
    [super release];
}

- (void)releaseItems
{    
    [[self itemLibrary] enumerateKeysAndObjectsUsingBlock:^(id aKey, id aValue, BOOL *aStop) {
        [aValue setBinders:nil];
        if ([aValue isFolder]) [aValue setChildren:nil];
    }];
}

@end

@implementation ATBookmarks (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUSandbox *)aSandbox
{
    [aCharacter addOOPIvarWithName:@"root"];
    [aCharacter addOOPIvarWithName:@"idPool"];
    [aCharacter addOOPIvarWithName:@"items"];
    [aCharacter addOOPIvarWithName:@"itemsDictionary"];
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [aChildminder encodeObject:root];
    [aChildminder encodeObject:idPool];
//    [aChildminder encodeObject:items];
    [aChildminder encodeObject:itemLibrary];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    [super init];
    
    [self setRoot:[aChildminder decodeObjectReally]];
    [self setIDPool:[aChildminder decodeObjectReally]];
//    [self setItems:[aChildminder decodeObjectReally]];
    [self setItemLibrary:[aChildminder decodeObjectReally]];
    
    undoManager = [NSUndoManager new];
	changeCountOfDraggingPasteBoard = -1;

    return self;
}

- (NUBell *)bell
{
    return bell;
}

- (void)setBell:(NUBell *)anOOP
{
    bell = anOOP;
}

@end

@implementation ATBookmarks (Accessing)

- (ATIDPool *)idPool
{
	return idPool;
}

- (ATBinder *)root
{
	return root;
}

- (NSUInteger)count
{
	return [[self itemLibrary] count];
}

//- (NSMutableArray *)items
//{
//	return items;
//}

- (NULibrary *)itemLibrary
{
    return itemLibrary;
}

- (ATBookmarksDocument *)document
{
	return document;
}

- (void)setDocument:(ATBookmarksDocument *)aDocument
{
    document = aDocument;
}

- (NSUndoManager  *)undoManager
{
	return undoManager;
}

- (id)itemFor:(NSUInteger)anID
{
	return [[self itemLibrary] objectForKey:[NSNumber numberWithUnsignedInteger:anID]];
}

- (NSArray *)itemsFor:(NSArray *)anIDs
{
	NSMutableArray *anItems = [NSMutableArray array];
	NSEnumerator *anEnumerator = [anIDs objectEnumerator];
	id anItemID = nil;
	
	while (anItemID = [anEnumerator nextObject])
	{
		[anItems addObject:[self itemFor:[anItemID unsignedIntegerValue]]];
	}
	
	return anItems;
}

- (id)itemForIDNumber:(NSNumber *)anIDNumber
{
	return [self itemFor:[anIDNumber unsignedIntegerValue]];
}

- (NSArray *)itemsBy:(NSArray *)anIndexPaths
{	
	NSMutableArray *anItems = [NSMutableArray array];
	NSEnumerator *anEnumerator = [anIndexPaths objectEnumerator];
	NSIndexPath *anIndexPath = nil;
	
	while (anIndexPath = [anEnumerator nextObject])
	{
		[anItems addObject:[[self root] atIndexPath:anIndexPath]];
	}
	
	return anItems;
}

- (ATBinder *)draggingSourceBinder
{
    return draggingSourceBinder;
}

- (void)setDraggingSourceBinder:(ATBinder *)aBinder
{
    [draggingSourceBinder autorelease];
    draggingSourceBinder = [aBinder retain];
}

- (NSIndexSet *)draggingItemIndexes
{
    return draggingItemIndexes;
}

- (void)setDraggingItemIndexes:(NSIndexSet *)anIndexes
{
    [draggingItemIndexes autorelease];
    draggingItemIndexes = [anIndexes copy];
}

-(void)close
{
	[[self undoManager] removeAllActions];
}

@end

@implementation ATBookmarks (Modifying)

- (void)apply:(NSArray *)aWebIcons to:(NSArray *)aBookmarks
{
	unsigned i;
	
	//[self bookmarksWillChange];
	
	for (i = 0; i < [aBookmarks count]; i++)
	{
		ATBookmark *aBookmark = [aBookmarks objectAtIndex:i];
		id aWebIconOrNull = [aWebIcons objectAtIndex:i];
		
		if (![aWebIconOrNull isEqualTo:[NSNull null]])
		{
			/*[aBookmark setIconData:[aWebIconOrNull TIFFRepresentation]];
			[aBookmark setIconDataType:@"tiff"];*/
			NSDictionary *aNewValues = [NSDictionary dictionaryWithObjectsAndKeys:[aWebIconOrNull TIFFRepresentation],@"iconData", @"tiff",@"iconDataType", nil];
			
			[self change:aBookmark with:aNewValues];
		}
	}

	//[self bookmarksDidChange];
}

- (void)change:(id)anItem with:(NSDictionary *)aValue
{
	if ([anItem hasChagned:aValue])
	{	
		[self bookmarksWillChange];
		[self bookmarksWillEdit:anItem];
	
		[anItem acceptEdited:aValue on:[NSValue valueWithNonretainedObject:self]];
	
		[self bookmarksDidEdit:anItem];
		[self bookmarksDidChange];
	}
}

/*- (void)add:(id)anItem
{
	[self add:anItem to:[self root] contextInfo:nil];
}

- (void)add:(id)anItem to:(ATBinder *)aFolder contextInfo:(id)anInfo
{
	[self insert:anItem to:[aFolder count] of:aFolder contextInfo:anInfo];
}

- (void)addItems:(NSArray  *)anItems to:(ATBinder *)aFolder contextInfo:(id)anInfo
{
	[self insertItems:anItems to:[aFolder count] of:aFolder contextInfo:anInfo];
}

- (void)insert:(id)anItem to:(NSUInteger)anIndex of:(ATBinder *)aFolder contextInfo:(id)anInfo
{
	[self insertItems:[NSArray arrayWithObject:anItem] to:anIndex of:aFolder contextInfo:anInfo];
}*/

/*- (void)insertItems:(NSArray  *)anItems of:(ATBinder *)aSourceBinder to:(NSUInteger)anIndex of:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo
{
	NSEnumerator *anEnumerator = [anItems objectEnumerator];
	id anItem = nil;
	
	[self bookmarksWillChange:anInfo];
	[self bookmarksWillInsert:anItems from:aSourceBinder to:aDestinationBinder contextInfo:anInfo];
		
	while (anItem = [anEnumerator nextObject])
	{
		[aDestinationBinder insert:anItem at:anIndex on:self];
		//[[self items] addObject:anItem];
		[self registerItems:anItems];
		anIndex++;
	}
	
	[self bookmarksDidInsert:anItems from:aSourceBinder to:aDestinationBinder contextInfo:anInfo];
	[self bookmarksDidChange:anInfo];
}*/

- (void)add:(id)anItem
{
    [self insertItems:@[anItem] to:[[self root] count] of:[self root] contextInfo:nil];
}

- (void)insertItems:(NSArray *)anItems to:(NSUInteger)anIndex of:(ATBinder *)aBinder contextInfo:(id)anInfo
{
    ATBookmarksInsertOperation *anInsertOperation = [ATBookmarksInsertOperation insertOperationWithItems:anItems index:anIndex binder:aBinder contextInfo:anInfo];
    
    [self runInsertOperation:anInsertOperation];
}

- (void)registerItems:(NSArray *)anItems
{
	//NSEnumerator *anEnumerator = [anItems objectEnumerator];
	ATBookmarksEnumerator *anEnumerator = [ATBookmarksEnumerator enumeratorWithBinders:anItems];

	ATItem *anItem = nil;
	
	while (anItem = [anEnumerator nextObject])
	{
		if (![[self itemLibrary] objectForKey:[anItem numberWithItemID]])
		{
			[anItem itemIDFrom:self];
			[[self itemLibrary] setObject:anItem forKey:[anItem numberWithItemID]];
            if (![anItem addDate]) [anItem setAddDate:[NSDate date]];
            //[[[self bell] sandbox] markChangedObject:[self itemsDictionary]];
		}
	}
}

/*-  (void)move:(id)anItem to:(NSUInteger)anIndex of:(ATBinder *)aFolder contextInfo:(id)anInfo
{
	[self moveItems:[NSArray arrayWithObject:anItem] to:anIndex of:aFolder contextInfo:anInfo];
}*/

/*- (void)moveItems:(NSArray  *)anItems of:(ATBinder *)aSourceBinder to:(NSUInteger)anIndex of:(ATBinder *)aFolder contextInfo:(id)anInfo
{
	unsigned anIndexToInsert = anIndex;
	NSEnumerator *anEnumerator = [anItems objectEnumerator];
	id anItem = nil;
	
	[self bookmarksWillChange:anInfo];
	[self bookmarksWillMove:anItems from:aSourceBinder to:aFolder contextInfo:anInfo];
	
	while (anItem = [anEnumerator nextObject])
	{
		anIndexToInsert = [anItem moveTo:anIndexToInsert of:aFolder from:aSourceBinder on:self];
		anIndexToInsert++;
	}
	
	[self bookmarksDidMove:anItems from:aSourceBinder to:aFolder contextInfo:anInfo];
	[self bookmarksDidChange:anInfo];
}*/

/*- (void)moveOrInsertItems:(NSArray *)anItems of:(ATBinder *)aSourceBinder to:(NSUInteger)anIndex of:(ATBinder *)aDestinationBinder contextInfo:(id)aContextInfo
{
	NSEnumerator  *anEnumerator = [anItems objectEnumerator];
	ATItem *anItem = nil;
	unsigned anIndexToInsert = anIndex;
	ATBookmarkItemsMoveOperation *aMoveOrInsertOperation = [ATBookmarkItemsMoveOperation operation];
	ATMoveOperationItem *aMoveOrInsertItem = nil;
	NSMutableArray *aMovingItems = [NSMutableArray array];
	NSMutableArray *anInsertingItems = [NSMutableArray array];
	
	while (anItem = [anEnumerator nextObject])
		[aMoveOrInsertOperation add:anItem movable:[anItem canMoveFrom:aSourceBinder to:aDestinationBinder]];
	
	anEnumerator = [aMoveOrInsertOperation objectEnumerator];
	
	[self bookmarksWillChange:aContextInfo];
	[self bookmarksWillMoveOrInsert:anItems from:aSourceBinder to:aDestinationBinder movingItems:aMovingItems insertingItems:anInsertingItems contextInfo:aContextInfo];
	
	while (aMoveOrInsertItem = [anEnumerator nextObject])
	{
		if ([aMoveOrInsertItem canMove])
		{
			anIndexToInsert = [[aMoveOrInsertItem item] moveTo:anIndexToInsert of:aDestinationBinder from:aSourceBinder on:self];
			anIndexToInsert++;
			[aMovingItems addObject:[aMoveOrInsertItem item]];
		}
		else
		{
			[aDestinationBinder insert:[aMoveOrInsertItem item] at:anIndexToInsert on:self];
			anIndexToInsert++;
			[anInsertingItems addObject:[aMoveOrInsertItem item]];
		}
	}
	
	[self bookmarksDidMoveOrInsert:anItems from:aSourceBinder to:aDestinationBinder movingItems:aMovingItems insertingItems:anInsertingItems contextInfo:aContextInfo];
	[self bookmarksDidChange:aContextInfo];
}*/

- (void)moveItemsAtIndexes:(NSIndexSet *)aSourceIndexes of:(ATBinder *)aSourceBinder toIndex:(NSUInteger)aDestinationIndex of:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo
{
    ATBookmarksMoveOperation *aMoveOperation = [ATBookmarksMoveOperation moveOperationWithSourceIndexes:aSourceIndexes sourceBinder:aSourceBinder destinationIndex:aDestinationIndex destinationBinder:aDestinationBinder contextInfo:anInfo];
    [self runMoveOperation:aMoveOperation];
}
                                                
/*- (void)removeItems:(NSArray  *)anItems from:(ATBinder *)aSourceBinder
{
	[self removeItems:anItems from:aSourceBinder contextInfo:nil];
}

- (void)removeItems:(NSArray *)anItems from:(ATBinder *)aSourceBinder contextInfo:(id)anInfo
{
	NSEnumerator *anEnumerator = [anItems objectEnumerator];
	ATItem *anItem = nil;
		
	[self bookmarksWillChange:anInfo];
	[self bookmarksWillRemove:anItems from:aSourceBinder to:nil contextInfo:anInfo];
	
	while (anItem = [anEnumerator nextObject])
	{
		[aSourceBinder remove:anItem on:self];
	}
	
	[self bookmarksDidRemove:anItems from:aSourceBinder to:nil contextInfo:anInfo];
	[self bookmarksDidChange:anInfo];
}*/

- (void)removeItemsAtIndexes:(NSIndexSet *)anIndexes from:(ATBinder *)aBinder contextInfo:(id)anInfo
{
    ATBookmarksRemoveOperation *aRemoveOperation = [ATBookmarksRemoveOperation removeOperationWithIndexes:anIndexes binder:aBinder contextInfo:anInfo];
    [self runRemoveOperation:aRemoveOperation];
}

@end

@implementation ATBookmarks (Testing)

- (BOOL)canMoveItemsAtIndexes:(NSIndexSet *)anIndexSet of:(ATBinder *)aSourceBinder to:(NSUInteger)anIndex of:(ATBinder *)aDestinationBinder
{
    if ([aSourceBinder isEqual:aDestinationBinder])
        return YES;
    else
    {
        NSEnumerator *anEnumerator = [[aSourceBinder atIndexes:anIndexSet] objectEnumerator];
        ATItem *anItem = nil;
        
        while (anItem = [anEnumerator nextObject])
            if ([anItem isFolder] && [aDestinationBinder isReachableFrom:(ATBinder *)anItem])
                return NO;
        
        return YES;
    }
}

- (BOOL)canPaste
{
	return [[NSPasteboard generalPasteboard] availableTypeFromArray:[self pasteBoardTypes]] ? YES : NO;
}

@end

@implementation ATBookmarks (CreatingNewItem)

- (ATBinder *)untitledFolder
{
	ATBinder *aFolder = [[ATBinder new] autorelease];
	[aFolder setName:[NSString stringWithFormat:NSLocalizedString(@"UntitledFolder%u", nil), ++untitledFolderIndex]];
	
	return aFolder;
}

- (ATBookmark *)untitledBookmark
{
	ATBookmark *aBookmark = [[ATBookmark new] autorelease];
	[aBookmark setName:[NSString stringWithFormat:NSLocalizedString(@"UntitledBookmark%u", nil), ++untitledBookmarkIndex]];
	
	return aBookmark;
}

@end

@implementation ATBookmarks (Converting)

- (NSData *)serializedPropertyListRepresentation
{
	NSString *anErrorString = nil;
	
	return [NSPropertyListSerialization dataFromPropertyList:[self propertyListRepresentation] format:NSPropertyListXMLFormat_v1_0 errorDescription:&anErrorString];
}


- (NSMutableDictionary *)propertyListRepresentation
{
	return [ATBookmarksArchiver archive:self];
	//return [NSMutableDictionary dictionaryWithObjectsAndKeys:[ATBookmarksItemsArchiver archiveItem:[self root]], @"root", [idPool propertyListRepresentation], @"idPool", [NSNumber numberWithDouble:0.2], @"version", nil];

	//return [NSMutableDictionary dictionaryWithObjectsAndKeys:[[self root] propertyListRepresentation], @"root", [idPool propertyListRepresentation], @"idPool", [NSNumber numberWithDouble:0.2], @"version", nil];
}

- (NSArray *)itemsFromBookmarkDictionaryList:(NSArray *)aBookmarkDictionaryList
{
	NSEnumerator *aListEnumerator = [aBookmarkDictionaryList objectEnumerator];
	NSDictionary *aBookmarkDictionary = nil;
	NSMutableArray *anItems = [NSMutableArray array];
	
	while (aBookmarkDictionary = [aListEnumerator nextObject])
	{
		NSString *aBookmarkType = [aBookmarkDictionary objectForKey:@"WebBookmarkType"];
		
		if ([aBookmarkType isEqualToString:@"WebBookmarkTypeLeaf"])
		{
			ATBookmark *aBookmark = [ATBookmark bookmarkWithName:aBookmarkDictionary[@"URIDictionary"][@"title"] urlString:aBookmarkDictionary[@"URLString"]];
			
			[anItems addObject:aBookmark];
		}
		else if ([aBookmarkType isEqualToString:@"WebBookmarkTypeList"])
		{
			ATBinder *aFolder = [ATBinder new];
			
			[aFolder setName:[aBookmarkDictionary objectForKey:@"Title"]];
			[aFolder setChildren:[[[self itemsFromBookmarkDictionaryList:[aBookmarkDictionary objectForKey:@"Children"]] mutableCopy] autorelease]];
			[anItems addObject:aFolder];
		}
	}
	
	return anItems;
}

@end

@implementation ATBookmarks (Editing)

- (BOOL)copy:(NSIndexSet *)aSelectionIndexes of:(ATBinder *)aSourceBinder;
{
	return [self copy:aSelectionIndexes of:aSourceBinder to:[NSPasteboard generalPasteboard]];
}

- (BOOL)copy:(NSIndexSet *)aSelectionIndexes of:(ATBinder *)aSourceBinder to:(NSPasteboard *)aPasteboard
{
    NSArray *anItems = [aSourceBinder atIndexes:aSelectionIndexes];
	NSMutableArray *anIDArray = [NSMutableArray array];
	NSDictionary *anArchive = [ATBookmarksItemsArchiver archiveItems:anItems source:aSourceBinder];

	[self setSourceBinderID:[aSourceBinder numberWithItemID]];
	[anItems makeObjectsPerformSelector:@selector(writeItemIDOn:) withObject:anIDArray];
	
    hasCutItems = NO;
    
	if ([[aPasteboard name] isEqual:NSDragPboard])
		changeCountOfDraggingPasteBoard = [aPasteboard declareTypes:[self pasteBoardTypes] owner:nil];
	else
		changeCountOfGeneralPasteboard = [aPasteboard declareTypes:[self pasteBoardTypes] owner:nil];
	
	return [aPasteboard setPropertyList:anIDArray forType:ATBookmarksItemIDsPasteBoardType] && [aPasteboard setPropertyList:anArchive forType:ATBookmarksItemsPropertyListRepresentaionPasteBoardType];
}

- (BOOL)cut:(NSIndexSet *)aSelectionIndexes of:(ATBinder *)aSourceBinder
{
	if ([self copy:aSelectionIndexes of:aSourceBinder])
	{
		//[self setItemsToPaste:anItems];
        hasCutItems = YES;
		//[self removeItems:anItems from:aSourceBinder];
        [self removeItemsAtIndexes:aSelectionIndexes from:aSourceBinder contextInfo:nil];
		return YES;
	}
	else
		return NO;
}

- (void)pasteTo:(ATBinder *)aFolder at:(NSUInteger)anIndex contextInfo:(id)anInfo
{
	[self pasteTo:aFolder at:anIndex from:[NSPasteboard generalPasteboard] contextInfo:anInfo];
}

- (void)pasteTo:(ATBinder *)aFolder at:(NSUInteger)anIndex from:(NSPasteboard *)aPasteboard contextInfo:(id)anInfo
{	
	if ([aPasteboard changeCount] == changeCountOfGeneralPasteboard  && hasCutItems)
		//[self insertItems:[self itemsToPaste] of:nil to:anIndex of:aFolder contextInfo:anInfo];        
        [self insertItems:[self itemsFor:[aPasteboard propertyListForType:ATBookmarksItemIDsPasteBoardType]] to:anIndex of:aFolder contextInfo:anInfo];
	else
		//[self insertItems:[self itemsFrom:aPasteboard] of:nil to:anIndex of:aFolder contextInfo:anInfo];
        [self insertItems:[self itemsFrom:aPasteboard] to:anIndex of:aFolder contextInfo:anInfo];
    
    hasCutItems = NO;
}

- (NSArray *)itemsFrom:(NSPasteboard *)aPasteboard
{
	NSString *anAvailableType = [aPasteboard availableTypeFromArray:[NSArray arrayWithObjects:ATBookmarksItemsPropertyListRepresentaionPasteBoardType, @"BookmarkDictionaryListPboardType", @"WebURLsWithTitlesPboardType", @"public.url", nil]];
	
	if ([anAvailableType isEqualToString:ATBookmarksItemsPropertyListRepresentaionPasteBoardType])
	{
		/*NSArray *aPlists = [aPasteboard propertyListForType:ATBookmarksItemsPropertyListRepresentaionPasteBoardType];
		NSEnumerator *anEnumerator = [aPlists objectEnumerator];
		id aPlist = nil;
		NSMutableArray *anItems = [NSMutableArray array];
		
		while (aPlist = [anEnumerator nextObject])
		{
			[anItems addObject:[[[NSClassFromString([aPlist objectForKey:@"class"]) alloc] initWith:aPlist] autorelease]];
		}
		
		return anItems;*/
		NSDictionary *aPlist = [aPasteboard propertyListForType:ATBookmarksItemsPropertyListRepresentaionPasteBoardType];
		NSArray *aToplevelItems = [ATBookmarksItemsUnarchiver unarchive:aPlist][@"toplevelItems"];
		
		//[aToplevelItems makeObjectsPerformSelector:@selector(itemIDFrom:) withObject:self];
		[aToplevelItems makeObjectsPerformSelector:@selector(invalidateItemID)];
        ATBookmarksEnumerator *enumerator = [ATBookmarksEnumerator enumeratorWithBinders:aToplevelItems];
        ATItem *anItem = nil;
        
        while (anItem = [enumerator nextObject])
            [anItem invalidateItemID];		
        
		return aToplevelItems;
	}
	else if ([anAvailableType isEqualToString:@"BookmarkDictionaryListPboardType"])
	{
		NSArray *aBookmarkDictionaryList = [aPasteboard propertyListForType:@"BookmarkDictionaryListPboardType"];
		
		return [self itemsFromBookmarkDictionaryList:aBookmarkDictionaryList];
	}
	else if ([anAvailableType isEqualToString:@"WebURLsWithTitlesPboardType"])
	{
		NSArray *aURLsWithTitles = [aPasteboard propertyListForType:@"WebURLsWithTitlesPboardType"];
		NSMutableArray *anItems = [NSMutableArray array];
		NSEnumerator *aURLsEnumerator = [[aURLsWithTitles objectAtIndex:0] objectEnumerator];
		NSEnumerator *aTitlesEnumerator = [[aURLsWithTitles objectAtIndex:1] objectEnumerator];
		NSString *aURLString = nil;
		
		while (aURLString = [aURLsEnumerator nextObject])
		{
			[anItems addObject:[ATBookmark bookmarkWithName:[aTitlesEnumerator nextObject] urlString:aURLString]];
		}
		
		return anItems;
	}
    else if ([anAvailableType isEqualToString:@"public.url"])
    {
        NSString *aUrlString = [aPasteboard stringForType:@"public.url"];
        NSString *aUrlName = [aPasteboard stringForType:@"public.url-name"];
        ATBookmark *aBookmark = [ATBookmark bookmarkWithName:aUrlName urlString:aUrlString];
        
        return @[aBookmark];
    }
	else
		return nil;
}

- (void)resetAllItemIDs
{
    ATItem *anItem = nil;
    ATBookmarksEnumerator *enumerator = [ATBookmarksEnumerator enumeratorWithBinder:[self root]];
    
    [self setIDPool:[ATIDPool idPool]];
    [self setItemLibrary:[NULibrary library]];
    [[[self bell] sandbox] markChangedObject:self];
    
    anItem = [self root];
    
    do
    {
        [self newItemIDTo:anItem];
        [[self itemLibrary] setObject:anItem forKey:[anItem numberWithItemID]];
    }
    while (anItem = [enumerator nextObject]);
}

@end

@implementation ATBookmarks (DraggingAndDropping)

- (BOOL)writeDraggingItemsWithIndexes:(NSIndexSet *)anIndexes of:(ATBinder *)aSourceBinder to:(NSPasteboard *)aPasteboard
{
    [self setDraggingSourceBinder:aSourceBinder];
    [self setDraggingItemIndexes:anIndexes];
    return [self copy:anIndexes of:aSourceBinder to:aPasteboard];
}

- (NSArray *)pasteBoardTypes
{
	return [NSArray arrayWithObjects:ATBookmarksItemIDsPasteBoardType, ATBookmarksItemsPropertyListRepresentaionPasteBoardType, @"BookmarkDictionaryListPboardType", @"WebURLsWithTitlesPboardType", @"public.url", nil];
}

- (NSDragOperation)validateDrop:(id <NSDraggingInfo>)anInfo on:(ATItem *)anItem
{
	if ([anItem isFolder])
		return [self validateDrop:anInfo  to:anItem at:[(ATBinder *)anItem count]];
	else
		return NSDragOperationNone;
}

- (NSDragOperation)validateDrop:(id <NSDraggingInfo>)anInfo to:(ATItem *)anItem at:(NSUInteger)anIndex
{
	if (([anInfo draggingSourceOperationMask] & NSDragOperationNone) || ![[anInfo draggingPasteboard] availableTypeFromArray:[self pasteBoardTypes]])
		return NSDragOperationNone;

	if (changeCountOfDraggingPasteBoard == [[anInfo draggingPasteboard] changeCount])
		return [self validateLocalDrop:anInfo to:(ATBinder *)anItem at:anIndex];
	else
		return NSDragOperationCopy;
}

- (NSDragOperation)validateLocalDrop:(id <NSDraggingInfo>)anInfo to:(ATBinder *)aBinder at:(NSUInteger)anIndex
{
	NSDragOperation aDragOperationToPerform = NSDragOperationNone;
	NSDragOperation anAllowedDragOperation = [self draggingOperationForDraggingInfo:anInfo];
	
	if (anAllowedDragOperation & NSDragOperationCopy)
	{
		aDragOperationToPerform = NSDragOperationCopy;
		//NSLog(@"#validateLocalDrop: NSDragOperationCopy");
	}
	else if (anAllowedDragOperation & NSDragOperationLink)
	{
		aDragOperationToPerform = NSDragOperationLink;
		//NSLog(@"#validateLocalDrop: NSDragOperationLink");
	}
	else if (anAllowedDragOperation & NSDragOperationGeneric)
	{
		//Move, Link or None
        if ([self canMoveItemsAtIndexes:[self draggingItemIndexes] of:[self draggingSourceBinder] to:anIndex of:aBinder])
            aDragOperationToPerform = NSDragOperationMove;
        else
            aDragOperationToPerform = NSDragOperationNone;
		//NSLog(@"#validateLocalDrop: NSDragOperationGeneric");
	}
	
//	NSLog(@"to perform:");
//	[self logDragOperationMask:aDragOperationToPerform];
	
	return aDragOperationToPerform;
}

#ifdef DEBUG
- (void)logDragOperationMask:(NSDragOperation)aDragOperation
{
	if (aDragOperation & NSDragOperationCopy)
		NSLog(@"NSDragOperationCopy");
	if (aDragOperation & NSDragOperationLink)
		NSLog(@"NSDragOperationLink");
	if (aDragOperation & NSDragOperationGeneric)
		NSLog(@"NSDragOperationGeneric");
	if (aDragOperation & NSDragOperationPrivate)
		NSLog(@"NSDragOperationPrivate");
	if (aDragOperation & NSDragOperationMove)
		NSLog(@"NSDragOperationMove");
	if (aDragOperation & NSDragOperationDelete)
		NSLog(@"NSDragOperationDelete");
	if (aDragOperation == NSDragOperationEvery)
		NSLog(@"NSDragOperationEvery");
	if (aDragOperation == NSDragOperationNone)
		NSLog(@"NSDragOperationNone");
}
#endif

- (NSDragOperation)draggingOperationForDraggingInfo:(id <NSDraggingInfo>)aDraggingInfo
{
	NSDragOperation aDragOperation = NSDragOperationNone;
	NSEvent *theEvent = [[aDraggingInfo draggingDestinationWindow] currentEvent];

	if ([theEvent modifierFlags] & NSAlternateKeyMask)
		aDragOperation = NSDragOperationCopy;
	else if ([theEvent modifierFlags] & NSControlKeyMask)
		aDragOperation = NSDragOperationLink;
	else
		aDragOperation = NSDragOperationGeneric;

	return aDragOperation;
}

- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo on:(ATBinder *)anItem contextInfo:(id)aContextInfo
{
	return [self acceptDrop:anInfo to:anItem at:[anItem count] contextInfo:aContextInfo];
}

- (BOOL)acceptDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo
{
	if ([[[anInfo draggingPasteboard] availableTypeFromArray:[self pasteBoardTypes]] isEqualToString:ATBookmarksItemIDsPasteBoardType])
		return [self acceptLocalDrop:anInfo to:anItem at:anIndex contextInfo:aContextInfo];
	else
		return [self acceptNonLocalDrop:anInfo to:anItem at:anIndex contextInfo:aContextInfo];
}

- (BOOL)acceptLocalDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo
{
	NSDragOperation aMask = [self validateDrop:anInfo to:anItem at:anIndex];
//	NSArray *anItems = [self itemsFor:[[anInfo draggingPasteboard] propertyListForType:ATBookmarksItemIDsPasteBoardType]];
//	ATBinder *aSourceBinder = [self itemForIDNumber:sourceBinderID];
	
	//[self logDraggingSourceOperationMask:aMask];
	
	if (aMask & NSDragOperationMove)
        [self moveItemsAtIndexes:[self draggingItemIndexes] of:[self draggingSourceBinder] toIndex:anIndex of:anItem contextInfo:aContextInfo];
	else if (aMask & NSDragOperationLink)
        [self insertItems:[[self draggingSourceBinder] atIndexes:[self draggingItemIndexes]] to:anIndex of:anItem contextInfo:aContextInfo];
	else if (aMask & NSDragOperationCopy)
		[self pasteTo:anItem at:anIndex from:[anInfo draggingPasteboard] contextInfo:aContextInfo];
	else
		return NO;

	return YES;
}

- (BOOL)acceptNonLocalDrop:(id <NSDraggingInfo>)anInfo to:(id)anItem at:(NSUInteger)anIndex contextInfo:(id)aContextInfo
{
	[self pasteTo:anItem at:anIndex from:[anInfo draggingPasteboard] contextInfo:aContextInfo];
	
	return YES;
}

@end

@implementation ATBookmarks (Kidnapping)

- (void)kidnapWithRoots:(NSArray *)aRoots
{
    @autoreleasepool
    {
        NSMutableSet *aVisitedItems = [NSMutableSet setWithObject:[self root]];
        NSMutableArray *anItemsToKidnap = [NSMutableArray array];
        ATBookmarksEnumerator *anEnumerator = nil;
        ATItem *anItem = nil;
        
        @autoreleasepool
        {
            anEnumerator = [ATBookmarksEnumerator enumeratorWithBinders:aRoots];
            while (anItem = [anEnumerator nextObject])
                [aVisitedItems addObject:anItem];
        }

 
        @autoreleasepool
        {
            anEnumerator = [ATBookmarksEnumerator enumeratorWithBinder:[self root]];
            while (anItem = [anEnumerator nextObject])
                [aVisitedItems addObject:anItem];
        }
        
        [[self itemLibrary] enumerateKeysAndObjectsUsingBlock:^(NSNumber *aKey, ATItem *anItem, BOOL *aStop) {
            if (![aVisitedItems containsObject:anItem])
                [anItemsToKidnap addObject:anItem];
        }];
        
        [self bookmarksWillChange];
        
        [anItemsToKidnap enumerateObjectsUsingBlock:^(ATItem *anItem, NSUInteger idx, BOOL *stop) {
            [anItem removeToKidnap];
            [[self itemLibrary] removeObjectForKey:[anItem numberWithItemID]];
        }];
        
        [self bookmarksDidChange];
    }
}

@end

@implementation ATBookmarks (Private)

- (void)setRoot:(ATBinder *)aRoot
{
    NUSetIvar(&root, aRoot);
}

- (void)setIDPool:(ATIDPool *)anIDPool
{
    NUSetIvar(&idPool, anIDPool);
}

- (void)setUndoManager:(NSUndoManager  *)aManager
{
	[undoManager autorelease];
	undoManager = [aManager retain];
}

- (void)newItemIDTo:(id)anItem
{
	[anItem setItemID:[idPool newID]];
    [[[self bell ] sandbox] markChangedObject:idPool];
}

- (void)restoreItemIDOf:(id)anItem
{
	[idPool newIDWith:[anItem itemID]];
    [[[self bell ] sandbox] markChangedObject:idPool];
}

- (void)releseItemIDOf:(id)anItem
{
	[idPool releaseID:[anItem itemID]];
    [[[self bell ] sandbox] markChangedObject:idPool];
}

//- (void)setItems:(NSMutableArray *)anItems
//{
//    NUSetIvar(&items, anItems);
//}

- (void)setItemLibrary:(NULibrary *)aLibrary
{
    NUSetIvar(&itemLibrary, aLibrary);
}

/*- (void)bookmarksWillInsert:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo
{
	[[[self undoManager] prepareWithInvocationTarget:self] bookmarksDidRemove:anItems from:aDestination to:aSource contextInfo:anInfo];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillInsertNotification object:self userInfo:[self userInfoWithItems:anItems source:aSource destination:aDestination contextInfo:anInfo]];
}

- (void)bookmarksDidInsert:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo
{
	[[[self undoManager] prepareWithInvocationTarget:self] bookmarksWillRemove:anItems from:aDestination to:aSource contextInfo:anInfo];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidInsertNotification object:self userInfo:[self userInfoWithItems:anItems source:aSource destination:aDestination contextInfo:anInfo]];
}*/

- (void)runInsertOperation:(ATBookmarksInsertOperation *)anInsertOperation
{
    [self bookmarksWillChange];

    NSDictionary *aUserInfo = [NSDictionary dictionaryWithObject:anInsertOperation forKey:@"operation"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillInsertNotification object:self userInfo:aUserInfo];
    
    [self registerItems:[anInsertOperation items]];
    [[anInsertOperation binder] insert:[anInsertOperation items] atIndexes:[anInsertOperation indexes]];
    ATBookmarksRemoveOperation *aRemoveOperation = (ATBookmarksRemoveOperation *)[anInsertOperation undoOperation];
    [[[self undoManager] prepareWithInvocationTarget:self] runRemoveOperation:aRemoveOperation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidInsertNotification object:self userInfo:aUserInfo];
    
    [self bookmarksDidChange];
}

- (void)runRemoveOperation:(ATBookmarksRemoveOperation *)aRemoveOperation
{
    [self bookmarksWillChange];
    
    NSDictionary *aUserInfo = [NSDictionary dictionaryWithObject:aRemoveOperation forKey:@"operation"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillRemovetNotification object:self userInfo:aUserInfo];
    
    ATBookmarksInsertOperation *anInsertOperation = (ATBookmarksInsertOperation *)[aRemoveOperation undoOperation];
    [[aRemoveOperation binder] removeAtIndexes:[aRemoveOperation indexes]];
    [[[self undoManager] prepareWithInvocationTarget:self] runInsertOperation:anInsertOperation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidRemoveNotification object:self userInfo:aUserInfo];
    
    [self bookmarksDidChange];
}

- (void)runMoveOperation:(ATBookmarksMoveOperation *)aMoveOperation
{
    [self bookmarksWillChange];
    
    NSDictionary *aUserInfo = [NSDictionary dictionaryWithObject:aMoveOperation forKey:@"operation"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillMovetNotification object:self userInfo:aUserInfo];
    
    [[aMoveOperation sourceBinder] removeAtIndexes:[aMoveOperation sourceIndexes]];
    [[aMoveOperation destinationBinder] insert:[aMoveOperation items] atIndexes:[aMoveOperation destinationIndexes]];
    ATBookmarksMoveOperation *anUndoMoveOperation = (ATBookmarksMoveOperation *)[aMoveOperation undoOperation];
    [[[self undoManager] prepareWithInvocationTarget:self] runMoveOperation:anUndoMoveOperation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidMoveNotification object:self userInfo:aUserInfo];
    
    [self bookmarksDidChange];
}

/*- (void)bookmarksWillMove:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo
{
	[[[self undoManager] prepareWithInvocationTarget:self] bookmarksDidMove:anItems from:aDestination to:aSource contextInfo:anInfo];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillMovetNotification object:self userInfo:[self userInfoWithItems:anItems source:aSource destination:aDestination contextInfo:anInfo]];
}

- (void)bookmarksDidMove:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo
{
	[[[self undoManager] prepareWithInvocationTarget:self] bookmarksWillMove:anItems from:aDestination to:aSource contextInfo:anInfo];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidMoveNotification object:self userInfo:[self userInfoWithItems:anItems source:aSource destination:aDestination contextInfo:anInfo]];
}

- (void)bookmarksWillMoveOrInsert:(NSArray *)anItems from:(ATBinder *)aSourceBinder to:(ATBinder *)aDestinationBinder movingItems:(NSArray *)aMovingItems insertingItems:(NSArray *)anInsertingItems contextInfo:(id)aContextInfo
{
	[[[self undoManager] prepareWithInvocationTarget:self] bookmarksDidMoveOrInsert:anItems from:aDestinationBinder to:aSourceBinder movingItems:aMovingItems insertingItems:anInsertingItems contextInfo:aContextInfo];

	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillMoveOrInsertNotification object:self userInfo:[self moveOrInsertUserInfoWithItems:anItems source:aSourceBinder destination:aDestinationBinder movingItems:aMovingItems insertingItems:anInsertingItems contextInfo:aContextInfo]];*/
	
	/*[self bookmarksWillMove:aMovingItems from:aSourceBinder to:aDestinationBinder contextInfo:aContextInfo];
	[self bookmarksWillInsert:anInsertingItems from:aSourceBinder to:aDestinationBinder contextInfo:aContextInfo];
}

- (void)bookmarksDidMoveOrInsert:(NSArray *)anItems from:(ATBinder *)aSourceBinder to:(ATBinder *)aDestinationBinder movingItems:(NSArray *)aMovingItems insertingItems:(NSArray *)anInsertingItems contextInfo:(id)aContextInfo
{*/
	/*[[[self undoManager] prepareWithInvocationTarget:self] bookmarksWillMoveOrInsert:anItems from:aDestinationBinder to:aSourceBinder movingItems:aMovingItems insertingItems:anInsertingItems contextInfo:aContextInfo];

	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidMoveOrInsertNotification object:self userInfo:[self moveOrInsertUserInfoWithItems:anItems source:aSourceBinder destination:aDestinationBinder movingItems:aMovingItems insertingItems:anInsertingItems contextInfo:aContextInfo]];*/
	
	/*[self bookmarksDidMove:aMovingItems from:aSourceBinder to:aDestinationBinder contextInfo:aContextInfo];
	[self bookmarksDidInsert:anInsertingItems from:aSourceBinder to:aDestinationBinder contextInfo:aContextInfo];
}

- (void)bookmarksWillRemove:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo
{
	[[[self undoManager] prepareWithInvocationTarget:self] bookmarksDidInsert:anItems from:aDestination to:aSource contextInfo:anInfo];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillRemovetNotification object:self userInfo:[self userInfoWithItems:anItems source:aSource destination:nil contextInfo:anInfo]];
}

- (void)bookmarksDidRemove:(NSArray *)anItems from:(ATBinder *)aSource to:(ATBinder *)aDestination contextInfo:(id)anInfo
{
	[[[self undoManager] prepareWithInvocationTarget:self] bookmarksWillInsert:anItems from:aDestination to:aSource contextInfo:anInfo];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidRemoveNotification object:self userInfo:[self userInfoWithItems:anItems source:aSource destination:nil contextInfo:anInfo]];
}*/

- (NSDictionary *)userInfoWithItems:(NSArray *)anItems contextInfo:(id)anInfo
{
	return [self userInfoWithItems:anItems source:nil destination:nil contextInfo:anInfo];
}

- (NSDictionary *)userInfoWithItems:(NSArray *)anItems source:(ATBinder *)aSource destination:(ATBinder *)aDestination contextInfo:(id)anInfo
{
	NSMutableDictionary *aUserInfo = [NSMutableDictionary dictionaryWithObject:anItems forKey:@"items"];
	
	if (aSource) [aUserInfo setObject:aSource forKey:@"source"];
	if (aDestination) [aUserInfo setObject:aDestination forKey:@"destination"];
	if (anInfo) [aUserInfo setObject:anInfo forKey:@"contextInfo"];
	
	return aUserInfo;
}

/*- (NSDictionary *)moveOrInsertUserInfoWithItems:(NSArray *)anItems source:(ATBinder *)aSourceBinder destination:(ATBinder *)aDestinationBinder movingItems:(NSArray *)aMovingItems insertingItems:(NSArray *)anInsertingItems contextInfo:(id)aContextInfo;
{
	NSMutableDictionary *aUserInfo = [self userInfoWithItems:anItems source:aSourceBinder destination:aDestinationBinder contextInfo:aContextInfo];
	
	[aUserInfo setObject:aMovingItems forKey:@"movingItems"];
	[aUserInfo setObject:anInsertingItems forKey:@"insertingItems"];
	
	return aUserInfo;
}*/

- (void)bookmarksWillEdit:(id)anItem
{
	[[[self undoManager] prepareWithInvocationTarget:self] bookmarksDidEdit:anItem];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillEditItemNotification object:self userInfo:[NSDictionary dictionaryWithObject:anItem forKey:@"item"]];
}

- (void)bookmarksDidEdit:(id)anItem
{
	[[[self undoManager] prepareWithInvocationTarget:self] bookmarksWillEdit:anItem];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidEditItemNotification object:self userInfo:[NSDictionary dictionaryWithObject:anItem forKey:@"item"]];
}

- (void)bookmarksWillChange
{
	[self bookmarksWillChange:nil];
}

- (void)bookmarksWillChange:(id)anInfo
{
	//[[[self undoManager] prepareWithInvocationTarget:self] bookmarksDidChange:anInfo];
	
	if (anInfo)
		[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillChangeNotification object:self userInfo:[NSDictionary dictionaryWithObject:anInfo forKey:@"contextInfo"]];
	else
		[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksWillChangeNotification object:self];
}

- (void)bookmarksDidChange
{
	[self bookmarksDidChange:nil];
}

- (void)bookmarksDidChange:(id)anInfo
{
	//[[[self undoManager] prepareWithInvocationTarget:self] bookmarksWillChange:anInfo];
	
	if (anInfo)
		[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidChangeNotification object:self userInfo:[NSDictionary dictionaryWithObject:anInfo forKey:@"contextInfo"]];
	else
		[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidChangeNotification object:self];
}

#ifdef DEBUG

- (void)logDraggingSourceOperationMask:(NSDragOperation)aOperation
{
	NSLog(@"ATBookmarks log:");
	
	if (aOperation & NSDragOperationCopy)
		NSLog(@"NSDragOperationCopy");
	if (aOperation & NSDragOperationLink)
		NSLog(@"NSDragOperationLink");
	if (aOperation & NSDragOperationGeneric)
		NSLog(@"NSDragOperationGeneric");
	if (aOperation & NSDragOperationPrivate)
		NSLog(@"NSDragOperationPrivate");
	if (aOperation & NSDragOperationMove)
		NSLog(@"NSDragOperationMove");
	if (aOperation & NSDragOperationDelete)
		NSLog(@"NSDragOperationDelete");
	if (aOperation & NSDragOperationEvery)
		NSLog(@"NSDragOperationEvery");
	if (aOperation & NSDragOperationNone)
		NSLog(@"NSDragOperationNone");
}

#endif

- (void)setSourceBinderID:(NSNumber *)aSourceBinderID
{
	[sourceBinderID release];
	sourceBinderID = [aSourceBinderID copy];
}

- (NSArray *)itemsToPaste
{
	return itemsToPaste;
}

- (void)setItemsToPaste:(NSArray *)anItems
{
	[itemsToPaste release];
	itemsToPaste = [anItems copy];
}

@end

@implementation ATBookmarks (ScriptingSupport)

- (NSScriptObjectSpecifier *)objectSpecifier
{
	NSScriptObjectSpecifier *aSpecifier = [[self document] objectSpecifier];
	
	return [[[NSPropertySpecifier alloc] initWithContainerSpecifier:aSpecifier key:@"bookmarks"] autorelease];
}

/*- (NSArray *)bookmarkItems
{
	return [NSArray arrayWithObject:[self root]];
}*/

- (id)valueInBookmarkItemsWithUniqueID:(id)aNumber
{
	return [self itemForIDNumber:aNumber];
}

- (NSUInteger)countOfBookmarkItems
{
	return [[self root] countOfDescendant]  + 1;
}

- (id)objectInBookmarkItemsAtIndex:(NSUInteger)anIndex
{
	if (anIndex > 0)
	{
		NSUInteger aDescendantIndex = anIndex - 1;
		
		return [[self root] descendantAt:&aDescendantIndex];
	}
	
	return [self root];
}

@end
