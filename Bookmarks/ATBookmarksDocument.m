//
//  MyDocument.m
//  ATBookmarks
//
//  Created by ?? on 05/10/11.
//  Copyright __MyCompanyName__ 2005 . All rights reserved.
//

#import "ATBookmarksDocument.h"
#import "ATBookmarksWindowController.h"
#import "ATFirefoxBookmarksImporter.h"
#import "ATBookmarks.h"
#import "ATBookmarksHome.h"
#import "ATBookmarksPresentation.h"
#import "ATIDPool.h"
#import <Nursery/NUMainBranchNursery.h>
#import "ATInspectorWindowController.h"
#import "ATItem.h"

@implementation ATBookmarksDocument

- (id)init
{
    self = [super init];
    if (self) {
        [self setBookmarksHome:[ATBookmarksHome bookmarksHome]];
		importers = [NSMutableArray new];
    }
    return self;
}

- (BOOL)writeSafelyToURL:(NSURL *)anAbsoluteURL ofType:(NSString *)aTypeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outError
{
    if ([aTypeName isEqualToString:@"ATBookmarksDocumentInNursery"])
    {
        if (![[self nursery] filePath])
            [[self nursery] setFilePath:[anAbsoluteURL path]];
        
        [[self bookmarksHome] setWindowSettings:[self windowSettingsForNursery]];
        
        NUFarmOutStatus aFarmOutStatus = [[[self nursery] playLot] save];
        return aFarmOutStatus == NUFarmOutStatusSucceeded;
    }
    else
    {
        return [super writeSafelyToURL:anAbsoluteURL ofType:aTypeName forSaveOperation:saveOperation error:outError];
    }
    
    return NO;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
    if ([typeName isEqualToString:@"ATBookmarksDocumentInNursery"])
    {
        NUMainBranchNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:[url path]];
        id aNurseryRoot = [[aNursery playLot] root];
        
        if ([aNurseryRoot isKindOfClass:[ATBookmarksHome class]])
        {
            [self setBookmarksHome:aNurseryRoot];
            [[self bookmarksHome] setNursery:aNursery];
            [self bookmarks];
            
            return [self bookmarksHome] ? YES : NO;
        }
        else if ([aNurseryRoot isKindOfClass:[NSDictionary class]])
        {
            [[self bookmarksHome] setBookmarks:[aNurseryRoot objectForKey:@"Bookmarks"]];
            [[self bookmarksHome] setNursery:aNursery];
            [[[self bookmarksHome] bookmarks] setDocument:self];
            [self setUndoManager:[[self bookmarks] undoManager]];
            
            return YES;
        }
        else
            return NO;
    }
    else
        return [super readFromURL:url ofType:typeName error:outError];
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
	NSMutableDictionary *aPlist = [[self bookmarks] propertyListRepresentation];
	
	[aPlist setObject:[self windowSettings] forKey:@"windowSettings"];
	
    return [NSPropertyListSerialization dataFromPropertyList:aPlist format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];//[[self bookmarks] serializedPropertyListRepresentation];
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
	NSDictionary *aPlist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
	
	[self setBookmarks:[ATBookmarks bookmarksWithArchive:aPlist]];
	savedWindowFrame = [[[aPlist objectForKey:@"windowSettings"] objectForKey:@"savedWindowFrame"] copy];
	
	return [self bookmarks] ? YES : NO;
}

- (BOOL)revertToContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	BOOL aReverted = [super revertToContentsOfURL:absoluteURL ofType:typeName error:outError];
	
	[[self windowControllers] makeObjectsPerformSelector:@selector(setBookmarks:) withObject:[self bookmarks]];
	
	return aReverted;
}

- (void)makeWindowControllers
{
	
	inMakingWindowControllers = YES;
	
    id aRoot = [[[self nursery] playLot] root];
    NSDictionary *aWindowSettingsForNursery = nil;
    
    if ([aRoot isKindOfClass:[NSDictionary class]])
        aWindowSettingsForNursery = [aRoot objectForKey:@"windowSettings"];
    else
        aWindowSettingsForNursery = [aRoot windowSettings];

	if (aWindowSettingsForNursery)
    {
        NSArray *aWindowFramesAndPresentations = [aWindowSettingsForNursery objectForKey:@"windowFramesAndPresentations"];
        
        [aWindowFramesAndPresentations enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *aDictionary, NSUInteger idx, BOOL *stop)
        {
            ATBookmarksWindowController *aWindowController = [ATBookmarksWindowController controllerWithPresentation:[aDictionary objectForKey:@"presentation"] windowIndex:++windowIndex];
            [aWindowController setShouldCascadeWindows:NO];
            [[aWindowController window] setFrameFromString:[aDictionary objectForKey:@"frame"]];
            [self addWindowController:aWindowController];
            //[aWindowController showWindow:nil];
        }];
    }
    else
    {
        ATBookmarksWindowController *aWindowController = [ATBookmarksWindowController controllerWithPresentation:[[self bookmarksHome] newBookmarksPresentation] windowIndex:++windowIndex];
        
        if (savedWindowFrame)
        {
            [aWindowController setShouldCascadeWindows:NO];
            [[aWindowController window] setFrameFromString:savedWindowFrame];
            [savedWindowFrame release];
            savedWindowFrame = nil;
        }
        
        [self addWindowController:aWindowController];
    }

	inMakingWindowControllers = NO;
}

- (void)showWindows
{
    [[self windowControllers] enumerateObjectsUsingBlock:^(NSWindowController *aWinController, NSUInteger idx, BOOL *stop) {
        [aWinController showWindow:nil];
        [[aWinController window] makeKeyAndOrderFront:nil];
    }];
}

- (void)openWindowWith:(ATBookmarksPresentation *)aPresentation
{
	[self addWindowController:[ATBookmarksWindowController controllerWithPresentation:aPresentation windowIndex:++windowIndex]];
	[[[self windowControllers] lastObject] showWindow:nil];
}

- (void)openWindowFor:(ATBinder *)aBinder
{
    ATBookmarksPresentation *aPresentation = [[self bookmarksHome] newBookmarksPresentation];

	[aPresentation setRoot:aBinder];
	[self addWindowController:[ATBookmarksWindowController controllerWithPresentation:aPresentation windowIndex:++windowIndex]];
	[[[self windowControllers] lastObject] showWindow:nil];
}

- (void)openInspectorWindowFor:(NSArray *)anEditors
{
    [anEditors enumerateObjectsUsingBlock:^(ATEditor *anEditor, NSUInteger idx, BOOL *stop) {
        
        ATInspectorWindowController *anInspectorWindowController = [self inspectorWindowControllerForEditor:anEditor];
        
        if (!anInspectorWindowController)
        {
            NSString *aWindowNibName = [[anEditor item] isBookmark] ? @"ATBookmarkInspectorWindow" : @"ATBinderInspectorWindow";
            
            anInspectorWindowController = [[[ATInspectorWindowController alloc] initWith:anEditor windowNibName:aWindowNibName] autorelease];
            [self addWindowController:anInspectorWindowController];
        }
        
        [anInspectorWindowController showWindow:nil];
    }];
}

- (ATInspectorWindowController *)inspectorWindowControllerForEditor:(ATEditor *)anEditor
{
    __block ATInspectorWindowController *anInspectorWindowController = nil;
    
    [[self windowControllers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[ATInspectorWindowController class]]
            && [[[obj editor] item] isEqual:[anEditor item]])
        {
            anInspectorWindowController = obj;
            *stop = YES;
        }
    }];

    return anInspectorWindowController;
}

- (NSDictionary *)windowSettings
{
	return [NSDictionary dictionaryWithObject:[[[[self windowControllers] objectAtIndex:0] window] stringWithSavedFrame] forKey:@"savedWindowFrame"];
}

- (NSDictionary *)windowSettingsForNursery
{
    NSMutableDictionary *aDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *aWindowFramesAndPresentations = [NSMutableArray array];
    
    [[self orderedWindows] enumerateObjectsUsingBlock:^(NSWindow *aWindow, NSUInteger idx, BOOL *stop)
    {
        if ([[aWindow windowController] isKindOfClass:[ATBookmarksWindowController class]])
        {
            ATBookmarksPresentation *aPresentation = [[aWindow windowController] bookmarksPresentation];
            NSDictionary *aWindowFrameAndPresentation = [NSDictionary dictionaryWithObjectsAndKeys:aPresentation,@"presentation", [aWindow stringWithSavedFrame],@"frame", nil];
            [aWindowFramesAndPresentations addObject:aWindowFrameAndPresentation];
        }
    }];
    
    [aDictionary setObject:aWindowFramesAndPresentations forKey:@"windowFramesAndPresentations"];
    
    return aDictionary;
}

- (void)dealloc
{
	NSLog(@"ATBookmarksDocument #dealloc");
	
	[importers makeObjectsPerformSelector:@selector(cancel)];
	[importers release];

    [[[self bookmarksHome] nursery] close];
    [self setBookmarksHome:nil];
	
	[super dealloc];
}

@end

@implementation ATBookmarksDocument (Actions)

- (IBAction)showRootWindow:(id)sender
{
    [self openWindow:sender];
}

- (IBAction)openWindow:(id)sender
{
    [self openWindowFor:[[self bookmarks] root]];
}

//- (void)openWindowFor:(id)sender
//{
//	ATBookmarksPresentation *aPresentation = [[[ATBookmarksPresentation alloc] initWithBookmarks:[self bookmarks]] autorelease];
//	
//	[aPresentation setRoot:[[sender selections] lastObject]];
//	
//	[self addWindowController:[ATBookmarksWindowController controllerWithPresentation:aPresentation windowIndex:++windowIndex]];
//	[[[self windowControllers] lastObject] showWindow:sender];
//}

- (IBAction)importFirefoxBookmarks:(id)sender
{
	ATFirefoxBookmarksImporter *anImporter = [ATFirefoxBookmarksImporter importerWithDocument:self];

	[importers addObject:anImporter];
	[anImporter importInBackgroundFromFileSelectedByUser];
}

- (void)importerImportingFinished:(ATFirefoxBookmarksImporter *)anImporter
{
	[importers removeObject:anImporter];
}

@end

@implementation ATBookmarksDocument (Accessing)

- (NUMainBranchNursery *)nursery
{
    return [[self bookmarksHome] nursery];
}

-  (void)setBookmarks:(ATBookmarks *)aBookmarks
{
    [[self bookmarksHome] setBookmarks:aBookmarks];
	[aBookmarks setDocument:self];
	[self setUndoManager:[aBookmarks undoManager]];
}

- (ATBookmarks *)bookmarks
{
    return [[self bookmarksHome] bookmarks];
}

- (ATBookmarksHome *)bookmarksHome
{
    return bookmarksHome;
}

- (void)setBookmarksHome:(ATBookmarksHome *)aBookmarksHome
{
    [[bookmarksHome nursery] close];
    [bookmarksHome release];
    bookmarksHome = [aBookmarksHome retain];
    
    [[bookmarksHome bookmarks] setDocument:self];
    [self setUndoManager:[[self bookmarks] undoManager]];
}

- (NSArray *)orderedWindows
{
	NSEnumerator *enumerator = [[[NSApplication sharedApplication] orderedWindows] objectEnumerator];
	NSWindow *aWindow = nil;
	NSMutableArray *anOrderedWindows = [NSMutableArray array];
	
	while (aWindow = [enumerator nextObject])
	{
		NSEnumerator *aDocumentWindowEnum = [[self windowControllers] objectEnumerator];
		id aWindowController = nil;
		BOOL aWindowIsFoundInDocument = NO;
		
		while (!aWindowIsFoundInDocument && (aWindowController = [aDocumentWindowEnum nextObject]))
		{
			if ([aWindow isEqual:[aWindowController window]])
			{
				[anOrderedWindows addObject:aWindow];
				aWindowIsFoundInDocument = YES;
			}
		}
	}
	
	return anOrderedWindows;
}

- (NSWindow *)windowForSheet
{
	return [[self orderedWindows] objectAtIndex:0];
}

@end

@implementation ATBookmarksDocument (Testing)

- (BOOL)hasSheet
{
	BOOL aWindowHasAttachedSheet = NO;
	NSEnumerator *enumerator = [[self windowControllers] objectEnumerator];
	id aWindowController = nil;
	
	while (!aWindowHasAttachedSheet && (aWindowController = [enumerator nextObject]))
		aWindowHasAttachedSheet = [[aWindowController  window] attachedSheet] ? YES : NO;
	
	return aWindowHasAttachedSheet;
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
    SEL anAction = [anItem action];

    if (anAction == @selector(revertDocumentToSaved:))
    {
        return !([self isDocumentEdited] && [super validateUserInterfaceItem:anItem]) ? NO : YES;
    }
	else
		return [super validateUserInterfaceItem:anItem];
}

- (BOOL)inMakingWindowControllers
{
	return inMakingWindowControllers;
}

@end