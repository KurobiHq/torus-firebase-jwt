#import "TorusFirebaseJwtPlugin.h"
#if __has_include(<torus_firebase_jwt/torus_firebase_jwt-Swift.h>)
#import <torus_firebase_jwt/torus_firebase_jwt-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "torus_firebase_jwt-Swift.h"
#endif

@implementation TorusFirebaseJwtPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTorusFirebaseJwtPlugin registerWithRegistrar:registrar];
}
@end
