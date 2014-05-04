//
//  ATItem.h
//  ATBookmarks
//
//  Created by 明史 on 05/10/11.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nursery/Nursery.h>

@class ATBinder, ATBookmarks;

#define ATItemInvalidItemID		NSNotFound

@interface ATItem : NSObject
{
    NUBell *bell;
	NSUInteger itemID;
	ATBinder *parent;
	NSMutableSet *binders;
	NSString *name;
	NSString *comment;
	NSDate *addDate;
}

@end

@interface ATItem (Initializing)

+ (id)newWith:(NSDictionary *)aPropertyList;

- (id)initWith:(NSDictionary *)aPropertyList;

@end

@interface ATItem (Coding) <NUCoding>
@end

@interface ATItem (Accessing)

- (NSUInteger)itemID;
- (NSNumber *)numberWithItemID;

- (ATBinder *)parent;
- (NSMutableArray *)binders;

- (ATBookmarks *)bookmarks;

- (void)setName:(NSString *)aName;
- (NSString *)name;

- (NSString *)comment;
- (void)setComment:(NSString *)aComment;

- (NSDate *)addDate;
- (void)setAddDate:(NSDate *)aDate;

- (NSUInteger)index;

- (ATBinder *)root;

- (NSIndexPath *)indexPath;


- (void)writeIndexPathOn:(NSMutableArray *)anArray;

- (id)itemFor:(NSUInteger)anID;

+ (NSArray *)editableValueKeys;
- (NSArray *)editableValueKeys;

@end

@interface ATItem (ItemID)

- (void)itemIDFrom:(ATBookmarks *)aBookmarks;

- (void)restoreItemIDTo:(ATBookmarks *)aBookmarks;

- (void)releaseItemIDFrom:(ATBookmarks *)aBookmarks;

- (void)invalidateItemID;

- (void)writeItemIDOn:(NSMutableArray *)anArray;

@end

@interface ATItem (Modifying)

- (NSUInteger)moveTo:(NSUInteger)anIndex of:(ATBinder *)aDestination from:(ATBinder *)aSource on:(ATBookmarks *)aBookmarks;

@end

@interface ATItem (Testing)
- (BOOL)isBookmark;
- (BOOL)isFolder;
- (BOOL)isRoot;
- (BOOL)hasItemID;

- (BOOL)canMoveFrom:(ATBinder *)aSourceBinder to:(ATBinder *)aDestinationBinder;
- (BOOL)canInsertTo:(ATBinder *)aBinder;

- (BOOL)isDescendantOf:(ATBinder *)aFolder;

- (BOOL)isDescendantIn:(NSArray *)anItems;

- (BOOL)eachAncestorsIsOpen;

- (NSComparisonResult)compareItemID:(ATItem *)anAnotherItem;
- (NSComparisonResult)compareIndex:(ATItem *)anAnotherItem;	

@end

@interface ATItem (Editing)
- (NSDictionary *)valueToEdit;
- (NSDictionary *)acceptEdited:(NSDictionary *)aValue;
- (NSDictionary *)acceptEdited:(NSDictionary *)aValue on:(NSValue *)aBookmarks;
@end

@interface ATItem (Converting)
- (NSMutableDictionary   *)propertyListRepresentation;

- (void)writeOn:(NSMutableArray *)anArray;
@end

@interface ATItem (Selecting)

+ (NSArray *)minimum:(NSArray *)anItems;

+ (NSArray *)categorizeByParentAndIndex:(NSArray *)anItems;

+ (NSArray *)categorizeByParent:(NSArray *)anItems;

+ (NSArray *)categorizeByIndex:(NSArray *)anItems;

+ (NSArray *)bindersIn:(NSArray *)anItems;

@end


@interface ATItem (Private)
- (void)setItemID:(NSUInteger)anID;
- (void)setParent:(ATBinder *)aFolder;
- (void)addBinder:(ATBinder *)aBinder;
- (void)removeBinder:(ATBinder *)aBinder;
- (void)setBinders:(NSMutableSet *)aBinders;
@end

@interface ATItem (Validating)
- (BOOL)validateName:(id *)ioValue error:(NSError **)outError;
- (BOOL)validateEdited:(NSDictionary *)aValue;
- (BOOL)hasChagned:(NSDictionary *)aValue;
- (NSDictionary *)changedValuesFor:(NSDictionary *)anEditedValues;
@end

@interface ATItem (ScriptingSupport)
@end