//
//  Scenario.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scenario : NSObject

@property (nonatomic) NSString* scenarioId;
@property (nonatomic) NSString* disabled;
@property (nonatomic) NSNumber* countdown;
@property (nonatomic) NSDate* used;
@property (nonatomic) NSDate* expireTime;
@property (nonatomic) NSDate* availableTime;
@property (nonatomic) NSDictionary* attr;
@property (nonatomic) NSNumber* order;

@end
