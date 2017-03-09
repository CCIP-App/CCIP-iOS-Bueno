//
//  FileManager.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Submission.h"
@interface FileManager : NSObject

+ (instancetype)sharedManager;

- (NSDictionary *)getConfig;

- (void)saveSubmissions:(NSArray*)submissions;
- (NSArray*)getSubmissions;
- (void)cleanSubmissions;

@end
