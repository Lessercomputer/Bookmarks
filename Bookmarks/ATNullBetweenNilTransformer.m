//
//  ATNullBetweenNilTransformer.m
//  Bookmarks
//
//  Created by Akifumi Takata on 05/10/12.
//  Copyright 2005 Nursery-Framework. All rights reserved.
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
