import RnPusherBeamsSdk from './NativeRnPusherBeamsSdk';
import { NativeModules, NativeEventEmitter } from 'react-native';
import type { NotificationMessageProps, BackgroundMessageProps } from './types';
const eventEmitter = new NativeEventEmitter(NativeModules.NativeEventEmitter);

export function multiply(a: number, b: number): number {
  return RnPusherBeamsSdk.multiply(a, b);
}

export type NotificationMessage = NotificationMessageProps;
export type BackgroundMessage = BackgroundMessageProps;

export const pusherBeams = {
  start: (instanceId: string) => {
    return RnPusherBeamsSdk.start(instanceId);
  },
  registerForRemoteNotifications: () => {
    return RnPusherBeamsSdk.registerForRemoteNotifications();
  },
  setUserId: (id: string, url: string, authorizationToken: string) => {
    return RnPusherBeamsSdk.setUserId(id, url, authorizationToken);
  },
  addDeviceInterests: (interest: string) => {
    return RnPusherBeamsSdk.addDeviceInterest(interest);
  },
  clearDeviceInterests: () => {
    return RnPusherBeamsSdk.clearDeviceInterests();
  },
  getInterests: () => {
    return RnPusherBeamsSdk.getInterests();
  },
  clearAllState: () => {
    return RnPusherBeamsSdk.clearAllState();
  },
  stop: () => {
    return RnPusherBeamsSdk.stop();
  },
  listenNotificationLogs: () => {
    setTimeout(() => {
      NativeModules.NativeEventEmitter.markJSReady();
    }, 500);
  },
  onNotification: (cb: (message: any) => void) => {
    return eventEmitter.addListener('message', (message: any) => {
      cb(message);
    });
  },
};
