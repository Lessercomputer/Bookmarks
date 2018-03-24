/* ATInspectorWindowController */

#import <Cocoa/Cocoa.h>

@class ATEditor;

@interface ATInspectorWindowController : NSWindowController
{
    IBOutlet id editorController;
    BOOL isMakingNewItem;
}

@end

@interface ATInspectorWindowController (Initializing)
+ (id)bookmarkInspectorWith:(ATEditor *)anEditor;
+ (id)folderInspectorWith:(ATEditor *)anEditor;

- (id)initWith:(ATEditor *)anEditor windowNibName:(NSString *)aName;
@end

@interface ATInspectorWindowController (Accessing)

- (ATEditor *)editor;

@end

@interface ATInspectorWindowController (Sheet)
- (void)beginSheetOn:(NSWindow *)aWindow;

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

@end

@interface ATInspectorWindowController (Actions)
- (IBAction)cancel:(id)sender;
- (IBAction)ok:(id)sender;
@end