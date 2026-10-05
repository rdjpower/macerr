#include "delegate.h"
#import <AppKit/AppKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@implementation MacErrDelegate

- (void)setupNSTextField:(NSTextField *)field :(NSString *)label {
    [field setBezeled:NO];
    [field setEditable:NO];
    [field setBordered:NO];
    [field setDrawsBackground:NO];
    [field setStringValue:[label stringByAppendingString:@": "]];
    [field setFont:[NSFont systemFontOfSize:18]];
    [field sizeToFit];
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp terminate:NULL];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [NSApp setPresentationOptions:NSApplicationPresentationDefault];
  NSWindow *win = [[NSWindow alloc]
      initWithContentRect:CGRectMake(0, 0, 10, 10)
                styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
                          NSWindowStyleMaskMiniaturizable
                  backing:NSBackingStoreBuffered
                    defer:NO];
  win.delegate = self;

  NSMenu *mainMenu = [[NSMenu alloc] init];
  NSMenuItem *mainMenuItem = [[NSMenuItem alloc] init];

  [mainMenu addItem:mainMenuItem];

  NSMenu *subMenu = [[NSMenu alloc] init];
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
  NSImage *defaultIcon = [[NSImage alloc] initWithSize:CGSizeMake(32, 32)];

  win.titleVisibility = NSWindowTitleHidden;
  win.titlebarAppearsTransparent = YES;

  NSTextField *title = [[NSTextField alloc] init];
  [self setupNSTextField:title:@"Title"];

  NSTextField *titleInput = [[NSTextField alloc] init];
  self.title = titleInput;

  NSTextField *details = [[NSTextField alloc] init];
  [self setupNSTextField:details:@"Details"];

  NSTextField *detailsInput = [[NSTextField alloc] init];
  self.details = detailsInput;

  NSTextField *imageLabel = [[NSTextField alloc] init];
  [self setupNSTextField:imageLabel:@"Current Icon (default is empty)"];

  NSImageView *imageView = [NSImageView imageViewWithImage:defaultIcon];
  [imageView setFrameSize:CGSizeMake(32, 32)];
  self.imageView = imageView;

  NSTextField *iconText = [[NSTextField alloc] init];
  [self setupNSTextField:iconText:@"Icon"];

  NSButton *openIcon = [[NSButton alloc] init];
  openIcon.title = @"Open File";
  [openIcon setAction:@selector(iconSet:)];

  NSTextField *button1 = [[NSTextField alloc] init];
  [self setupNSTextField:button1:@"Button 1 Text"];

  NSTextField *button1Input = [[NSTextField alloc] init];
  self.button1 = button1Input;

  NSTextField *button2 = [[NSTextField alloc] init];
  [self setupNSTextField:button2:@"Button 2 Text"];

  NSTextField *button2Input = [[NSTextField alloc] init];
  self.button2 = button2Input;

  NSTextField *button3 = [[NSTextField alloc] init];
  [self setupNSTextField:button3:@"Button 3 Text"];

  NSTextField *button3Input = [[NSTextField alloc] init];
  self.button3 = button3Input;

  NSTextField *showHelp = [[NSTextField alloc] init];
  [self setupNSTextField:showHelp:@"Show Help Button"];

  NSButton *showHelpButton = [[NSButton alloc] init];
  [showHelpButton setButtonType:NSButtonTypeSwitch];
  [showHelpButton setTitle:@""];
  self.showHelp = showHelpButton;

  NSButton *submit = [[NSButton alloc] init];
  [submit setTitle:@"Make Error"];
  [submit setAction:@selector(submit:)];
  [submit setKeyEquivalent:@"\r"];

  NSGridView *grid = [NSGridView gridViewWithViews:@[
    @[ title, titleInput ], @[ details, detailsInput ],
    @[ imageLabel, imageView ], @[ iconText, openIcon ],
    @[ button1, button1Input ], @[ button2, button2Input ],
    @[ button3, button3Input ], @[ showHelp, showHelpButton ],
    @[ submit ]
  ]];

  [win.contentView addSubview:grid];
  grid.translatesAutoresizingMaskIntoConstraints = NO;

  [NSLayoutConstraint activateConstraints:@[
    [grid.topAnchor constraintEqualToAnchor:win.contentView.topAnchor constant:10],
    [grid.leadingAnchor constraintEqualToAnchor:win.contentView.leadingAnchor constant:10],
    [grid.trailingAnchor constraintEqualToAnchor:win.contentView.trailingAnchor constant:-10],
    [grid.bottomAnchor constraintEqualToAnchor:win.contentView.bottomAnchor constant:-10]
  ]];

  [win makeKeyAndOrderFront:NULL];
  [win center];
}

- (void)submit:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
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
  NSOpenPanel *panel = [[NSOpenPanel alloc] init];
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

  NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
  self.imageView.image = image;
}

@end
