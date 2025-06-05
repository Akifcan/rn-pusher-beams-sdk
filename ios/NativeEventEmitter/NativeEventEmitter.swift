//
//  RNEventEmitter.swift
//  LogistivoMobile
//
//  Created by logistivo1 on 30.05.2025.
//

import Foundation
import React

@objc(NativeEventEmitter)
open class NativeEventEmitter:RCTEventEmitter{

  public static var emitter: RCTEventEmitter! // global variable
  private static var lastNotification: [AnyHashable: Any]? = nil
  private static var isJSReady = false

  // constructor
  override init(){
    super.init()
    NativeEventEmitter.emitter = self
  }

  open override func supportedEvents() -> [String] {
    ["message"]  // etc.
  }
  
  @objc public static func send(_ name: String, body: Any) {
    if isJSReady {
      NativeEventEmitter.emitter?.sendEvent(withName: name, body: body)
    } else {
      lastNotification = body as? [AnyHashable: Any]
    }
  }
  
  @objc public func markJSReady() {
    NativeEventEmitter.isJSReady = true
      if let pendingData = NativeEventEmitter.lastNotification {
        NativeEventEmitter.emitter?.sendEvent(withName: "message", body: pendingData)
        NativeEventEmitter.lastNotification = nil
      }
    }
}
