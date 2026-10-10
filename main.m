#include <AppKit/AppKit.h>
#include "delegate.h"
#include <objc/runtime.h>
#include <objc/message.h>

int main(void) {
  @autoreleasepool {
    NSApplication *app = [NSApplication sharedApplication];
    MacErrDelegate* delegate = [[((MacErrDelegate *)(((id (*)(id, SEL))objc_msgSend)(
        objc_getClass("MacErrDelegate"), sel_registerName("alloc")))) init] autorelease];

    [app setDelegate:delegate];
    [app run];
  }
  return 0;
}
