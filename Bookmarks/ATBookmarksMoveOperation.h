//
//  ATBookmarksMoveOperation.h
//  ATBookmarks
//
//  Created by 明史 高田 on 12/01/08.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
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
