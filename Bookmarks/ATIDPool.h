//
//  ATIDPool.h
//  Bookmarks
//
//  Created by P,T,A on 05/10/11.
//  Copyright 2005 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Nursery/Nursery.h>

@interface ATIDPool : NSObject
{
    NUBell *bell;
    NUUInt64 nextID;
    NSMutableIndexSet *freeIDs;
}

@end

@interface ATIDPool (Initializing)

+ (id)idPool;

+ (id)newWith:(NSDictionary *)aPropertyList;

- (id)initWith:(NSDictionary *)aPropertyList;
@end

@interface ATIDPool (Coding) <NUCoding>
@end

@interface ATIDPool (Accessing)
- (NUUInt64)newID;

- (NUUInt64)newIDWith:(NUUInt64)anID;

- (void)releaseID:(NUUInt64)anID;
@end


@interface ATIDPool (Testing)
- (BOOL)isUsing:(NUUInt64)anID;
@end

@interface ATIDPool (Converting)
- (NSDictionary   *)propertyListRepresentation;
@end
