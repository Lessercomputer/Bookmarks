//
//  BookmarksHome.m
//  Bookmarks
//
//  Created by P,T,A on 2012/11/30.
//
//

#import "ATBookmarksHome.h"
#import "ATBookmark.h"
#import "ATBookmarks.h"
#import "ATBookmarksPresentation.h"
#import "ATIDPool.h"
#import "ATDocumentPreferences.h"

@implementation ATBookmarksHome

+ (id)bookmarksHome
{
    return [[self new] autorelease];
}

- (id)init
{
    [super init];
    
    [self setNursery:[NUMainBranchNursery nurseryWithContentsOfFile:nil]];
    bookmarksPresentationIDPool = [[ATIDPool idPool] retain];
    bookmarksPresentations = [[NSMutableArray array] retain];
    bookmarks = [ATBookmarks new];
    preferences = [ATDocumentPreferences new];
    
    return self;
}

- (void)dealloc
{
    [bookmarks close];
    [bookmarks release];
    [bookmarksPresentationIDPool release];
    [bookmarksPresentations release];
    [windowSettings release];
    [preferences release];
    [nursery close];
    [nursery release];
    
    [super dealloc];
}

- (ATBookmarksPresentation *)newBookmarksPresentation
{
    ATBookmarksPresentation *aPresentation = [[[ATBookmarksPresentation alloc] initWithBookmarksHome:self] autorelease];
    
    [aPresentation setPresentationID:[self newBookmarksPresentationID]];
    [[self bookmarksPresentations] addObject:aPresentation];
    [[self playLot] markChangedObject:[self bookmarksPresentations]];
    
    return aPresentation;
}

- (NSNumber *)newBookmarksPresentationID
{
    NSNumber *aNumber = [NSNumber numberWithUnsignedLong:[[self bookmarksPresentationIDPool] newID]];
    [[self playLot] markChangedObject:[self bookmarksPresentationIDPool]];
    return aNumber;
}

@end

@implementation ATBookmarksHome (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUPlayLot *)aPlayLot
{
    [aCharacter addOOPIvarWithName:@"bookmarks"];
    [aCharacter addOOPIvarWithName:@"bookmarksPresentationIDPool"];
    [aCharacter addOOPIvarWithName:@"windowSettings"];
    [aCharacter addOOPIvarWithName:@"preferences"];
}

- (void)encodeWithAliaser:(NUAliaser *)aChildminder
{
    [aChildminder encodeObject:bookmarks];
    [aChildminder encodeObject:bookmarksPresentationIDPool];
    [aChildminder encodeObject:windowSettings];
    [aChildminder encodeObject:preferences];
}

- (id)initWithAliaser:(NUAliaser *)aChildminder
{
    [super init];
    
    NUSetIvar(&bookmarks, [aChildminder decodeObject]);
    NUSetIvar(&bookmarksPresentationIDPool, [aChildminder decodeObject]);
    NUSetIvar(&windowSettings, [aChildminder decodeObject]);
    NUSetIvar(&preferences, [aChildminder decodeObject]);
    
    return self;
}

- (NUBell *)bell
{
    return bell;
}

- (void)setBell:(NUBell *)anOOP
{
    bell = anOOP;
}

- (NUPlayLot *)playLot
{
    return [[self bell] playLot];
}

@end

@implementation ATBookmarksHome (Accessing)

- (NUMainBranchNursery *)nursery
{
    return nursery;
}

- (void)setBookmarks:(ATBookmarks *)aBookmarks
{    
    NUSetIvar(&bookmarks, aBookmarks);
    [[self playLot] markChangedObject:self];
}

- (ATBookmarks *)bookmarks
{    
    return NUGetIvar(&bookmarks);
}

- (ATIDPool *)bookmarksPresentationIDPool
{
    return NUGetIvar(&bookmarksPresentationIDPool);
}

- (NSMutableArray *)bookmarksPresentations
{
    return NUGetIvar(&bookmarksPresentations);
}

- (NSDictionary *)windowSettings
{
    return NUGetIvar(&windowSettings);
}

- (void)setWindowSettings:(NSDictionary *)aDictionary
{
    NUSetIvar(&windowSettings, aDictionary);
    [[self playLot] markChangedObject:self];
}

- (ATDocumentPreferences *)preferences
{
    return NUGetIvar(&preferences);
}

@end

@implementation ATBookmarksHome (Private)

- (void)setNursery:(NUMainBranchNursery *)aNursery
{
    [nursery close];
    [nursery release];
    nursery = [aNursery retain];

#ifdef DEBUG
    [nursery setBackups:YES];
#endif
    
    if ([[nursery playLot] root] != self)
    {
        [[nursery playLot] setRoot:self];
//        [bookmarks autorelease];
//        bookmarks = nil;
    }
}

- (void)setBookmarksPresentationIDPool:(ATIDPool *)aPool
{
    NUSetIvar(&bookmarksPresentationIDPool, aPool);
    [[self playLot] markChangedObject:self];
}

- (void)setBookmarksPresentations:(NSMutableArray *)aPresentations;
{
    NUSetIvar(&bookmarksPresentations, aPresentations);
    [[self playLot] markChangedObject:self];
}

@end