#import "RnPusherBeamsSdk.h"
#import "RnPusherBeamsSdk-Swift.h"

@implementation RnPusherBeamsSdk
RCT_EXPORT_MODULE()

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRnPusherBeamsSdkSpecJSI>(params);
}

RCTNativePusherBeamsImpl *nativepusherbeamsimpl = [[RCTNativePusherBeamsImpl alloc] init];


- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);

    return result;
}

- (nonnull NSNumber *)addDeviceInterest:(nonnull NSString *)interest {
  return [nativepusherbeamsimpl addDeviceInterest:interest];
}

- (nonnull NSNumber *)clearAllState {
  return [nativepusherbeamsimpl clearAllState];
}

- (nonnull NSNumber *)clearDeviceInterests {
  return [nativepusherbeamsimpl clearDeviceInterests];
}

- (nonnull NSNumber *)start:(nonnull NSString *)instanceId {
  return [nativepusherbeamsimpl startWithInstanceId:instanceId];
}

- (nonnull NSNumber *)stop {
  return [nativepusherbeamsimpl stop];
}

- (nonnull NSNumber *)setUserId:(nonnull NSString *)userId url:(nonnull NSString *)url token:(nonnull NSString *)token {
  return [nativepusherbeamsimpl setUserId:userId url:url token:token];
}

- (nonnull NSNumber *)registerForRemoteNotifications {
  return [nativepusherbeamsimpl registerForRemoteNotifictions];
}

- (nonnull NSArray<NSString *> *)getInterests {
  return [nativepusherbeamsimpl getDeviceInterests];
}

@end
