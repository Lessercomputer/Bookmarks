/* ATApplicationDelegate */

#import <Cocoa/Cocoa.h>

@interface ATApplicationDelegate : NSObject
{
}

#ifdef DEBUG
- (IBAction)logResponderChain:(id)sender;
- (IBAction)logCurrentFirstResponder:(id)sender;

- (void)logResponderChainOf:(NSWindow *)aWindow type:(NSString *)aType;
#endif

@end
