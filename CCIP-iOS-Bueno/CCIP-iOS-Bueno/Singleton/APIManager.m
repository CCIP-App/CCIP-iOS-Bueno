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
#import "FileManager.h"
@interface APIManager()

@property (nonatomic) NSDictionary* config;
@property (nonatomic) RKObjectMapping* attendeeMapping;
@property (nonatomic) RKObjectMapping* messageMapping;
@property (nonatomic) RKObjectMapping* submissionMapping;
@property (strong, atomic) Attendee* attendee;
@property (strong, nonatomic) RKObjectManager* sitconWebPageManager;
@property (strong, nonatomic) RKObjectManager* ccipAPIManager;
@property (strong, nonatomic) NSArray* submissions;

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

- (instancetype)init {
    self = [super init];
    if(self) {
        self.config = [[FileManager sharedManager] getConfig];
        [self configureObjectManager];
        [self configureObjectMappings];
        [self configureRequestDescriptors];
        [self configureResponseDescriptors];
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

    self.attendeeMapping = [RKObjectMapping mappingForClass:[Attendee class]];
    [self.attendeeMapping addAttributeMappingsFromDictionary:@{
                                                          @"token": @"token",
                                                          @"user_id": @"userId",
                                                          @"attr": @"attr",
                                                          @"status": @"status"
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
}

- (void)configureRequestDescriptors {
    //[[RKObjectManager sharedManager] object]
}

- (void)configureResponseDescriptors {
    RKResponseDescriptor* attendeeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.attendeeMapping method:RKRequestMethodGET pathPattern:@"/status" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    RKResponseDescriptor* errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.messageMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    RKResponseDescriptor* submissionResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.submissionMapping method:RKRequestMethodGET pathPattern:@"/2017/submissions.json" keyPath:@"" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [self.ccipAPIManager addResponseDescriptor:attendeeResponseDescriptor];
    [self.ccipAPIManager addResponseDescriptor:errorResponseDescriptor];
    [self.sitconWebPageManager addResponseDescriptor:submissionResponseDescriptor];
}

- (void)requestAttendeeStatusWithToken:(NSString*)token Completion:(void (^)(Attendee* attendee))completion Failure:(void (^)(ErrorMessage *))failure{
    [self.ccipAPIManager getObject:nil path:@"/status" parameters:@{@"token": token} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        completion((Attendee*)[mappingResult firstObject]);
        
    } failure:^(RKObjectRequestOperation *operation,NSError* error) {
        
        if([error code] == 1004) {
            ErrorMessage* errorMessage = (ErrorMessage*)[[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] firstObject];
            errorMessage.title = @"token error";
            failure(errorMessage);
        } else {
            ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
            errorMessage.title = @"";
            errorMessage.message = [error localizedDescription];
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
        self.attendee = attendee;
        completion(attendee);
    } Failure:^(ErrorMessage *errorMessage) {
        failure(errorMessage);
    }];
    //[[AppDelegate appDelegate].oneSignal sendTag:@"token" value:accessToken];
    //[[AppDelegate appDelegate] setDefaultShortcutItems];
}

- (void)resetAccessToken {
    self.attendee = nil;
    [UICKeyChainStore setString:@""
                         forKey:@"token"];
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
        ErrorMessage* errorMessage = [[ErrorMessage alloc] init];
        errorMessage.title = @"";
        errorMessage.message = [error localizedDescription];
        failure(errorMessage);
        if(failure != NULL)
            failure(errorMessage);
    }];
}

@end
