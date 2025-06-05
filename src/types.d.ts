interface Base {
  backgroundMode: boolean;
}

export interface NotificationMessageProps<T = any> extends Base {
  aps: {
    'alert': T;
    'content-available': number;
  };
  data: {
    pusher: {
      instanceId: string;
      publishId: string;
      userShouldIgnore: boolean;
    };
  };
}

export interface BackgroundMessageProps<T = any> extends Base {}
