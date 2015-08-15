//
//  BookmarksHome.h
//  Bookmarks
//
//  Created by P,T,A on 2012/11/30.
//
//

#import <Foundation/Foundation.h>
#import <Nursery/Nursery.h>

@class ATBookmarks;
@class ATBookmarksPresentation;
@class ATIDPool;
@class ATDocumentPreferences;

@interface ATBookmarksHome : NSObject
{
    NUBell *bell;
    ATBookmarks *bookmarks;
    ATIDPool *bookmarksPresentationIDPool;
    NSMutableArray *bookmarksPresentations;
    NSDictionary *windowSettings;
    ATDocumentPreferences *preferences;
    NUNursery *nursery;
    NUBranchNurseryAssociation *nurseryAssociation;
}

+ (id)bookmarksHome;

- (ATBookmarksPresentation *)newBookmarksPresentation;

- (NSNumber *)newBookmarksPresentationID;

@end

@interface ATBookmarksHome (Coding) <NUCoding>
- (NUPlayLot *)playLot;
@end

@interface ATBookmarksHome (Accessing)

- (ATBookmarks *)bookmarks;
- (void)setBookmarks:(ATBookmarks *)aBookmarks;

- (NUNursery *)nursery;
- (NUBranchNurseryAssociation *)nurseryAssociation;
- (ATIDPool *)bookmarksPresentationIDPool;
- (NSMutableArray *)bookmarksPresentations;
- (NSDictionary *)windowSettings;
- (void)setWindowSettings:(NSDictionary *)aDictionary;

- (ATDocumentPreferences *)preferences;

@end

@interface ATBookmarksHome (Private)

- (void)setNursery:(NUNursery *)aNursery;
- (void)setNurseryAssociation:(NUBranchNurseryAssociation *)anAssociation;
- (void)setBookmarksPresentationIDPool:(ATIDPool *)aPool;
- (void)setBookmarksPresentations:(NSMutableArray *)aPresentations;

@end