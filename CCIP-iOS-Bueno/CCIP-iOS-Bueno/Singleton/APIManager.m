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

@interface APIManager()

@property (nonatomic) NSDictionary* config;
@property (nonatomic) RKObjectMapping* attendeeMapping;
@property (nonatomic) RKObjectMapping* messageMapping;
@property (strong, atomic) Attendee* attendee;

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
    [RKObjectManager setSharedManager:[RKObjectManager managerWithBaseURL:baseUrl]];
    [[[RKObjectManager sharedManager] HTTPClient] setAuthorizationHeaderWithToken:@""];
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
                                                          @"order": @"order"
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
}

- (void)configureRequestDescriptors {
    //[[RKObjectManager sharedManager] object]
}

- (void)configureResponseDescriptors {
    RKResponseDescriptor* attendeeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.attendeeMapping method:RKRequestMethodGET pathPattern:@"/status" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    RKResponseDescriptor* errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.messageMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [[RKObjectManager sharedManager] addResponseDescriptor:attendeeResponseDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:errorResponseDescriptor];
}

- (void)requestAttendeeStatusWithToken:(NSString*)token Completion:(void (^)(Attendee* attendee))completion Failure:(void (^)(ErrorMessage *))failure{
    [[RKObjectManager sharedManager] getObject:nil path:@"/status" parameters:@{@"token": token} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        completion((Attendee*)[mappingResult firstObject]);
        
    } failure:^(RKObjectRequestOperation *operation,NSError* error) {
        failure((ErrorMessage*)[[[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey] firstObject]);
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
    [[APIManager sharedManager] requestAttendeeStatusWithToken:accessToken Completion:^(Attendee *attendee) {
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



@end
