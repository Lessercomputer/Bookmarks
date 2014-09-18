//
//  ATDTD.h
//  Bookmarks
//
//  Created by 高田 明史 on 07/08/09.
//  Copyright 2007 Pedophilia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATElementDeclaration;

@interface ATDTD : NSObject
{
	NSDictionary *declarationDictionary;
}

- (ATElementDeclaration *)elementDeclarationForName:(NSString *)aName;

@end
