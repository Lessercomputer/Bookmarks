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
    
	return self;
}

- (void)dealloc
{
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
	inCancel = YES;
	[webView stopLoading:nil];
    [webView setFrameLoadDelegate:nil];
	inCancel = NO;
}

- (void)loadNext
{
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
        [urlToFaviconDictionary setObject:image forKey:[sender mainFrameURL]];
		[self setCurrentIconImage:image forURL:[sender mainFrameURL]];
	}
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)aTitle forFrame:(WebFrame *)frame
{
	if ([sender mainFrame] == frame)
	{
		[self setTitle:aTitle];
	}
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	if ([sender mainFrame] == frame)
	{
        [self performSelector:@selector(pageLoadFinished:) withObject:nil afterDelay:0.5];
	}
}

- (void)pageLoadFinished:(id)sender
{
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
        currentIndex++;
		[self loadNext];
    }
}

- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	if ([sender mainFrame] == frame)
	{
        currentIndex++;
		[self loadNext];
    }
}

- (id <ATWebIconLoaderDelegate> )delegate
{
    return delegate;
}

- (void)setDelegate:(id <ATWebIconLoaderDelegate> )aDelegate
{
    delegate = aDelegate;
}

@end
