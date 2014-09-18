//
//  ATBase64Processor.h
//  ATBase64
//
//  Created by 高田 明史 on Sun Apr 10 2005.
//  Copyright (c) 2005 Pedophilia. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *ATBase64ProcessWillStartNotification;
extern NSString *ATBase64InProcessNotification;
extern NSString *ATBase64ProcessDidEndNotification;
extern NSString *ATBase64ProcessCanceldNotification;
extern NSString *ATBase64ProcessFaildNotification;

@interface ATBase64Processor : NSObject
{
	NSData *inputData;
	unsigned location;
	NSMutableData *outputData;
}

+ (id)processor;

- (id)initWith:(NSData *)aData;

- (NSData *)inputData;
- (void)setInputData:(NSData *)aData;

- (void)process;
- (void)processWithScheduled:(NSDictionary *)aSchedule;
- (void)processWithLimit:(NSTimeInterval)aLimit;
- (void)cancel;

- (void)processNext;
- (BOOL)isAtEnd;

@end
