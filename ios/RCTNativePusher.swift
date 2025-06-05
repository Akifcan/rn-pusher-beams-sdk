import Foundation
import PushNotifications

@objc(RCTNativePusherBeamsImpl)
open class RCTNativePusherBeamsImpl:NSObject{
  
  let beamsClient = PushNotifications.shared

  @objc public func start(instanceId: String) -> NSNumber {
    self.beamsClient.start(instanceId: instanceId)
    return 1
  }

  @objc public func registerForRemoteNotifictions() -> NSNumber {
    self.beamsClient.registerForRemoteNotifications()
    return 1
  }

  @objc public func stop() -> NSNumber {
    beamsClient.stop {}
    return 1
  }

  @objc public func addDeviceInterest(_ interest: String) -> NSNumber {
    try? self.beamsClient.addDeviceInterest(interest: interest)
    return 1
  }

  @objc public func clearDeviceInterests() -> NSNumber {
    try? self.beamsClient.clearDeviceInterests()
    return 1
  }

  @objc public func clearAllState() -> NSNumber {
    beamsClient.clearAllState {}
    return 1
  }

  @objc public func getDeviceInterests() -> [String]? {
    return self.beamsClient.getDeviceInterests()
  }

  @objc public func setUserId(_ userId: String, url: String, token: String) -> NSNumber {
    let tokenProvider = BeamsTokenProvider(authURL: url) {
      let headers = ["Authorization": "Bearer \(token)"]
      let queryParams: [String: String] = [:]
      return AuthData(headers: headers, queryParams: queryParams)
    }

    self.beamsClient.setUserId(userId, tokenProvider: tokenProvider) { error in
      if let error = error {
        print("Failed to authenticate: \(error.localizedDescription)")
      } else {
        print("Successfully authenticated with Pusher Beams")
      }
    }

    return 1
  }
}
