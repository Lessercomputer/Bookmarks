//
//  ATDocumentPreferencesPresentation.h
//  Bookmarks
//
//  Created by P,T,A on 2014/06/28.
//  Copyright (c) 2014年 PEDOPHILIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATDocumentPreferences;

extern NSString *ATDocumentPreferencesPrivateIndexSet;

@interface ATDocumentPreferencesPresentation : NSObject <NSTableViewDataSource>
{
    ATDocumentPreferences *preferences;
    IBOutlet NSArrayController *arrayController;
}

- (ATDocumentPreferences *)preferences;
- (void)setPreferences:(ATDocumentPreferences *)aPreferences;

@end
