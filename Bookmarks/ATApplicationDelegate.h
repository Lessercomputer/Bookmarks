/* ATApplicationDelegate */

#import <Cocoa/Cocoa.h>

@class ATNurserySpecifyingWindowController;

@interface ATApplicationDelegate : NSObject
{
    IBOutlet NSMenuItem *debugMenuItem;
    ATNurserySpecifyingWindowController *nurserySpecifyingWindowController;
}

- (IBAction)openBookmarksThroughNurseryAssociation:(id)sender;

#ifdef DEBUG
- (IBAction)logResponderChain:(id)sender;
- (IBAction)logCurrentFirstResponder:(id)sender;

- (void)logResponderChainOf:(NSWindow *)aWindow type:(NSString *)aType;
#endif

@end
