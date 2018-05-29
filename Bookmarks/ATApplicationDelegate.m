#import "ATApplicationDelegate.h"
#import "ATNullBetweenNilTransformer.h"
#import "ATBrowser.h"
#import "ATNurserySpecifyingWindowController.h"
#import "ATDocumentController.h"

#ifndef DEBUG
static NSInteger ATDebugMenuItemTag = -1;
#endif

@implementation ATApplicationDelegate

void ATUncaughtExceptionHandler(NSException *anException)
{
    NSLog(@"Exception: %@", anException);
    NSLog(@"Stack Trace: %@", [anException callStackSymbols]);
    
    exit(EXIT_FAILURE);
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
    NSSetUncaughtExceptionHandler(&ATUncaughtExceptionHandler);
}

- (void)awakeFromNib
{
    [ATDocumentController new];
	[NSValueTransformer setValueTransformer:[[[ATNullBetweenNilTransformer alloc] init] autorelease]
                                forName:@"ATNullBetweenNilTransformer"];
    [ATBrowser installHookMethods];
    
#ifdef DEBUG
    NSMenu *aMainMenu = [[NSApplication sharedApplication] mainMenu];
    [aMainMenu addItem:debugMenuItem];
#endif
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	return NO;
}

-(void)openBookmarksUsingNurseryNetService:(id)sender
{
    if (!nurserySpecifyingWindowController)
        nurserySpecifyingWindowController = [ATNurserySpecifyingWindowController new];
    
    [nurserySpecifyingWindowController clear];
    
    [nurserySpecifyingWindowController showWindow:sender];
}

#ifdef DEBUG
- (IBAction)logResponderChain:(id)sender
{
	[self logResponderChainOf:[[NSApplication sharedApplication] keyWindow] type:@"keyWindow"];
	[self logResponderChainOf:[[NSApplication sharedApplication] mainWindow] type:@"mainWindow"];
}

- (void)logResponderChainOf:(NSWindow *)aWindow type:(NSString *)aType
{
	int anIndentLevel = 0;
	NSResponder *aResponder = [aWindow firstResponder];

	NSLog(@"%@ title is %@", aType, [aWindow title]);
	
	NSLog(@"%@'s firstResponder is %@", aType, aResponder);
	
	while ((aResponder = [aResponder nextResponder]))
	{
		NSMutableString *anIndent = [NSMutableString string];
		int i = 0;
		
		anIndentLevel++;
		
		for ( ; i < anIndentLevel ; i++)
			[anIndent appendString:@" "];
			
		NSLog(@"%@%@", anIndent, [aResponder description]);
	}
}

- (IBAction)logCurrentFirstResponder:(id)sender
{
	NSLog(@"currentFirstResponder is %@", [[NSApplication sharedApplication] targetForAction:@selector(openWindow:)]);
}

- (IBAction)raiseException:(id)sender
{
    NSArray *anArray = [@[] copy];
    id anObject = anArray[0];
    [anObject release];
}

#endif

@end
