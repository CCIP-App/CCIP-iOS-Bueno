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
@interface APIManager()

@property (nonatomic) NSDictionary* config;
@property (nonatomic) RKObjectMapping* attendeeMapping;

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
}

- (void)configureRequestDescriptors {
    //[[RKObjectManager sharedManager] object]
}

- (void)configureResponseDescriptors {
    RKResponseDescriptor* attendeeResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:self.attendeeMapping method:RKRequestMethodGET pathPattern:@"status" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [[RKObjectManager sharedManager] addResponseDescriptor:attendeeResponseDescriptor];
}

- (void)requestAttendeeStatusWithToken:(NSString*)token Completion:(void (^)(Attendee* attendee))completion {
    [[RKObjectManager sharedManager] getObject:nil path:@"status" parameters:@{@"token": token} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        completion((Attendee*)[mappingResult firstObject]);
    } failure:nil];
}


@end
