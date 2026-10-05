#include <AppKit/AppKit.h>
#include "delegate.h"

int main(void) {
  @autoreleasepool {
    NSApplication *app = [NSApplication sharedApplication];
    MacErrDelegate* delegate = [[[MacErrDelegate alloc] init] autorelease];

    [app setDelegate:delegate];
    [app run];
  }
  return 0;
}
