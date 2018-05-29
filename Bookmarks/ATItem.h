//
//  ATItem.h
//  Bookmarks
//
//  Created by Akifumi Takata  on 05/10/11.
//  Copyright 2005 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nursery/Nursery.h>

@class ATBinder, ATBookmarks;

#define ATItemInvalidItemID		NSNotFound

@interface ATItem : NSObject
{
    NUBell *bell;
	NSUInteger itemID;
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

- (NSMutableArray *)binders;

- (void)setName:(NSString *)aName;
- (NSString *)name;

- (NSString *)comment;
- (void)setComment:(NSString *)aComment;

- (NSDate *)addDate;
- (void)setAddDate:(NSDate *)aDate;

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

@end

@interface ATItem (Testing)
- (BOOL)isBookmark;
- (BOOL)isFolder;
- (BOOL)hasItemID;

- (BOOL)canMoveFrom:(ATBinder *)aSourceBinder to:(ATBinder *)aDestinationBinder;
- (BOOL)canInsertTo:(ATBinder *)aBinder;

- (NSComparisonResult)compareItemID:(ATItem *)anAnotherItem;

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

+ (NSArray *)bindersIn:(NSArray *)anItems;

@end

@interface ATItem (GC)

- (void)removeToGC;

@end

@interface ATItem (Private)
- (void)setItemID:(NSUInteger)anID;
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
