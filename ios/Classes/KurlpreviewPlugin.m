#import "KurlpreviewPlugin.h"
#if __has_include(<kurlpreview/kurlpreview-Swift.h>)
#import <kurlpreview/kurlpreview-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "kurlpreview-Swift.h"
#endif

@implementation KurlpreviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKurlpreviewPlugin registerWithRegistrar:registrar];
}
@end
