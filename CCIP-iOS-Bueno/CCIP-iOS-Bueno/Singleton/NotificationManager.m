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
        [[[APIManager sharedManager] delegates] addObject:self];
    }
    return self;
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
        NSDateComponents* fireDate = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMonth|NSCalendarUnitMinute) fromDate:date];
        
        // demo test, after 10 secound
        //NSDateComponents* fireDate = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMonth|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:[NSDate dateWithTimeIntervalSinceNow:3]];
        
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

- (void)tokenHaveChangedWithAttendee:(Attendee *)attendee {
    if(attendee) {
        NSDictionary *options = @{
                                  kCRToastTextKey : NSLocalizedString(@"Welocme", nil) ,
                                  kCRToastSubtitleTextKey : attendee.userId ,
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor colorWithRed:2.0/255 green:35.0/255 blue:77.0/255 alpha:1],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                  kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                  kCRToastFontKey: [UIFont fontWithName:@"NotoSans-Bold" size:17],
                                  kCRToastSubtitleFontKey: [UIFont fontWithName:@"NotoSans" size:17],
                                  kCRToastTimeIntervalKey: @(1),
                                  kCRToastAnimationInTimeIntervalKey: @(0.25),
                                  kCRToastAnimationOutTimeIntervalKey: @(0.25),
                                  };
        [CRToastManager showNotificationWithOptions:options completionBlock:nil];
    }
}

- (void)showNotificationMessage:(NSString*)title Subtitle:(NSString*)subtitle {
    NSDictionary *options = @{
                              kCRToastTextKey : title ?title:@"",
                              kCRToastSubtitleTextKey : subtitle ?subtitle:@"" ,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor colorWithRed:2.0/255 green:35.0/255 blue:77.0/255 alpha:1],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationTypeKey : @(CRToastTypeCustom),
                              kCRToastFontKey: [UIFont fontWithName:@"NotoSans-Bold" size:17],
                              kCRToastSubtitleFontKey: [UIFont fontWithName:@"NotoSans" size:17],
                              kCRToastTimeIntervalKey: @(5),
                              kCRToastAnimationInTimeIntervalKey: @(0.25),
                              kCRToastAnimationOutTimeIntervalKey: @(0.25),
                              kCRToastNotificationPreferredHeightKey: @(104),
                              };
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];
}

- (void)showErrorAlert:(NSString*)title Subtitle:(NSString*)subtitle {
    NSDictionary *options = @{
                              kCRToastTextKey : title ?title:@"" ,
                              kCRToastSubtitleTextKey : subtitle ?subtitle:@"",
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : [UIColor redColor],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastFontKey: [UIFont fontWithName:@"NotoSans-Bold" size:17],
                              kCRToastSubtitleFontKey: [UIFont fontWithName:@"NotoSans" size:17],
                              kCRToastTimeIntervalKey: @(1),
                              kCRToastAnimationInTimeIntervalKey: @(0.25),
                              kCRToastAnimationOutTimeIntervalKey: @(0.25),
                              };
    [CRToastManager showNotificationWithOptions:options completionBlock:nil];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    [self showNotificationMessage:notification.request.content.title Subtitle:notification.request.content.body];
}

@end
