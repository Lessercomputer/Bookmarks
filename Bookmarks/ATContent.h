//
//  ATContent.h
//  Bookmarks
//
//  Created by P,T,A on 2014/08/14.
//  Copyright (c) 2014年 PEDOPHILIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATContent <NSObject>

- (BOOL)isDeclaredContent;

@optional
- (BOOL)isContentModel;

@end
