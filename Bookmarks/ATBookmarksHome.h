//
//  BookmarksHome.h
//  Bookmarks
//
//  Created by Akifumi Takata on 2012/11/30.
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
    NUGarden *garden;
    NUGarden *baseGarden;
}

+ (id)bookmarksHome;

- (ATBookmarksPresentation *)makeBookmarksPresentation;
- (void)addBookmarksPresentation:(ATBookmarksPresentation *)aPresentation;
- (void)removeBookmarksPresentaion:(ATBookmarksPresentation *)aPresentation;

- (NSNumber *)newBookmarksPresentationID;

- (void)close;

@end

@interface ATBookmarksHome (Coding) <NUCoding>
@end

@interface ATBookmarksHome (Accessing)

- (ATBookmarks *)bookmarks;
- (void)setBookmarks:(ATBookmarks *)aBookmarks;

- (NUNursery *)nursery;
- (NUGarden *)garden;
- (ATIDPool *)bookmarksPresentationIDPool;
- (NSMutableArray *)bookmarksPresentations;
- (NSDictionary *)windowSettings;
- (void)setWindowSettings:(NSDictionary *)aDictionary;

- (ATDocumentPreferences *)preferences;

@end

@interface ATBookmarksHome (Private)

- (void)setNursery:(NUNursery *)aNursery;
- (void)setGarden:(NUGarden *)aGarden;
- (void)setBookmarksPresentationIDPool:(ATIDPool *)aPool;
- (void)setBookmarksPresentations:(NSMutableArray *)aPresentations;
- (void)setbaseGarden:(NUGarden *)aGarden;

@end
