//
//  CheckinCardWarpperViewController.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/5.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>
#import "APIManager.h"

@interface CheckinCardWarpperViewController : UIViewController<iCarouselDataSource, iCarouselDelegate, APIManagerDelegate>
@property (strong, nonatomic) IBOutlet iCarousel *cardWarpper;
@property (strong, nonatomic) IBOutlet UIPageControl *pagecontrol;
- (IBAction)dataRetry:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *nodataView;

@end
