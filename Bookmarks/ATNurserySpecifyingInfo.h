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
    NSString *serviceName;
}

- (NSString *)serviceName;
- (void)setServiceName:(NSString *)aName;

- (NSURL *)nurseryURL;

@end
