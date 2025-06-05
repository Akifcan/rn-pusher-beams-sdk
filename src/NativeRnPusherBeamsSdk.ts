import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  stop(): boolean;
  clearAllState(): boolean;
  start(instanceId: string): boolean;
  registerForRemoteNotifications(): boolean;
  getInterests(): string[];
  setUserId(userId: string, url: string, token: string): boolean;
  clearDeviceInterests(): boolean;
  addDeviceInterest(interest: string): boolean;
  multiply(a: number, b: number): number;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RnPusherBeamsSdk');
