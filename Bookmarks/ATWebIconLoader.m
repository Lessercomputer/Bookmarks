//
//  ATWebIconLoader.m
//  ATBookmarks
//
//  Created by 高田 明史 on 2012/12/28.
//
//

#import "ATWebIconLoader.h"
#import "ATBookmark.h"
#import "ATBookmarks.h"
#import <WebKit/WebKit.h>


@implementation ATWebIconLoader

+ (id)newWith:(NSArray *)anItems bookmarks:(ATBookmarks *)aBookmarks
{
	return [[[self alloc] initWith:anItems bookmarks:aBookmarks] autorelease];
}

- (id)initWith:(NSArray *)anItems bookmarks:(ATBookmarks *)aBookmarks
{
	[super init];
	
	items = [anItems copy];
    urlToFaviconDictionary = [NSMutableDictionary new];
    
    bookmarks = [aBookmarks retain];
    webView = [[WebView alloc] initWithFrame:NSZeroRect frameName:nil groupName:nil];
    [webView setFrameLoadDelegate:self];
    
#ifdef DEBUG
    NSLog(@"%@", [NSThread currentThread]);
#endif
    
	return self;
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@", [NSThread currentThread]);
#endif
    
	[items release];
	items = nil;
	[self setCurrentIconImage:nil forURL:nil];
    [urlToFaviconDictionary release];
    urlToFaviconDictionary = nil;
    [bookmarks release];
    bookmarks = nil;
    [webView release];
    webView = nil;
	
	[super dealloc];
}

- (void)start
{
	[self loadNext];
}

- (void)cancel
{
#ifdef DEBUG
    NSLog(@"%@", [NSThread currentThread]);
#endif
    
	inCancel = YES;
	[webView stopLoading:nil];
    [webView setFrameLoadDelegate:nil];
	inCancel = NO;
}

- (void)loadNext
{
#ifdef DEBUG
    NSLog(@"%@", [NSThread currentThread]);
#endif
    
	if (inCancel)
		return;
    
	[self setCurrentIconImage:nil forURL:nil];
	
    currentIndex = [self nextBookmarkIndex];
    
	if (currentIndex != NSNotFound)
	{
		NSURL *aURL = [[items objectAtIndex:currentIndex] url];
		[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:aURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0]];
	}
	else
	{
        [webView setFrameLoadDelegate:nil];
		[self applyWebIconImagesToItems];
        [[self delegate] webIconLoaderDidFinishLoading:self];
	}
}

- (NSUInteger)nextBookmarkIndex
{
#ifdef DEBUG
    NSLog(@"%@", [NSThread currentThread]);
#endif
    
    for (NSUInteger i = currentIndex; i < [items count]; i++)
    {
        if ([[items objectAtIndex:i] url]) return i;
    }
    
    return NSNotFound;
}


- (NSString *)title
{
    return title;
}

- (void)setTitle:(NSString *)aString
{
    [self willChangeValueForKey:@"title"];
    [title autorelease];
    title = [aString copy];
    [self didChangeValueForKey:@"title"];
}

- (NSImage *)currentIconImage
{
	return currentIconImage;
}

- (void)setCurrentIconImage:(NSImage *)anImage forURL:(NSString *)aURLString
{
#ifdef DEBUG
    NSLog(@"%@", [NSThread currentThread]);
#endif
    
    if (aURLString && ![[[items objectAtIndex:currentIndex] urlString] isEqualToString:aURLString]) return;
    
    [self willChangeValueForKey:@"currentIconImage"];
	[currentIconImage release];
	currentIconImage = [anImage retain];
    [self didChangeValueForKey:@"currentIconImage"];
}

- (void)applyWebIconImagesToItems
{
    NSMutableArray *aFavicons = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(ATBookmark *aBookmark, NSUInteger idx, BOOL *stop) {
        if ([aBookmark url] && [urlToFaviconDictionary objectForKey:[aBookmark urlString]])
            [aFavicons addObject:[urlToFaviconDictionary objectForKey:[aBookmark urlString]]];
        else
            [aFavicons addObject:[NSNull null]];
    }];
	[bookmarks apply:aFavicons to:items];
}

- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame
{
	if ([sender mainFrame] == frame)
	{
#ifdef DEBUG
        NSLog(@"%@", [NSThread currentThread]);
#endif
        [urlToFaviconDictionary setObject:image forKey:[sender mainFrameURL]];
		[self setCurrentIconImage:image forURL:[sender mainFrameURL]];
	}
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)aTitle forFrame:(WebFrame *)frame
{
	if ([sender mainFrame] == frame)
	{
#ifdef DEBUG
        NSLog(@"%@", [NSThread currentThread]);
#endif
		[self setTitle:aTitle];
	}
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	if ([sender mainFrame] == frame)
	{
#ifdef DEBUG
        NSLog(@"%@", [NSThread currentThread]);
#endif
        [self performSelector:@selector(pageLoadFinished:) withObject:nil afterDelay:0.5];
	}
}

- (void)pageLoadFinished:(id)sender
{
#ifdef DEBUG
    NSLog(@"%@", [NSThread currentThread]);
#endif
    [sender stopLoading:nil];
    
    if (![self currentIconImage] && [sender mainFrameIcon])
    {
        [self setCurrentIconImage:[sender mainFrameIcon] forURL:[webView mainFrameURL]];
        [urlToFaviconDictionary setObject:[sender mainFrameIcon] forKey:[webView mainFrameURL]];
    }
    
    currentIndex++;
    [self loadNext];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	if ([sender mainFrame] == frame)
    {
#ifdef DEBUG
        NSLog(@"%@", [NSThread currentThread]);
#endif
        currentIndex++;
		[self loadNext];
    }
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	if ([sender mainFrame] == frame)
	{
#ifdef DEBUG
        NSLog(@"%@", [NSThread currentThread]);
#endif
        currentIndex++;
		[self loadNext];
    }
}

- (id <ATWebIconLoaderDelegate> )delegate
{
#ifdef DEBUG
    NSLog(@"%@", [NSThread currentThread]);
#endif
    return delegate;
}

- (void)setDelegate:(id <ATWebIconLoaderDelegate> )aDelegate
{
#ifdef DEBUG
    NSLog(@"%@", [NSThread currentThread]);
#endif
    delegate = aDelegate;
}

@end
