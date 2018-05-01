//
//  BookmarksHome.m
//  Bookmarks
//
//  Created by Akifumi Takata on 2012/11/30.
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

- (instancetype)retain
{
    return [super retain];
}

- (oneway void)release
{
    [super release];
}

- (instancetype)autorelease
{
    return [super autorelease];
}

- (void)dealloc
{
    NSLog(@"dealloc:%@", self);

    [bookmarksPresentations release];
    [bookmarks release];
    [bookmarksPresentationIDPool release];
    [windowSettings release];
    [preferences release];
    
    [super dealloc];
}

- (ATBookmarksPresentation *)makeBookmarksPresentation
{
    ATBookmarksPresentation *aPresentation = [[[ATBookmarksPresentation alloc] initWithBookmarksHome:self] autorelease];
    
    [aPresentation setPresentationID:[self newBookmarksPresentationID]];
    
    return aPresentation;
}

- (void)addBookmarksPresentation:(ATBookmarksPresentation *)aPresentation
{
    [[self bookmarksPresentations] addObject:aPresentation];
    [[self garden] markChangedObject:[self bookmarksPresentations]];
}

- (void)removeBookmarksPresentaion:(ATBookmarksPresentation *)aPresentation
{
    [[self bookmarksPresentations] removeObject:aPresentation];
}

- (NSNumber *)newBookmarksPresentationID
{
    NSNumber *aNumber = [NSNumber numberWithUnsignedLong:[[self bookmarksPresentationIDPool] newID]];
    [[self garden] markChangedObject:[self bookmarksPresentationIDPool]];
    return aNumber;
}

- (void)close
{
    [[self bookmarks] close];
    [self setNursery:nil];
    [self setGarden:nil];
}

@end

@implementation ATBookmarksHome (Coding)

+ (BOOL)automaticallyEstablishCharacter
{
	return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    [aCharacter addOOPIvarWithName:@"bookmarks"];
    [aCharacter addOOPIvarWithName:@"bookmarksPresentationIDPool"];
    [aCharacter addOOPIvarWithName:@"windowSettings"];
    [aCharacter addOOPIvarWithName:@"preferences"];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
    [anAliaser encodeObject:bookmarks];
    [anAliaser encodeObject:bookmarksPresentationIDPool];
    [anAliaser encodeObject:windowSettings];
    [anAliaser encodeObject:preferences];
}

- (id)initWithAliaser:(NUAliaser *)anAliaser
{
    [super init];
    
    NUSetIvar(&bookmarks, [anAliaser decodeObject]);
    NUSetIvar(&bookmarksPresentationIDPool, [anAliaser decodeObject]);
    NUSetIvar(&windowSettings, [anAliaser decodeObject]);
    NUSetIvar(&preferences, [anAliaser decodeObject]);
    
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

@end

@implementation ATBookmarksHome (Accessing)

- (NUNursery *)nursery
{
    return nursery;
}

- (NUGarden *)garden
{
    return garden;
}

- (void)setBookmarks:(ATBookmarks *)aBookmarks
{    
    NUSetIvar(&bookmarks, aBookmarks);
    [[self garden] markChangedObject:self];
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
    [[self garden] markChangedObject:self];
}

- (ATDocumentPreferences *)preferences
{
    return NUGetIvar(&preferences);
}

@end

@implementation ATBookmarksHome (Private)

- (void)setNursery:(NUNursery *)aNursery
{
    [nursery release];
    nursery = [aNursery retain];

#ifdef DEBUG
    if ([nursery isMainBranch])
        [(NUMainBranchNursery *)nursery setBackups:YES];
#endif
}

- (void)setGarden:(NUGarden *)aGarden
{
    [garden release];
    garden = [aGarden retain];
    
    if ([aGarden root] != self)
        [aGarden setRoot:self];
}

- (void)setBookmarksPresentationIDPool:(ATIDPool *)aPool
{
    NUSetIvar(&bookmarksPresentationIDPool, aPool);
    [[self garden] markChangedObject:self];
}

- (void)setBookmarksPresentations:(NSMutableArray *)aPresentations;
{
    NUSetIvar(&bookmarksPresentations, aPresentations);
    [[self garden] markChangedObject:self];
}

- (void)setbaseGarden:(NUGarden *)aGarden
{
    [baseGarden autorelease];
    baseGarden = [aGarden retain];
}

@end
