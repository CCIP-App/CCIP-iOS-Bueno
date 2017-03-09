//
//  FileManager.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "FileManager.h"

@interface FileManager()
@property (strong, nonatomic) NSString* tmpPath;
@property (strong, nonatomic) NSString* submissionsPath;
@end

@implementation FileManager

+ (instancetype)sharedManager {
    static FileManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.tmpPath = NSTemporaryDirectory();
        self.submissionsPath = [self.tmpPath stringByAppendingPathComponent:@"submission"];
    }
    return self;
}

- (NSDictionary *)getConfig {
    NSDictionary* config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
    return config;
}

- (void)saveSubmissions:(NSArray*)submissions {
    [self cleanSubmissions];
    [NSKeyedArchiver archiveRootObject:submissions toFile:self.submissionsPath];
}

- (NSArray*)getSubmissions {
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.submissionsPath])
        return nil;
    NSArray* submissions = [NSKeyedUnarchiver unarchiveObjectWithFile:self.submissionsPath];
    return submissions;
}
- (void)cleanSubmissions {
    if([[NSFileManager defaultManager] fileExistsAtPath:self.submissionsPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.submissionsPath error:nil];
    }
}
@end
