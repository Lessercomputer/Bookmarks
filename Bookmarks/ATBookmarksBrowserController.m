//
//  ATBookmaksBrowserController.m
//  ATBookmarks
//
//  Created by 明史 高田 on 11/12/30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATBookmarksBrowserController.h"
#import "ATBookmarksPresentation.h"
#import "ATBookmarks.h"
#import "ATItem.h"
#import "ATBinder.h"
#import "ATItemWrapper.h"
#import "ATBinderWrapper.h"
#import "ATEditor.h"
#import "ATBrowserMatrix.h"
#import "ATInspectorWindowController.h"

@implementation ATBookmarksBrowserController

- (void)awakeFromNib
{
    [(NSBrowser *)[self view] setDoubleAction:@selector(openItem:)];
    [(NSBrowser *)[self view] setAction:@selector(clicked:)];
    [self setNextResponder:[[self view] nextResponder]];
    [[self view] setNextResponder:self];
    [[self browser] setMatrixClass:[ATBrowserMatrix class]];
}

- (NSBrowser *)browser
{
    return browser;
}

- (void)setBrowser:(NSBrowser *)aBrowser
{
    [browser release];
    browser = [aBrowser retain];
}

- (ATBookmarksPresentation *)bookmarksPresentation
{
    return bookmarksPresentaion;
}

- (void)setBookmarksPresentation:(ATBookmarksPresentation *)aBookmarksPresentation
{
    if (bookmarksPresentaion)
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [bookmarksPresentaion release];
    bookmarksPresentaion = [aBookmarksPresentation retain];
    
    if (bookmarksPresentaion)
    {
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentationDidChange:) name:ATBookmarksDidChangeNotification object:bookmarksPresentaion];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentationDidChange:) name:ATBookmarksPresentationDidChangeNotification object:bookmarksPresentaion];
    }
}

- (void)presentationDidChange:(NSNotification *)aNotification
{
    BOOL aRootChanged = [aNotification userInfo] ? [[[aNotification userInfo] objectForKey:@"RootChangedKey"] boolValue] : NO;
    [self updateBrowser:aRootChanged];
}

- (void)updateBrowser:(BOOL)aRootChanged
{
    //[[self browser] loadColumnZero];
    
    if (![self updatingIsEnabled]) return;
    
    NSLog(@"updateBrowser: aRootChanged = %@", aRootChanged ? @"YES" : @"NO");

    [self disableUpdating];
    
    ATBookmarksPresentation *aPresentaion = [self bookmarksPresentation];
    NSUInteger aBinderCount = [aPresentaion binderCount];
    BOOL anUpdateAll = NO;
    NSUInteger i = 0;
    
    if (![browser isLoaded] || aRootChanged)
    {
        anUpdateAll = YES;
        [browser loadColumnZero];
    }
        
    for (; i < aBinderCount; i++)
    {
        ATBinderWrapper *aBinderWrapper = [aPresentaion binderWrapperAt:i];
        
        if (anUpdateAll || [aBinderWrapper itemsIsChanged])
            [browser reloadColumn:i];
        if (anUpdateAll || [aBinderWrapper selectionIsChanged])
            [browser selectRowIndexes:[aPresentaion selectionIndexesInColumn:i] inColumn:i];
    }

    [[[self view] window] makeFirstResponder:[self view]];
    
    [self enableUpdating];
}

- (BOOL)updatingIsEnabled
{
    return disableCountOfUpdating == 0;
}

- (void)disableUpdating
{
    disableCountOfUpdating++;
}

- (void)enableUpdating
{
    disableCountOfUpdating--;
}

- (id)rootItemForBrowser:(NSBrowser *)browser
{
    return [[self bookmarksPresentation] binderWrapperAt:0];
}

- (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)anItemWrapper
{
    //NSLog([anItemWrapper description]);
    //NSLog(@"browser:numberOfChildrenOfItem:");
    [self disableUpdating];
    
    NSInteger anItemCount = [[self bookmarksPresentation] itemCountOf:anItemWrapper];
    
    [self enableUpdating];
    
    return anItemCount;
}

- (id)browser:(NSBrowser *)browser child:(NSInteger)anIndex ofItem:(id)anItemWrapper
{
    return [[self bookmarksPresentation] itemWrapperAt:anIndex ofBinderWrapper:anItemWrapper];
}

- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)anItemWrapper
{
    return [(ATItem *)[anItemWrapper item] isBookmark];
}

- (id)browser:(NSBrowser *)browser objectValueForItem:(id)anItemWrapper 
{
    id item = [anItemWrapper item];
    
    if ([item isBookmark])
    {
        NSTextAttachment *aTextAttachment = [[[NSTextAttachment alloc] init] autorelease];
        NSTextAttachmentCell *aTextAttachmentCell = [[[NSTextAttachmentCell alloc] init] autorelease];
        [aTextAttachmentCell setImage:[item icon]];
        [aTextAttachment setAttachmentCell:aTextAttachmentCell];
        NSMutableAttributedString *anAttributedString = (NSMutableAttributedString *)[NSMutableAttributedString attributedStringWithAttachment:aTextAttachment];
        [anAttributedString appendAttributedString:[[[NSAttributedString alloc] initWithString:[item name]] autorelease]];
        return anAttributedString;
    }
    else
        return [item name];
}

- (BOOL)browser:(NSBrowser *)browser shouldEditItem:(id)item
{
    return YES;
}

- (void)browser:(NSBrowser *)browser setObjectValue:(id)object forItem:(id)item
{
    [self disableUpdating];
    
    ATEditor *anEditor = [ATEditor editorFor:[item item] on:[self bookmarksPresentation]];
    
    [[anEditor value] setObject:([object isEqual:@""] ? [NSNull null] : object) forKey:@"name"];
    
    [anEditor acceptIfValid];
    
    [self enableUpdating];
}

- (NSIndexSet *)browser:(NSBrowser *)browser selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes inColumn:(NSInteger)column
{
    //NSLog([proposedSelectionIndexes description]);
    //NSLog(@"#browser:selectionIndexesForProposedSelection:inColumn:");
    
    if (![self updatingIsEnabled]) return proposedSelectionIndexes;
    
    [self disableUpdating];
    
    [[self bookmarksPresentation] setSelectionIndexes:proposedSelectionIndexes inColumn:column];
	
    [self enableUpdating];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:ATBookmarksDidChangeNotification object:self];
    
    return proposedSelectionIndexes;
}
//- (BOOL)browser:(NSBrowser *)sender selectRow:(int)row inColumn:(int)column
//{
//	NSLog(@"row: %d, column: %d", row, column);
//	return YES;
//}

- (void)browser:(id)sender draggingEntered:(id <NSDraggingInfo>)aDraggingInfo
{
    [[self bookmarksPresentation] browser:sender draggingEntered:aDraggingInfo];
}

- (void)browser:(id)sender draggingEnded:(id <NSDraggingInfo>)aDraggingInfo
{
    [[self bookmarksPresentation] browser:sender draggingEnded:aDraggingInfo];
}

- (BOOL)browser:(NSBrowser *)browser canDragRowsWithIndexes:(NSIndexSet *)rowIndexes inColumn:(NSInteger)column withEvent:(NSEvent *)event
{
    return YES;
}

//- (BOOL)browser:(NSBrowser *)sender canDragRowsWithIndexes:(NSIndexSet *)aDraggingRows inColumn:(int)aDraggingColumn
//{	
//	return YES;
//}

- (BOOL)browser:(NSBrowser *)sender writeRowsWithIndexes:(NSIndexSet *)aDraggingRows inColumn:(NSInteger)aDraggingColumn toPasteboard:(NSPasteboard *)aDragPboard
{
	ATBinder *aSourceBinder = [[self bookmarksPresentation] binderAt:aDraggingColumn];
    
    return [[[self bookmarksPresentation] bookmarks] writeDraggingItemsWithIndexes:aDraggingRows of:aSourceBinder to:aDragPboard];
}

- (NSDragOperation)browser:(NSBrowser *)browser validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger *)row column:(NSInteger *)column dropOperation:(NSBrowserDropOperation *)dropOperation
{
    //NSLog(@"browser:validateDrop:proposedRow:column:dropOperation:");
    
    if (*column == -1) return NSDragOperationNone;
    
    //NSLog(@"#browser:validateDrop:proposedRow:column:dropOperation:");
    [self performSelector:@selector(afterValidateDrop:) withObject:nil afterDelay:0.003];
    
    ATBinder *aBinder = [[self bookmarksPresentation] binderAt:*column];
    
    if (*dropOperation == NSBrowserDropOn)
        return [[[self bookmarksPresentation] bookmarks] validateDrop:info on:[aBinder at:*row]];
    else
        return [[[self bookmarksPresentation] bookmarks] validateDrop:info to:aBinder at:*row];
}

- (void)afterValidateDrop:(id)anObject
{
    //NSLog(@"#afterValidateDrop");
}

- (BOOL)browser:(NSBrowser *)sender acceptDrop:(id <NSDraggingInfo>)dragInfo atRow:(NSInteger)aRow column:(NSInteger)aColumn dropOperation:(NSBrowserDropOperation)aDropOperation
{
    [self disableUpdating];
    
//    [self disableViewUpdating];
    
    //NSLog(@"browser:acceptDrop:atRow:column:dropOperation:");
	ATBinder *aBinder = [[self bookmarksPresentation] binderAt:aColumn];
	BOOL aDropAccepted = NO;
    
	//NSLog(@"row: %d, column: %d, %@", aRow, aColumn, aDropOperation == NSBrowserDropOn ? @"DropOn" : @"DropAbove");
	
	if (aDropOperation == NSBrowserDropOn)
		aDropAccepted = [[self bookmarksPresentation] acceptDrop:dragInfo on:[aBinder at:aRow] contextInfo:[[self bookmarksPresentation] presentationID]];
	else
		aDropAccepted = [[self bookmarksPresentation] acceptDrop:dragInfo to:aBinder at:aRow contextInfo:[[self bookmarksPresentation] presentationID]];
    
//    [browser reloadColumn:2];
//    [browser reloadColumn:1];
//    [browser reloadColumn:0];

//    [self enableViewUpdating];
    
    [self enableUpdating];
    
    return aDropAccepted;
}

- (void)browser:(NSBrowser *)browser didChangeLastColumn:(NSInteger)oldLastColumn toColumn:(NSInteger)column
{
    //NSLog(@"oldLastColum:%ld, column:%ld", oldLastColumn, column);

    if (![self updatingIsEnabled]) return;    

    [self disableUpdating];
    
//    ATBinder *aParentBinder = [browser parentForItemsInColumn:column];
//    NSIndexSet *aSelectedRowIndexes = [browser selectedRowIndexesInColumn:column - 1];
//    NSLog([aSelectedRowIndexes description]);
//    if (column - 1 >= 0)
//        [[self bookmarksPresentation] setSelectionIndexes:aSelectedRowIndexes inColumn:column - 1];

    [[self bookmarksPresentation] changeLastColumn:oldLastColumn toColumn:column];
    
    [self enableUpdating];
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
    return [[self bookmarksPresentation] menuForEvent:theEvent];
}

- (IBAction)openItem:(id)sender
{
    //NSLog(@"clickedColumn: %d, clickedRow: %d", [browser clickedColumn], [browser clickedRow]);
    
    [[self bookmarksPresentation] open:[[[self bookmarksPresentation] selections] lastObject]];
}

- (IBAction)clicked:(id)sender
{
    //NSLog(@"#clicked:");
    if (![self updatingIsEnabled] || [[self bookmarksPresentation] isInDragging]) return;
    
    [self disableUpdating];
    [[self bookmarksPresentation] setSelectedColumn:[browser selectedColumn]];
    [self enableUpdating];
}

- (void)dealloc
{
    [self setBrowser:nil];
    [self setBookmarksPresentation:nil];
    
    [super dealloc];
}

@end
