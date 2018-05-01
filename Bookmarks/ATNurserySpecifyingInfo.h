//
//  ATNurserySpecifyingInfo.h
//  Bookmarks
//
//  Created by Akifumi Takata on 2015/07/24.
//  Copyright (c) 2015年 Nursery-Framework. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATNurserySpecifyingInfo : NSObject
{
    NSString *hostName;
    NSString *nurseryName;
}

- (NSString *)hostName;
- (void)setHostName:(NSString *)aName;

- (NSString *)nurseryName;
- (void)setNurseryName:(NSString *)aName;

- (NSURL *)nurseryURL;

@end
