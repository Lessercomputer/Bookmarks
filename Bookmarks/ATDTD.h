//
//  ATDTD.h
//  Bookmarks
//
//  Created by P,T,A on 07/08/09.
//  Copyright 2007 Nursery-Framework. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATElementDeclaration;

@interface ATDTD : NSObject
{
	NSDictionary *declarationDictionary;
}

- (ATElementDeclaration *)elementDeclarationForName:(NSString *)aName;

@end
