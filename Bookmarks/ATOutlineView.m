#import "ATOutlineView.h"

#import "ATBookmarks.h"
#import "ATBookmarksPresentation.h"

@implementation ATOutlineView

- (void)awakeFromNib
{	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outlineViewSelectionDidChange:) name:NSOutlineViewSelectionDidChangeNotification object:self];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSOutlineViewSelectionDidChangeNotification object:self];
	
	[super dealloc];
}

- (void)setDataSource:(id)aSource
{
	if ([self dataSource] != aSource)
	{
		if ([self dataSource])
		{
			[[NSNotificationCenter defaultCenter] removeObserver:self name:ATBookmarksDidOpenFolderNotification object:[self dataSource]];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:ATBookmarksDidCloseFolderNotification object:[self dataSource]];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:ATBookmarksPresentationSelectionDidChangeNotification object:[self dataSource]];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:ATBookmarksDidInsertNotification object:[self dataSource]];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:ATBookmarksDidMoveNotification object:[self dataSource]];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:ATBookmarksDidRemoveNotification object:[self dataSource]];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:ATBookmarksDidEditItemNotification object:[self dataSource]];

		}
		
		if (aSource)
		{
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(folderWasExpandedOnBookmarks:) name:ATBookmarksDidOpenFolderNotification object:aSource];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(folderWasCollapsedOnBookmarks:) name:ATBookmarksDidCloseFolderNotification object:aSource];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionInBookmarksPresentationDidChange:) name:ATBookmarksPresentationSelectionDidChangeNotification object:aSource];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookmarksItemsDidInsertOrMoveOrRemove:) name:ATBookmarksDidInsertNotification object:aSource];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookmarksItemsDidInsertOrMoveOrRemove:) name:ATBookmarksDidMoveNotification object:aSource];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookmarksItemsDidInsertOrMoveOrRemove:) name:ATBookmarksDidRemoveNotification object:aSource];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookmarksDidEditItem:) name:ATBookmarksDidEditItemNotification object:aSource];
		}
		
		[super setDataSource:aSource];
	}
}

- (void)reloadData
{
	inSynchronization = YES;
	
	[super reloadData];
	
	[self updateSwitchingStatus];
		
	[self selectRowIndexes:[self selectionIndexSetInPresentation] byExtendingSelection:NO];
	
	inSynchronization = NO;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	[super mouseDown:theEvent];
	
	if ([self selectedRow] != -1 && [theEvent modifierFlags] & NSAlternateKeyMask)
		[self editColumn:[self columnAtPoint:[self convertPoint:[theEvent locationInWindow] fromView:nil]] row:[self selectedRow] withEvent:theEvent select:YES];
}

- (void)expandItem:(id)item expandChildren:(BOOL)expandChildren
{
	[super expandItem:item expandChildren:expandChildren];
	
	if (!inSynchronization)
		[self didExpandItem:item expandChildren:expandChildren];
}

- (void)collapseItem:(id)item collapseChildren:(BOOL)collapseChildren
{
	[super collapseItem:item collapseChildren:collapseChildren];
	
	if (!inSynchronization)
		[self didCollapseItem:item collapseChildren:collapseChildren];
}

@end

@implementation ATOutlineView (Accessing)

- (ATBookmarks *)bookmarks
{
	return [[self dataSource] bookmarks];
}

- (NSIndexSet *)selectionIndexSetInPresentation
{
	NSEnumerator *enumerator = [[[self dataSource] selections] objectEnumerator];
	id anItem = nil;
	NSMutableIndexSet *anIndexSet = [NSMutableIndexSet indexSet];
	
	while (anItem = [enumerator nextObject])
	{
		[anIndexSet addIndex:[self rowForItem:anItem]];
	}

	return anIndexSet;
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	return [[self dataSource] menuForEvent:theEvent];
}

@end

@implementation ATOutlineView (UpdatingView)

- (void)updateSwitchingStatus
{
	int aNumberOfChildren = [[self dataSource] outlineView:self numberOfChildrenOfItem:nil];
	int i = 0;
	id anItem = nil;
	
	for (; i < aNumberOfChildren ; i++)
	{
		anItem = [[self dataSource] outlineView:self child:i ofItem:nil];
		
		if ([[self dataSource] outlineView:self isItemExpandable:anItem])
			[self updateSwitchingStatusOfFolder:anItem];
	}
}

- (void)updateSwitchingStatusOfFolder:(ATBinder *)aFolder
{
	if (!aFolder || ([self rowForItem:aFolder] == -1))
		return;
		
	if ([[self dataSource] outlineView:self isItemExpanded:aFolder])
	{
		int aNumberOfChildren = [[self dataSource] outlineView:self numberOfChildrenOfItem:aFolder];
		int i = 0;
		id anItem = nil;
		
		if (![self isItemExpanded:aFolder])
			[self expandItem:aFolder];
		
		for (; i < aNumberOfChildren ; i++)
		{
			anItem = [[self dataSource] outlineView:self child:i ofItem:aFolder];
			
			if ([[self dataSource] outlineView:self isItemExpandable:anItem])
				[self updateSwitchingStatusOfFolder:anItem];
		}
	}
	else if ([self isItemExpanded:aFolder])
	{
		[self collapseItem:aFolder];
	}
}

@end

@implementation ATOutlineView (ViewDelegateAndNotifications)

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	if (!inSynchronization)
	{
		NSIndexSet *aSet = [self selectedRowIndexes];
		unsigned anIndex;
		NSMutableArray *aSelections = [NSMutableArray array];
		
		for (anIndex = [aSet firstIndex] ; anIndex != NSNotFound ; anIndex = [aSet indexGreaterThanIndex:anIndex])
		{
			[aSelections addObject:[self itemAtRow:anIndex]];
			//NSLog(@"%u", anIndex);
		}
		
		inSynchronization = YES;
		
		[[self dataSource] setSelections:aSelections];
		
		inSynchronization = NO;
	}
}

- (void)didExpandItem:(ATBinder *)aFolder expandChildren:(BOOL)anExpandChildrenFlag
{	
	[[self dataSource] outlineView:self openFolder:aFolder recursive:anExpandChildrenFlag];
	
	[self updateSwitchingStatusOfFolder:aFolder];
}

- (void)didCollapseItem:(ATBinder *)aFolder collapseChildren:(BOOL)anCollapseChildrenFlag;
{	
	[[self dataSource] outlineView:self closeFolder:aFolder recursive:anCollapseChildrenFlag];
}

@end

@implementation ATOutlineView (BookmarksPresentationNotifications)

- (void)bookmarksItemsDidInsertOrMoveOrRemove:(NSNotification *)aNotification
{
	[self reloadData];
	[self deselectAll:nil];
}

- (void)bookmarksDidEditItem:(NSNotification *)aNotification
{
	[self reloadItem:[[aNotification userInfo] objectForKey:@"item"]];
}

- (void)selectionInBookmarksPresentationDidChange:(NSNotification *)aNotification
{
	if (!inSynchronization)
	{
		NSArray *aSelections = [[aNotification userInfo] objectForKey:@"selections"];
		NSEnumerator *enumerator = [aSelections objectEnumerator];
		id anItem = nil;
		NSMutableIndexSet *anIndexSet = [NSMutableIndexSet indexSet];
		
		while (anItem = [enumerator nextObject])
		{
			[anIndexSet addIndex:[self rowForItem:anItem]];
		}
		
		inSynchronization = YES;
		
		[self selectRowIndexes:anIndexSet byExtendingSelection:NO];
		
		inSynchronization = NO;
	}
}

- (void)folderWasExpandedOnBookmarks:(NSNotification *)aNotification
{
	if (!inSynchronization)
	{
		inSynchronization = YES;
		
		[self updateSwitchingStatusOfFolder:[[aNotification userInfo] objectForKey:@"folder"]];
				
		inSynchronization = NO;
	}
}

- (void)folderWasCollapsedOnBookmarks:(NSNotification *)aNotification
{
	if (!inSynchronization)
	{
		inSynchronization = YES;
		
		[self updateSwitchingStatusOfFolder:[[aNotification userInfo] objectForKey:@"folder"]];
		
		inSynchronization = NO;
	}
}

@end