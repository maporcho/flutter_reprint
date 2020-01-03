#import "FlutterReprintPlugin.h"
#if __has_include(<flutter_reprint/flutter_reprint-Swift.h>)
#import <flutter_reprint/flutter_reprint-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_reprint-Swift.h"
#endif

@implementation FlutterReprintPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterReprintPlugin registerWithRegistrar:registrar];
}
@end
