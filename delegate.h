#pragma once
#import <AppKit/AppKit.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface Grid : NSView
@property (nonatomic, strong) NSArray<NSArray<NSView *> *> *grid;
@end

@interface MacErrDelegate : NSObject<NSApplicationDelegate, NSWindowDelegate>
@property(strong, nonatomic) NSWindow *mainWindow;
@property(strong, nonatomic) Grid *grid;
@property(strong, nonatomic) NSTextField *title;
@property(strong, nonatomic) NSTextField *details;
@property(strong, nonatomic) NSImageView *imageView;
@property(strong, nonatomic) NSTextField *button1;
@property(strong, nonatomic) NSTextField *button2;
@property(strong, nonatomic) NSTextField *button3;
@property(strong, nonatomic) NSButton    *showHelp;
@end
