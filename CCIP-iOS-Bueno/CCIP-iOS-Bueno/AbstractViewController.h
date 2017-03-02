//
//  AbstractViewController.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/2.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Submission.h"
@interface AbstractViewController : UIViewController

@property (strong, nonatomic) Submission* submission;

@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *abstractTextView;
- (void)setSubmission:(Submission *)submission;

@end
