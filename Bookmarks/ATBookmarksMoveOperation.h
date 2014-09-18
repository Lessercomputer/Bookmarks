//
//  BookmarksMoveOperation.h
//  Bookmarks
//
//  Created by 高田 明史  on 12/01/08.
//  Copyright (c) 2012年 Pedophilia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATBookmarksOperation.h"

@interface ATBookmarksMoveOperation : ATBookmarksOperation
{
    ATBinder *destinationBinder;
    NSMutableIndexSet *destinationIndexes;
}

+ (id)moveOperationWithSourceIndexes:(NSIndexSet *)aSourceIndexes sourceBinder:(ATBinder *)aSourceBinder destinationIndex:(NSUInteger)aDestinationIndex destinationBinder:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo;

+ (id)moveOperationWithSourceIndexes:(NSIndexSet *)aSourceIndexes sourceBinder:(ATBinder *)aSourceBinder destinationIndexes:(NSIndexSet *)aDestinationIndexs destinationBinder:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo;

- (id)initWithSourceIndexes:(NSIndexSet *)aSourceIndexes sourceBinder:(ATBinder *)aSourceBinder destinationIndex:(NSUInteger)aDestinationIndex destinationBinder:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo;

- (id)initWithSourceIndexes:(NSIndexSet *)aSourceIndexes sourceBinder:(ATBinder *)aSourceBinder destinationIndexes:(NSIndexSet *)aDestinationIndexs destinationBinder:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo;

- (NSMutableIndexSet *)sourceIndexes;
- (ATBinder *)sourceBinder;

- (NSMutableIndexSet *)destinationIndexes;
- (ATBinder *)destinationBinder;

@end
