//
//  NotificationManager.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/2.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface NotificationManager : NSObject<UNUserNotificationCenterDelegate>

+ (_Nonnull instancetype)sharedManager;

- (void)registerNotificationWithTitle:(NSString*)title Body:(NSString*)string Identifier:(NSString*)identifier FireDate:(NSDate*)date Completion:(void (^ _Nullable)())completion;
- (void)removeNotificationWithIdentifier:(NSString*)identifier;
- (void)haveRegistedLocalNotificationWithIdentifier:(NSString*)identifier Completion:(void (^ _Nullable)(BOOL result))completion;
@end
