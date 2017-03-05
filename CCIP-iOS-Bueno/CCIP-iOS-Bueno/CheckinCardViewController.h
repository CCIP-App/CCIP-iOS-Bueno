//
//  CheckinCardViewController.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/5.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckinCardView.h"
#import "Scenario.h"
@interface CheckinCardViewController : UIViewController
@property (strong, nonatomic) Scenario* scenario;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *actionBtn;
@property (strong, nonatomic) IBOutlet UILabel *availableLabel;
@property (strong, nonatomic) IBOutlet CheckinCardView *cardView;

@end
