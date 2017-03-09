//
//  APIManager.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "APIManager.h"
#import "FileManager.h"
#import "RestKit.h"
#import <UICKeyChainStore/UICKeyChainStore.h>
#import "NotificationManager.h"
#import "FileManager.h"
#import "Announcement.h"
@interface APIManager()

@property (nonatomic) NSDictionary* config;
@property (nonatomic) RKObjectMapping* attendeeMapping;
@property (nonatomic) RKObjectMapping* messageMapping;
@property (nonatomic) RKObjectMapping* submissionMapping;
@property (nonatomic) RKObjectMapping* announcementMapping;

@property (nonatomic, strong) Attendee* attendee;
@property (strong, nonatomic) RKObjectManager* sitconWebPageManager;
@property (strong, nonatomic) RKObjectManager* ccipAPIManager;
@property (strong, nonatomic) NSArray* submissions;
@property (nonatomic) NSArray* announcements;

@end

@implementation APIManager

+ (instancetype)sharedManager {
    static APIManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)setAttendee:(Attendee *)attendee {
    _attendee = attendee;
    for (id<APIManagerDelegate> delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(attendeeStatusChange:)])
            [delegate attendeeStatusChange:self.attendee];
    }
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.config = [[FileManager sharedManager] getConfig];
        [self configureObjectManager];
        [self configureObjectMappings];
        [self configureResponseDescriptors];
        self.delegates = [NSMutableArray new];
    }
    return self;
}

- (void)configureObjectManager {
    NSURL* baseUrl = [NSURL URLWithString:[self.config objectForKey:@"BaseUrl"]];
    self.ccipAPIManager = [RKObjectManager managerWithBaseURL:baseUrl];
    self.sitconWebPageManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://sitcon.org"]];
}

- (void)configureObjectMappings {
    RKObjectMapping* scenarioMapping = [RKObjectMapping mappingForClass:[Scenario class]];
    [scenarioMapping addAttributeMappingsFromDictionary:@{
                                                          @"id": @"scenarioId",
                                                          @"disabled": @"disabled",
                                                          @"countdown": @"countdown",
                                                          @"used": @"used",
                                                          @"expire_time": @"expireTime",
                                                          @"available_time": @"availableTime",
                                                          @"attr": @"attr",
                                                          @"order": @"order",
                                                          @"type": @"type"
                                                          }];
    RKObjectMapping* displayMapping = [RKObjectMapping mappingForClass:[DisplayText class]];
    [displayMapping addAttributeMappingsFromDictionary:@{
                                                         @"en-US": @"en",
                                                         @"zh-TW": @"zh"
                                                         }];
    [scenarioMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"display_text" toKeyPath:@"display" withMapping:displayMapping]];
    self.attendeeMapping = [RKObjectMapping mappingForClass:[Attendee class]];
    [self.attendeeMapping addAttributeMappingsFromDictionary:@{
                                                          @"token": @"token",
                                                          @"user_id": @"userId",
                                                          @"attr": @"attr",
                                                          @"status": @"status",
                                                          @"type": @"type"
                                                          }];
    [self.attendeeMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"scenarios" toKeyPath:@"scenarios" withMapping:scenarioMapping]];
    self.messageMapping = [RKObjectMapping mappingForClass:[ErrorMessage class]];
    [self.messageMapping addAttributeMappingsFromDictionary:@{
                                                              @"message": @"message"
                                                              }];
    
    RKObjectMapping* speakerMapping = [RKObjectMapping mappingForClass:[Speaker class]];
    [speakerMapping addAttributeMappingsFromDictionary:@{
                                                         @"name": @"name",
                                                         @"avatar": @"avatar",
                                                         @"bio": @"bio"
                                                         }];
    self.submissionMapping = [RKObjectMapping mappingForClass:[Submission class]];
    [self.submissionMapping addAttributeMappingsFromDictionary:@{
                                                                 @"start": @"start",
                                                                 @"end": @"end",
                                                                 @"type": @"type",
                                                                 @"room": @"room",
                                                                 @"subject": @"subject",
                                                                 @"summary": @"summary"
                                                                 }];
    [self.submissionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"speaker" toKeyPath:@"speaker" withMapping:speakerMapping]];
    
    self.announcementMapping = [RKObjectMapping mappingForClass:[Announcement class]];
    [self.announcementMapping addAttributeMappingsFromDictionary:@{
                                                                  @"msg_en": @"msg",
                                                                  @"datetime": @"datetime",
                                                                  @"uri": @"uri"
                                                                  }];
    
}

- (void)configureResponseDescriptors {
    RKResponseDescriptor* attendeeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.attendeeMapping method:RKRequestMethodGET pathPattern:@"/status" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    RKResponseDescriptor* errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.messageMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    RKResponseDescriptor* submissionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.submissionMapping method:RKRequestMethodGET pathPattern:@"/2017/submissions.json" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    RKResponseDescriptor* announcementResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.announcementMapping method:RKRequestMethodGET pathPattern:@"/announcement" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    RKResponseDescriptor* scenarioResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.attendeeMapping method:RKRequestMethodGET pathPattern:@"/use/:scenarioId" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [self.ccipAPIManager addResponseDescriptor:scenarioResponseDescriptor];
    [self.ccipAPIManager addResponseDescriptor:attendeeResponseDescriptor];
    [self.ccipAPIManager addResponseDescriptor:errorResponseDescriptor];
    [self.sitconWebPageManager addResponseDescriptor:submissionResponseDescriptor];
    [self.ccipAPIManager addResponseDescriptor:announcementResponseDescriptor];
}

- (void)requestAttendeeStatusWithToken:(NSString*)token Completion:(void (^)(Attendee* attendee))completion Failure:(void (^)(ErrorMessage *))failure{
    [self.ccipAPIManager getObject:nil path:@"/status" parameters:@{@"token": token} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        self.attendee = (Attendee*)[mappingResult firstObject];
        completion((Attendee*)[mappingResult firstObject]);
        
    } failure:^(RKObjectRequestOperation *operation,NSError* error) {
        if([error code] == 1004) {
            ErrorMessage* errorMessage = (ErrorMessage*)[[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
            errorMessage.title = NSLocalizedString(@"token error", nil);
            failure(errorMessage);
        } else if ([[[operation HTTPRequestOperation] response] statusCode] == 403){
            ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
            errorMessage.title = @"";
            errorMessage.message = [error localizedDescription];
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Network Error", nil) Subtitle:NSLocalizedString(@"Please Use Wifi", nil)];
            if(failure)
                failure(errorMessage);
        } else {
            ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
            errorMessage.title = @"";
            errorMessage.message = [error localizedDescription];
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Network Error", nil) Subtitle:[error localizedDescription]];
            if(failure)
                failure(errorMessage);
        }
    }];
}


- (BOOL)haveAccessToken {
    return ([[self accessToken] length] > 0) ? YES : NO;
}

- (void)setAccessToken:(NSString *)accessToken {
    [UICKeyChainStore removeItemForKey:@"token"];
    [UICKeyChainStore setString:accessToken
                         forKey:@"token"];
}

- (void)setAccessToken:(NSString *)accessToken Completion:(void (^)(Attendee *))completion Failure:(void (^)(ErrorMessage *))failure {
    [self requestAttendeeStatusWithToken:accessToken Completion:^(Attendee *attendee) {
        [self setAccessToken:accessToken];
        [OneSignal sendTags:@{@"token":accessToken, @"type": attendee.type}];
        self.attendee = attendee;
        for (id<APIManagerDelegate> delegate in self.delegates) {
            if([delegate respondsToSelector:@selector(tokenHaveChangedWithAttendee:)])
                [delegate tokenHaveChangedWithAttendee:attendee];
        }
        
        completion(attendee);
    } Failure:^(ErrorMessage *errorMessage) {
        failure(errorMessage);
    }];
}

- (void)resetAccessToken {
    self.attendee = nil;
    [UICKeyChainStore setString:@""
                         forKey:@"token"];
    [OneSignal sendTags:@{@"token":@""}];
    for (id<APIManagerDelegate> delegate in self.delegates) {
        if([delegate respondsToSelector:@selector(tokenHaveChangedWithAttendee:)])
        [delegate tokenHaveChangedWithAttendee:nil];
    }
}

- (NSString *)accessToken {
    return [UICKeyChainStore stringForKey:@"token"];
}

- (Attendee *)getAttendee {
    if(self.attendee)
        return self.attendee;
    else
        return NULL;
}

- (void)reloadSubmissions {
    self.submissions = NULL;
    [[FileManager sharedManager] cleanSubmissions];
}

- (void)requestSubmissionWithCompletion:(void (^ _Nullable)(NSArray* _Nonnull submissions))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull errorMessage))failure {
    if(self.submissions) {
        completion(self.submissions);
        return;
    }
    self.submissions = [[FileManager sharedManager] getSubmissions];
    if(self.submissions) {
        completion(self.submissions);
        return;
    }
    
    [self.sitconWebPageManager getObject:nil path:@"/2017/submissions.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.submissions = [mappingResult array];
        [[FileManager sharedManager] saveSubmissions:self.submissions];
        if(completion != NULL)
            completion([mappingResult array]);
        
    } failure:^(RKObjectRequestOperation *operation,NSError* error) {
        if([error code] == 1004) {
            ErrorMessage* errorMessage = (ErrorMessage*)[[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
            errorMessage.title = @"token error";
            failure(errorMessage);
        } else if ([[[operation HTTPRequestOperation] response] statusCode] == 403){
            ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
            errorMessage.title = @"";
            errorMessage.message = [error localizedDescription];
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Network Error", nil) Subtitle:NSLocalizedString(@"Please Use Wifi", nil)];
            if(failure)
                failure(errorMessage);
        } else {
            ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
            errorMessage.title = @"";
            errorMessage.message = [error localizedDescription];
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Network Error", nil) Subtitle:[error localizedDescription]];
            if(failure)
                failure(errorMessage);
        }

    }];
}

- (void)requestAnnouncementWithCompletion:(void (^ _Nullable)(NSArray* _Nonnull announcemnets))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull errorMessage))failure {
    if(self.announcements) {
        completion(self.announcements);
        return;
    }
    
    [self.ccipAPIManager getObject:nil path:@"/announcement" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.announcements = [mappingResult array];
        if(completion != NULL)
            completion([mappingResult array]);
        
    } failure:^(RKObjectRequestOperation *operation,NSError* error) {
        if([error code] == 1004) {
            ErrorMessage* errorMessage = (ErrorMessage*)[[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
            errorMessage.title = @"token error";
            failure(errorMessage);
        } else if ([[[operation HTTPRequestOperation] response] statusCode] == 403){
            ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
            errorMessage.title = @"";
            errorMessage.message = [error localizedDescription];
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Network Error", nil) Subtitle:NSLocalizedString(@"Please Use Wifi", nil)];
            if(failure)
                failure(errorMessage);
        } else {
            ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
            errorMessage.title = @"";
            errorMessage.message = [error localizedDescription];
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Network Error", nil) Subtitle:[error localizedDescription]];
            if(failure)
                failure(errorMessage);
        }
    }];
}

- (void)requestScenariosWithCompletion:(void (^ _Nullable)(NSArray* _Nonnull scenarios))completion Failure:(void (^ _Nullable)(ErrorMessage* _Nonnull errorMessage))failure {
    if (self.attendee) {
        completion(self.attendee.scenarios);
        return;
    }
    [self requestAttendeeStatusWithToken:[self accessToken] Completion:^(Attendee * _Nonnull attendee) {
        completion(attendee.scenarios);
    } Failure:^(ErrorMessage * _Nonnull message) {
        if(failure != NULL)
            failure(message);
    }];
}

- (NSArray *)availableScenarios {
    if(self.attendee) {
        return self.attendee.scenarios;
    }
    return nil;
}

- (void)useScenarioWithScenrio:(Scenario*)scenario Completion:(void (^)(Scenario * _Nonnull))completion Failure:(void (^)(ErrorMessage * _Nonnull))failure {
    [self.ccipAPIManager getObject:nil path:[NSString stringWithFormat:@"/use/%@",scenario.scenarioId] parameters:@{@"token": [self accessToken]} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Attendee* attendee = (Attendee*)[mappingResult firstObject];
        for (Scenario* tmpScenario in attendee.scenarios) {
            if ([tmpScenario.scenarioId isEqualToString:scenario.scenarioId]) {
                completion(tmpScenario);
            }
        }
        self.attendee = attendee;
    } failure:^(RKObjectRequestOperation *operation,NSError* error) {
        
        if([error code] == 1004) {
            ErrorMessage* errorMessage = (ErrorMessage*)[[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
            errorMessage.title = @"token error";
            failure(errorMessage);
        } else if ([[[operation HTTPRequestOperation] response] statusCode] == 403){
            ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
            errorMessage.title = @"";
            errorMessage.message = [error localizedDescription];
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Network Error", nil) Subtitle:NSLocalizedString(@"Please Use Wifi", nil)];
            if(failure)
                failure(errorMessage);
        } else {
            ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
            errorMessage.title = @"";
            errorMessage.message = [error localizedDescription];
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Network Error", nil) Subtitle:[error localizedDescription]];
            if(failure)
                failure(errorMessage);
        }
    }];
}

@end
