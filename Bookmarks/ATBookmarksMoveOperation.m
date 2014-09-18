//
//  ATBookmarksMoveOperation.m
//  ATBookmarks
//
//  Created by 高田 明史  on 12/01/08.
//  Copyright (c) 2012年 Pedophilia. All rights reserved.
//

#import "ATBookmarksMoveOperation.h"
#import "ATBinder.h"

@implementation ATBookmarksMoveOperation 

+ (id)moveOperationWithSourceIndexes:(NSIndexSet *)aSourceIndexes sourceBinder:(ATBinder *)aSourceBinder destinationIndex:(NSUInteger)aDestinationIndex destinationBinder:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo
{
    return [[[self alloc] initWithSourceIndexes:aSourceIndexes sourceBinder:aSourceBinder destinationIndex:aDestinationIndex destinationBinder:aDestinationBinder contextInfo:anInfo] autorelease];
}

+ (id)moveOperationWithSourceIndexes:(NSIndexSet *)aSourceIndexes sourceBinder:(ATBinder *)aSourceBinder destinationIndexes:(NSIndexSet *)aDestinationIndexs destinationBinder:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo
{
    return [[[self alloc] initWithSourceIndexes:aSourceIndexes sourceBinder:aSourceBinder destinationIndexes:aDestinationIndexs destinationBinder:aDestinationBinder contextInfo:anInfo] autorelease];
}

- (id)initWithSourceIndexes:(NSIndexSet *)aSourceIndexes sourceBinder:(ATBinder *)aSourceBinder destinationIndex:(NSUInteger)aDestinationIndex destinationBinder:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo
{    
    if ([aSourceBinder isEqual:aDestinationBinder])
    {
        aDestinationIndex = aDestinationIndex - [aSourceIndexes countOfIndexesInRange:NSMakeRange(0, aDestinationIndex)];        
    }
    
    NSIndexSet *aDestinationIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(aDestinationIndex, [aSourceIndexes count])];
    
    return [self initWithSourceIndexes:aSourceIndexes sourceBinder:aSourceBinder destinationIndexes:aDestinationIndexes destinationBinder:aDestinationBinder contextInfo:anInfo];
}

- (id)initWithSourceIndexes:(NSIndexSet *)aSourceIndexes sourceBinder:(ATBinder *)aSourceBinder destinationIndexes:(NSIndexSet *)aDestinationIndexs destinationBinder:(ATBinder *)aDestinationBinder contextInfo:(id)anInfo
{
    [super init];
    
    indexes = [aSourceIndexes mutableCopy];
    items = [[aSourceBinder atIndexes:indexes] mutableCopy];
    binder = [aSourceBinder retain];
    
    destinationIndexes = [aDestinationIndexs mutableCopy];
    destinationBinder = [aDestinationBinder retain];
    
    return self;
}

- (NSMutableIndexSet *)sourceIndexes
{
    return [self indexes];
}

- (ATBinder *)sourceBinder
{
    return [self binder];
}

- (NSMutableIndexSet *)destinationIndexes
{
    return destinationIndexes;
}

- (ATBinder *)destinationBinder
{
    return destinationBinder;
}

- (ATBookmarksOperation *)undoOperation
{
    return [ATBookmarksMoveOperation moveOperationWithSourceIndexes:[self destinationIndexes] sourceBinder:[self destinationBinder] destinationIndexes:[self sourceIndexes] destinationBinder:[self sourceBinder] contextInfo:[self contextInfo]];
}

- (void)dealloc
{
    [destinationBinder release];
    [destinationIndexes release];
    
    [super dealloc];
}

@end
