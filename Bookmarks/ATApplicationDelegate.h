/* ATApplicationDelegate */

#import <Cocoa/Cocoa.h>

@interface ATApplicationDelegate : NSObject
{
    IBOutlet NSMenuItem *debugMenuItem;
}

#ifdef DEBUG
- (IBAction)logResponderChain:(id)sender;
- (IBAction)logCurrentFirstResponder:(id)sender;

- (void)logResponderChainOf:(NSWindow *)aWindow type:(NSString *)aType;
#endif

@end
