//
//  SubMissionViewPagerController.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/2.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <ICViewPager/ViewPagerController.h>
#import "Submission.h"
@interface SubMissionViewPagerController : ViewPagerController<ViewPagerDataSource, ViewPagerDelegate>

- (instancetype)initWithSubmission:(NSDictionary *)submission;

@property (strong, nonatomic) Submission* submission;


@end
