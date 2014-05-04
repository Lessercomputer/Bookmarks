//
//  ATDTD.h
//  ATBookmarks
//
//  Created by çÇìcÅ@ñæéj on 07/08/09.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATElementDeclaration;

@interface ATDTD : NSObject
{
	NSDictionary *declarationDictionary;
}

- (ATElementDeclaration *)elementDeclarationForName:(NSString *)aName;

@end
