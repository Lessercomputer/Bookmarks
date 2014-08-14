//
//  ATContent.h
//  Bookmarks
//
//  Created by 高田 明史 on 2014/08/14.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATContent <NSObject>

- (BOOL)isDeclaredContent;

@optional
- (BOOL)isContentModel;

@end
