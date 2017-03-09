//
//  Submission.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/2/27.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "Submission.h"

/*
 @property (strong, nonatomic) Speaker* speaker;
 @property (strong, nonatomic) NSDate* start;
 @property (strong, nonatomic) NSDate* end;
 @property (strong, nonatomic) NSString* type;
 @property (strong, nonatomic) NSString* room;
 @property (strong, nonatomic) NSString* subject;
 @property (strong, nonatomic) NSString* summary;
 */

#define SPEAKER_KEY @"SPEAKER_KEY"
#define START_KEY @"START_KEY"
#define END_KEY @"END_KEY"
#define TYPE_KEY @"TYPE_KEY"
#define ROOM_KEY @"ROOM_KEY"
#define SUBJECT_KEY @"SUBJECT_KEY"
#define SUMMARY_KEY @"SUMMARY_KEY"

@implementation Submission

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    self.speaker = [decoder decodeObjectForKey:SPEAKER_KEY];
    self.start = [decoder decodeObjectForKey:START_KEY];
    self.end = [decoder decodeObjectForKey:END_KEY];
    self.type = [decoder decodeObjectForKey:TYPE_KEY];
    self.room = [decoder decodeObjectForKey:ROOM_KEY];
    self.subject = [decoder decodeObjectForKey:SUBJECT_KEY];
    self.summary = [decoder decodeObjectForKey:SUMMARY_KEY];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.speaker forKey:SPEAKER_KEY];
    [encoder encodeObject:self.start forKey:START_KEY];
    [encoder encodeObject:self.end forKey:END_KEY];
    [encoder encodeObject:self.type forKey:TYPE_KEY];
    [encoder encodeObject:self.room forKey:ROOM_KEY];
    [encoder encodeObject:self.subject forKey:SUBJECT_KEY];
    [encoder encodeObject:self.summary forKey:SUMMARY_KEY];
}

@end
