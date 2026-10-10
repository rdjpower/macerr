#include "delegate.h"
#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#include <objc/runtime.h>
#include <objc/message.h>

#define alloc_object(type) ((type *)((((id (*)(id, SEL))objc_msgSend)(objc_getClass(#type), sel_registerName("alloc")))))

@implementation Grid
- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self == NULL)
    return self;
  self.grid = @[];
  return self;
}

- (BOOL)isFlipped {
  return YES;
}

- (void)loadItems {
  NSInteger yPos = 20;

  for (int y = 0; y < self.grid.count; y++) {
    NSInteger maxSize = 0;
    NSInteger xPos = 10;

    for (int x = 0; x < [self.grid objectAtIndex:y].count; x++) {
      NSView *view = [[self.grid objectAtIndex:y] objectAtIndex:x];
      NSSize contentSize = view.frame.size;

      if ([view isKindOfClass:NSControl.class] && view.class != NSImageView.class) {
        NSControl *control = (NSControl *)view;
        contentSize = control.cell.cellSize;
      }

      if (view.class == NSTextField.class && ((NSTextField *)view).editable) {
        contentSize.width = 100;
      }

      if (contentSize.height > maxSize)
        maxSize = contentSize.height;

      [view setFrame:NSMakeRect(xPos, yPos-contentSize.height/2, contentSize.width,
                                contentSize.height)];

      xPos += contentSize.width + 10;
    }

    yPos += maxSize + 10;
  }
}

- (void)layout {
    [self loadItems];
}
@end

@implementation MacErrDelegate

- (void)setupNSTextField:(NSTextField *)field :(NSString *)label {
    [field setBezeled:NO];
    [field setEditable:NO];
    [field setBordered:NO];
    [field setDrawsBackground:NO];
    [field setStringValue:[label stringByAppendingString:@": "]];
    [field setFont:[NSFont systemFontOfSize:18]];
    [field sizeToFit];

    field.cell.wraps = NO;
    field.cell.usesSingleLineMode = YES;
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp terminate:NULL];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [NSApp setPresentationOptions:NSApplicationPresentationDefault];
  NSWindow *win = [alloc_object(NSWindow)
      initWithContentRect:CGRectMake(0, 0, 500, 500)
                styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
                          NSWindowStyleMaskMiniaturizable
                  backing:NSBackingStoreBuffered
                    defer:NO];
  win.delegate = self;

  NSMenu *mainMenu = [alloc_object(NSMenu) init];
  NSMenuItem *mainMenuItem = [alloc_object(NSMenuItem) init];

  [mainMenu addItem:mainMenuItem];

  NSMenu *subMenu = [alloc_object(NSMenu) init];
  mainMenuItem.submenu = subMenu;

  NSString *name = NSProcessInfo.processInfo.processName;

  [subMenu addItemWithTitle:[@"About " stringByAppendingString:name]
                     action:@selector(orderFrontStandardAboutPanel:)
              keyEquivalent:@""];

  [subMenu addItemWithTitle:[@"Quit " stringByAppendingString:name]
                     action:@selector(terminate:)
              keyEquivalent:@"q"];

  NSApp.mainMenu = mainMenu;

  self.mainWindow = win;
  NSImage *defaultIcon = [alloc_object(NSImage) initWithSize:CGSizeMake(32, 32)];

  if (@available(macOS 10.12, *)) {
      win.titleVisibility = NSWindowTitleHidden;
      win.titlebarAppearsTransparent = YES;
  }

  NSTextField *title = [alloc_object(NSTextField) init];
  [self setupNSTextField:title:@"Title"];

  NSTextField *titleInput = [alloc_object(NSTextField) init];

  self.title = titleInput;

  NSTextField *details = [alloc_object(NSTextField) init];
  [self setupNSTextField:details:@"Details"];

  NSTextField *detailsInput = [alloc_object(NSTextField) init];
  self.details = detailsInput;

  NSTextField *imageLabel = [alloc_object(NSTextField) init];
  [self setupNSTextField:imageLabel:@"Current Icon (default is empty)"];

  NSImageView *imageView = [alloc_object(NSImageView) initWithFrame:NSMakeRect(0, 0, 32, 32)];
  [imageView setImageScaling:NSImageScaleProportionallyDown];
  [imageView setImageAlignment:NSImageAlignCenter];
  [imageView setEditable:NO];
  [imageView setAutoresizingMask:NSViewNotSizable | NSViewMaxXMargin | NSViewMaxYMargin];
  self.imageView = imageView;

  NSTextField *iconText = [alloc_object(NSTextField) init];
  [self setupNSTextField:iconText:@"Icon"];

  NSButton *openIcon = [alloc_object(NSButton) init];
  openIcon.title = @"Open File";
  [openIcon setAction:@selector(iconSet:)];

  NSTextField *button1 = [alloc_object(NSTextField) init];
  [self setupNSTextField:button1:@"Button 1 Text"];

  NSTextField *button1Input = [alloc_object(NSTextField) init];
  self.button1 = button1Input;

  NSTextField *button2 = [alloc_object(NSTextField) init];
  [self setupNSTextField:button2:@"Button 2 Text"];

  NSTextField *button2Input = [alloc_object(NSTextField) init];
  self.button2 = button2Input;

  NSTextField *button3 = [alloc_object(NSTextField) init];
  [self setupNSTextField:button3:@"Button 3 Text"];

  NSTextField *button3Input = [alloc_object(NSTextField) init];
  self.button3 = button3Input;

  NSTextField *showHelp = [alloc_object(NSTextField) init];
  [self setupNSTextField:showHelp:@"Show Help Button"];

  NSButton *showHelpButton = [alloc_object(NSButton) init];
  [showHelpButton setButtonType:NSButtonTypeSwitch];
  [showHelpButton setTitle:@""];
  self.showHelp = showHelpButton;

  NSButton *submit = [alloc_object(NSButton) init];
  [submit setTitle:@"Make Error"];
  [submit setAction:@selector(submit:)];
  [submit setKeyEquivalent:@"\r"];

  Grid *grid = [alloc_object(Grid) initWithFrame:NSMakeRect(0, 0, 500, 500)];
  self.grid = grid;

  [grid addSubview:title];
  [grid addSubview:titleInput];
  [grid addSubview:details];
  [grid addSubview:detailsInput];
  [grid addSubview:imageLabel];
  [grid addSubview:imageView];
  [grid addSubview:iconText];
  [grid addSubview:openIcon];
  [grid addSubview:button1];
  [grid addSubview:button1Input];
  [grid addSubview:button2];
  [grid addSubview:button2Input];
  [grid addSubview:button3];
  [grid addSubview:button3Input];
  [grid addSubview:showHelp];
  [grid addSubview:showHelpButton];
  [grid addSubview:submit];

  grid.grid = [alloc_object(NSArray) initWithArray:@[
    @[ title, titleInput ], @[ details, detailsInput ],
    @[ imageLabel, imageView ], @[ iconText, openIcon ],
    @[ button1, button1Input ], @[ button2, button2Input ],
    @[ button3, button3Input ], @[ showHelp, showHelpButton ], @[ submit ]
  ]];

  [titleInput sizeToFit];
  [detailsInput sizeToFit];
  [button1Input sizeToFit];
  [button2Input sizeToFit];
  [button3Input sizeToFit];
  [openIcon sizeToFit];
  [showHelpButton sizeToFit];
  [submit sizeToFit];

  grid.frame = win.contentView.bounds;
  grid.autoresizingMask = NSViewMaxXMargin | NSViewMaxYMargin;
  [win.contentView addSubview:grid];

  [win makeKeyAndOrderFront:NULL];
  [win center];

  [grid loadItems];
}

- (void)submit:(id)sender {
  NSAlert *alert = [alloc_object(NSAlert) init];
  alert.messageText = self.title.stringValue;
  alert.informativeText = self.details.stringValue;
  alert.icon = self.imageView.image;

  if (self.button1.stringValue.length != 0) {
      [alert addButtonWithTitle:self.button1.stringValue];
  }

  if (self.button2.stringValue.length != 0) {
      [alert addButtonWithTitle:self.button2.stringValue];
  }

  if (self.button3.stringValue.length != 0) {
      [alert addButtonWithTitle:self.button3.stringValue];
  }

  alert.showsHelp = self.showHelp.state;
  [alert runModal];
}

- (void)iconSet:(id)sender {
  NSOpenPanel *panel = [alloc_object(NSOpenPanel) init];
  panel.title = @"Open Alert Icon";
  panel.canChooseFiles = YES;
  panel.allowsMultipleSelection = NO;

  if (!@available(macOS 11.0, *)) {
      panel.allowedFileTypes = NSImage.imageTypes;
  } else {
      panel.allowedContentTypes = @[UTTypeImage];
  }

  [panel runModal];

  NSURL *url = panel.URL;
  if (url == NULL)
    return;

  NSImage *image = [alloc_object(NSImage) initWithContentsOfURL:url];
  self.imageView.image = image;
}

@end
