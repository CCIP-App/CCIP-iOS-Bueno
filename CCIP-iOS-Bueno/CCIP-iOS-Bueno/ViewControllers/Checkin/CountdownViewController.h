//
//  CountdownViewController.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/9.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scenario.h"
@interface CountdownViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (strong, nonatomic) Scenario* scenario;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *attrLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
- (void)config;
- (IBAction)dissmissBtnDown:(id)sender;

@end
