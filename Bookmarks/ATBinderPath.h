//
//  ATBinderPath.h
//  ATBookmarks
//
//  Created by 高田 明史 on 09/07/04.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATBinder;


@interface ATBinderPath : NSObject
{
	NSMutableArray *binderPath;
}

+ (id)binderPathWithRoot:(ATBinder *)aBinder;

- (id)initWithRoot:(ATBinder *)aBinder;


- (ATBinder *)root;
- (void)setRoot:(ATBinder *)aBinder;

- (void)addColumnForBranch:(int)aRow inColumn:(int)aColumn;
- (void)setSelections:(NSIndexSet *)aRows inColumn:(int)aColumn;
- (void)setSelectedItems:(NSArray *)aSelections inColumn:(int)aColumn;
- (void)removeSelectedItems:(NSArray *)anItems from:(int)aColumn;
- (int)count;
- (NSArray *)binders;
- (ATBinder *)lastBinder;
- (BOOL)contains:(ATBinder *)aBinder;
- (ATBinder *)binderForColumn:(int)aColumn;
- (ATBinder *)binderBefore:(ATBinder *)aBinder;
- (ATBinder *)selectedBinder;
- (int)columnForBinder:(ATBinder *)aBinder;
- (int)selectedColumn;
- (int)lastColumn;
- (int)columnBefore:(ATBinder *)aBinder;
- (int)selectionInColumn:(int)aColumn;
- (NSIndexSet *)selectionsInColumn:(int)aColumn;
- (NSArray *)selectedItemsInColumn:(int)aColumn;
- (NSArray *)selectedItems;
- (NSMutableDictionary *)binderPathComponentForColumn:(int)aColumn;
- (void)setBranch:(int)aRow inColumn:(int)aColumn;
- (void)addBinderPathComponentForRow:(int)aRow inColumn:(int)aColumn;
- (void)removeColumnsStartingAt:(int)aColumn;
- (void)removeColumnsStartingWith:(ATBinder *)aBinder;
- (int)firstColumnIn:(NSArray *)aBinders;

- (void)items:(NSArray *)anItems didInsertFrom:(ATBinder *)aSource to:(ATBinder *)aDestination;
- (void)items:(NSArray *)anItems didMoveFrom:(ATBinder *)aSource to:(ATBinder *)aDestination;
- (void)items:(NSArray *)anItems didRemoveFrom:(ATBinder *)aSource;

- (NSMutableArray *)binderPath;
- (void)setBinderPath:(NSMutableArray *)aBinderPath;

@end
