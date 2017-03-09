//
//  CheckinViewController.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"
@interface CheckinViewController : UIViewController<APIManagerDelegate>

- (void)presentCheckinViewControllerWithAnimation:(BOOL)animate;

@end
