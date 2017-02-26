//
//  Attendee.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Scenario.h"

@interface Attendee : NSObject

@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic) NSDictionary* attr;
@property (nonatomic) NSNumber* status;
@property (nonatomic) NSArray* scenarios;
//@property (nonatomic, copy) NSString* type;

@end
