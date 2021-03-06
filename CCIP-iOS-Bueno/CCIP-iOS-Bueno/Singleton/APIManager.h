//
//  APIManager.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attendee.h"
#import "ErrorMessage.h"
#import "Submission.h"
#import "Announcement.h"
#import <OneSignal/OneSignal.h>
@protocol APIManagerDelegate <NSObject>
@optional
- (void)tokenHaveChangedWithAttendee:(Attendee*)attendee;
@optional
- (void)attendeeStatusChange:(Attendee*)attendee;

@end

@interface APIManager : NSObject

+ (_Nonnull instancetype)sharedManager;

@property (strong, nonatomic) NSMutableArray *delegates;

- (void)requestAttendeeStatusWithToken:(NSString* _Nonnull)token Completion:(void (^ _Nullable)(Attendee* _Nonnull attendee))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull message))failure;

- (BOOL)haveAccessToken;
- (void)setAccessToken:(NSString * _Null_unspecified)accessToken Completion:(void (^ _Nullable)(Attendee* _Nonnull attendee))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull errorMessage))failure;
- (void)resetAccessToken;
- (NSString * _Null_unspecified)accessToken;

- (Attendee * _Null_unspecified)getAttendee;
- (void)reloadSubmissions;
- (void)reloadAnnouncement;

- (void)useScenarioWithScenrio:(Scenario*)scenario Completion:(void (^ _Nullable)(Scenario* _Nonnull scenario))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull errorMessage))failure;

- (void)requestSubmissionWithCompletion:(void (^ _Nullable)(NSArray* _Nonnull submissions))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull errorMessage))failure;

- (void)requestAnnouncementWithCompletion:(void (^ _Nullable)(NSArray* _Nonnull announcements))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull errorMessage))failure;

- (void)requestScenariosWithCompletion:(void (^ _Nullable)(NSArray* _Nonnull scenarios))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull errorMessage))failure;

- (NSArray *)availableScenarios;

@end
