//
//  CheckinCollectionViewCell.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/5.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scenario.h"
@interface CheckinCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Scenario* scenario;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
- (IBAction)startAction:(id)sender;


@end
