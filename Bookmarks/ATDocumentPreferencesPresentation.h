//
//  ATDocumentPreferencesPresentation.h
//  Bookmarks
//
//  Created by 高田 明史 on 2014/06/28.
//  Copyright (c) 2014年 Pedophilia. All rights reserved.
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
