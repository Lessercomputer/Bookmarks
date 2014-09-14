#import "ATBookmarksWindowController.h"
#import "ATInspectorWindowController.h"
#import "ATBookmarksPresentation.h"
#import "ATWebIconLoaderWindowController.h"
#import "ATBookmarks.h"
#import "ATBookmarksBrowserController.h"
#import "ATBookmarksDocument.h"
#import "ATEditor.h"
#import "ATItem.h"
#import "ATBookmarksHome.h"
#import "ATDocumentPreferences.h"

@implementation ATBookmarksWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
	/*NSTextFieldCell *aTextFieldCell = [[bookmarksView tableColumnWithIdentifier:@"urlString"] dataCell];
	ImageAndTextCell *aCell = [[[ImageAndTextCell alloc] init] autorelease];
	[aCell setLineBreakMode:NSLineBreakByTruncatingMiddle];
	[aCell setEditable:YES];*/
	
	[[self window] setDelegate:[self bookmarksPresentation]];
	
	//[bookmarksView setDataSource:[self bookmarksPresentation]];
//	[bookmarksView setMatrixClass:[ATMatrix class]];
//	[bookmarksView setCellClass:[ATBrowserCell class]];
	//[bookmarksView setDelegate:[self bookmarksPresentation]];
	[bookmarksView registerForDraggedTypes:[[self bookmarks] pasteBoardTypes]];
//    [[bookmarksView matrixInColumn:0] registeredDraggedTypes:[[self bookmarks] pasteBoardTypes]];
    
    [browserController setBookmarksPresentation:[self bookmarksPresentation]];
    [browserController setBrowser:bookmarksView];
    [browserController updateBrowser:YES];
    [[self window] makeFirstResponder:bookmarksView];
	
	//[bookmarksView setDoubleAction:@selector(openItem:)];
	
	[presentationController setContent:[self bookmarksPresentation]];
	//[[bookmarksView tableColumnWithIdentifier:@"name"] setDataCell:aCell];
    //[[self window] setStyleMask:NSResizableWindowMask | NSTitledWindowMask];
    //[[self window] setBackgroundColor:[NSColor clearColor]];
    //[[self window] setOpaque:NO];
    
    [[self window] setAlphaValue:[[bookmarksHome preferences] windowAlphaValue]];
    
//	[self addObserverForWindow];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeMain:) name:NSWindowDidBecomeMainNotification object:[self window]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentPreferencesWindowAlphaValueDidChange:) name:ATDocumentPreferencesDidChangeWindowAlphaValueNotification object:[bookmarksHome preferences]];
}

//- (void)showWindow:(id)sender
//{
//    [super showWindow:sender];
//    
//    [[self window] setAlphaValue:[[bookmarksHome preferences] windowAlphaValue]];
//}

//- (void)windowDidBecomeMain:(NSNotification *)aNotification
//{
////    [[self window] setAlphaValue:[[bookmarksHome preferences] windowAlphaValue]];
////    [[self window] setAlphaValue:0];
//}

- (void)documentPreferencesWindowAlphaValueDidChange:(NSNotification *)aNotification
{
    [[self window] setAlphaValue:[[bookmarksHome preferences] windowAlphaValue]];
}

@end

@implementation ATBookmarksWindowController (Initializing)

+ (id)controllerWithPresentation:(ATBookmarksPresentation *)aPresentation windowIndex:(NSUInteger)anIndex home:(ATBookmarksHome *)aHome
{
	return [[[self alloc] initWithPresentation:aPresentation windowIndex:anIndex home:aHome] autorelease];
}

- (id)initWithPresentation:(ATBookmarksPresentation *)aPresentation windowIndex:(NSUInteger)anIndex home:(ATBookmarksHome *)aHome
{
	[super initWithWindowNibName:@"ATBookmarksWindow"];
	
	[self setBookmarksPresentation:aPresentation];
	//[self setBookmarks:aBookmarks];
	
	windowIndex = anIndex;
	
    bookmarksHome = [aHome retain];
    
	return self;
}

- (void)dealloc
{
	NSLog(@"ATBookmarksWindowController #dealloc");
		
	[self setBookmarksPresentation:nil];
    //[browserController release];
	//[self setBookmarks:nil];
	[bookmarksHome release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[super dealloc];
}

@end

@implementation ATBookmarksWindowController (Accessing)

/*- (void)setBookmarks:(ATBookmarks *)aBookmarks
{
	*//*[bookmarks autorelease];
	bookmarks = [aBookmarks retain];*/
	
	/*[bookmarksPresentation setBookmarks:aBookmarks];

	if ([self isWindowLoaded])
		[bookmarksView reloadData];
}*/

- (ATBookmarks *)bookmarks
{
	return [[self bookmarksPresentation] bookmarks];
}

- (void)setBookmarksPresentation:(ATBookmarksPresentation *)aPresentation
{
	[bookmarksPresentation autorelease];
	bookmarksPresentation = [aPresentation retain];
	
	/*if ([self isWindowLoaded])
		[bookmarksView reloadData];*/
}

- (ATBookmarksPresentation *)bookmarksPresentation
{
	return bookmarksPresentation;
}

- (NSIndexSet *)selectionIndexSetInPresentation
{
	return nil;//[bookmarksView selectionIndexSetInPresentation];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	return [NSString stringWithFormat:@"%@ : %lu (PMID:%lu)", displayName, (unsigned long)windowIndex, [[[self bookmarksPresentation] presentationID] unsignedIntegerValue]];
}

@end

@implementation ATBookmarksWindowController (Actions)

- (IBAction)showWindow:(id)sender
{
	[self setIgnoreWindowFrameChange:YES];
	[super showWindow:sender];
	[self setIgnoreWindowFrameChange:NO];
}

- (IBAction)makeNewBookmark:(id)sender
{
	[[ATInspectorWindowController bookmarkInspectorWith:[ATEditor editorFor:[[self bookmarks] untitledBookmark] on:bookmarksPresentation]] beginSheetOn:[self window]];
}

- (IBAction)makeNewFolder:(id)sender
{
	[[ATInspectorWindowController folderInspectorWith:[ATEditor editorFor:[[self bookmarks] untitledFolder] on:bookmarksPresentation]] beginSheetOn:[self window]];
}

- (void)showNewWindow:(id)sender
{
    [self openWindowForCurrentBinder:sender];
}

- (IBAction)openWindowWithCurrentPresentation:(id)sender
{
	[[self document] openWindowWith:[self bookmarksPresentation]];
}

- (IBAction)openWindowForCurrentBinder:(id)sender
{
    [[self document] openWindowFor:[[self bookmarksPresentation] lastBinder]];
}

- (IBAction)openItem:(id)sender
{
	if ([sender clickedRow] != -1)
	{
		id anItem = [[[self bookmarksPresentation] selections] lastObject];
		
		if ([anItem isBookmark])
			[[self bookmarksPresentation] open:[sender itemAtRow:[sender clickedRow]]];
		else
			[[self document] openWindowFor:[[self bookmarksPresentation] root]];
	}
}


/*- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	[cell setFont:[NSFont controlContentFontOfSize:12]];
}*/

- (IBAction)loadWebIconOfSelectedItems:(id)sender
{
	ATWebIconLoaderWindowController *aLoader = [ATWebIconLoaderWindowController newWith:[bookmarksPresentation selections] bookmarks:[bookmarksPresentation bookmarks]];
	
	[[self document] addWindowController:aLoader];
	[aLoader showWindow:nil];
	[[aLoader model] start];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	/*if ([[tableColumn identifier] isEqualToString:@"name"])
		return NO;
	else 
		return YES;*/
	return NO;
}

- (IBAction)openSelectedBinder:(id)sender
{
	[(ATBookmarksDocument *)[self document] openWindowFor:[[self bookmarksPresentation] selectedBinder]];
}

//- (IBAction)openBookmark:(id)sender
//{
//    NSLog(@"openBookmark:");
//}

- (IBAction)showItemInfo:(id)sender
{
    NSArray *anEditors = [[self bookmarksPresentation] editorsForSelections];
    [(ATBookmarksDocument *)[self document] openInspectorWindowFor:anEditors bookmarksWindowController:self];
}

@end

@implementation ATBookmarksWindowController (Testing)

- (BOOL)validateMenuItem:(NSMenuItem *)aMenuItem
{
	SEL anAction = [aMenuItem action];
	
	if ((anAction == @selector(makeNewBookmark:)) || (anAction == @selector(makeNewFolder:)))
		return [bookmarksPresentation inMakeNewItem] ? NO : YES;
	else if (anAction == @selector(openSelectedBinder:))
		return [[self bookmarksPresentation] canOpenSelectedBinder];
		
	return YES;
}

- (BOOL)ignoreWindowFrameChange
{
	return ignoreWindowFrameChange;
}

- (void)setIgnoreWindowFrameChange:(BOOL)aFlag
{
	ignoreWindowFrameChange = aFlag;
}

@end

@implementation ATBookmarksWindowController (Notifying)

- (void)addObserverForWindow
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidMoveOrResize:) name:NSWindowDidMoveNotification object:[self window]];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidMoveOrResize:) name:NSWindowDidResizeNotification object:[self window]];
}

- (void)windowDidMoveOrResize:(NSNotification *)aNotification
{
	if (![self ignoreWindowFrameChange] && ([[self document] isDocumentEdited] || [[self document] fileURL]))
		[[self document] updateChangeCount:NSChangeDone];
}

@end
