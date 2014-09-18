//
//  ATNullBetweenNilTransformer.m
//  ATBookmarks
//
//  Created by –¾Žj on 05/10/12.
//  Copyright 2005 Pedophilia. All rights reserved.
//

#import "ATNullBetweenNilTransformer.h"


@implementation ATNullBetweenNilTransformer

+(Class) transformedValueClass {
    return [NSNull class];
}

+(BOOL) allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value;
{
    return [value isKindOfClass:[NSNull class]] ? nil : value;
}

- (id)reverseTransformedValue:(id)value;
{
    return value ? value : [NSNull null];
}

@end
