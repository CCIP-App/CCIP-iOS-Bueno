//
//  Submission.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/2/27.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Speaker.h"
@interface Submission : NSObject
//K keynote, T talk, S shortTalk, L lighting talk, E event, P panel, U unconf
@property (strong, nonatomic) Speaker* speaker;
@property (strong, nonatomic) NSDate* start;
@property (strong, nonatomic) NSDate* end;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* room;
@property (strong, nonatomic) NSString* subject;
@property (strong, nonatomic) NSString* summary;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end
