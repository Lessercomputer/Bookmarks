//
//  ATDocumentPreferencesPresentation.m
//  Bookmarks
//
//  Created by 高田 明史 on 2014/06/28.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
//

#import "ATDocumentPreferencesPresentation.h"
#import "ATDocumentPreferences.h"

NSString *ATDocumentPreferencesPrivateIndexSet = @"ATDocumentPreferencesPrivateIndexSet";

@implementation ATDocumentPreferencesPresentation

- (ATDocumentPreferences *)preferences
{
    return preferences;
}

- (void)setPreferences:(ATDocumentPreferences *)aPreferences
{
    [preferences autorelease];
    preferences = [aPreferences retain];
}

- (void)dealloc
{
    [preferences release];
    
    [super dealloc];
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:rowIndexes] forType:ATDocumentPreferencesPrivateIndexSet];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    if ([[info draggingPasteboard] availableTypeFromArray:@[ATDocumentPreferencesPrivateIndexSet]] && dropOperation != NSTableViewDropOn)
        return NSDragOperationMove;
    else
        return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
    NSIndexSet *aRowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:[[info draggingPasteboard] dataForType:ATDocumentPreferencesPrivateIndexSet]];
    
    [preferences moveMenuItemDescriptionsAtIndexes:aRowIndexes toIndex:row];
    
    return YES;
}

@end
