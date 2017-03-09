//
//  Speaker.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/2/27.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Speaker : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* avatar;
@property (strong, nonatomic) NSString* bio;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;


@end
