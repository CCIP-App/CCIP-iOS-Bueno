//
//  NotificationManager.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/2.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "NotificationManager.h"

@interface NotificationManager()

@property (strong, nonatomic) UNUserNotificationCenter* notificationCenter;
@property void (^receiveNotificationSettings)(UNNotificationSettings * _Nonnull settings);

@end

@implementation NotificationManager

+ (instancetype)sharedManager {
    static NotificationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        self.notificationCenter.delegate = self;
    }
    return self;
}

- (void)setupBlocks {
    self.receiveNotificationSettings = ^(UNNotificationSettings * _Nonnull settings) {
        
    };
}

- (void)requestNotificationAuthorizationWithCompletion:(void (^)())completion {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if(settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                completion();
            }];
        } else {
            completion();
        }
    }];
}

- (void)registerNotificationWithTitle:(NSString *)title Body:(NSString *)body Identifier:(NSString *)identifier FireDate:(NSDate *)date Completion:(void (^)())completion {
    [self requestNotificationAuthorizationWithCompletion:^{
        UNMutableNotificationContent* notificationContent = [UNMutableNotificationContent new];
        notificationContent.title = title;
        notificationContent.body = body;
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
        //NSDateComponents* fireDate = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMonth|NSCalendarUnitMinute) fromDate:date];
        
        // demo test, after 10 secound
        NSDateComponents* fireDate = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMonth|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        
        UNCalendarNotificationTrigger* notificationTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:fireDate repeats:NO];
        
        notificationContent.sound = [UNNotificationSound defaultSound];
        
        UNNotificationRequest* notificationRequest = [UNNotificationRequest requestWithIdentifier:identifier content:notificationContent trigger:notificationTrigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:nil];
        completion();
    }];
}

- (void)removeNotificationWithIdentifier:(NSString*)identifier {
    [self.notificationCenter removeDeliveredNotificationsWithIdentifiers:@[identifier]];
    [self.notificationCenter removePendingNotificationRequestsWithIdentifiers:@[identifier]];
}

- (void)haveRegistedLocalNotificationWithIdentifier:(NSString*)identifier Completion:(void (^ _Nullable)(BOOL result))completion {
    [self.notificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        for(UNNotificationRequest* request in requests) {
            if([request.identifier isEqualToString:identifier]) {
                completion(YES);
                return;
            }
        }
        completion(NO);
    }];
}

@end
