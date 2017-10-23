//
//  ATNurserySpecifyingInfo.h
//  Bookmarks
//
//  Created by P,T,A on 2015/07/24.
//  Copyright (c) 2015年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATNurserySpecifyingInfo : NSObject
{
    NSString *hostName;
    NSString *nurseryAssociationName;
    BOOL useDefaultNurseryAssociationName;
    NSString *nurseryName;
    NSURL *nurseryURL;
}

- (NSString *)hostName;
- (void)setHostName:(NSString *)aName;

- (NSString *)nurseryAssociationName;
- (void)setNurseryAssociationName:(NSString *)aName;

- (BOOL)useDefaultNurseryAssociationName;
- (void)setUseDefaultNurseryAssociationName:(BOOL)aUseFlag;

- (NSString *)nurseryName;
- (void)setNurseryName:(NSString *)aName;

- (NSURL *)nurseryURL;
- (void)setNurseryURL:(NSURL *)aURL;

@end
