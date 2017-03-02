//
//  Speaker.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/2/27.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "Speaker.h"

#define NAME_KEY @"NAME_KEY"
#define AVATAR_KEY @"AVATAR_KEY"
#define BIO_KEY @"BIO_KEY"

@implementation Speaker

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.name = [decoder decodeObjectForKey:NAME_KEY];
    self.avatar = [decoder decodeObjectForKey:AVATAR_KEY];
    self.bio = [decoder decodeObjectForKey:BIO_KEY];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:NAME_KEY];
    [encoder encodeObject:self.avatar forKey:AVATAR_KEY];
    [encoder encodeObject:self.bio forKey:BIO_KEY];
}

@end
