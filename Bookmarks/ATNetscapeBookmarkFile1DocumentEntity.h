//
//  ATNetscapeBookmarkFile1DocumentEntity.h
//  Bookmarks
//
//  Created by P,T,A on 07/08/07.
//  Copyright 2007 PEDOPHILIA. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATNetscapeBookmarkFile1Scanner;
@class ATNETSCAPEBookmarkFile1Element;
@class ATDTD;

@interface ATNetscapeBookmarkFile1DocumentEntity : NSObject
{
	NSString *filePath;
	ATDTD *dtd;
	ATNetscapeBookmarkFile1Scanner *scanner;
	
	ATNETSCAPEBookmarkFile1Element *netscapeBookmarkFile1Element;
}

- (id)initWithContentsOfFile:(NSString *)aPath;
- (id)initWithFilePath:(NSString *)aPath;
- (id)initWithString:(NSString *)aString;

- (void)load;

- (BOOL)parse;

- (ATDTD *)DTD;

- (NSUInteger)countOfElementNamed:(NSString *)aName;

- (NSEnumerator *)objectEnumerator;

@end
