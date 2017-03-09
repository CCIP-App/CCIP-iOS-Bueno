//
//  SubmissionDetailViewController.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/2/27.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Submission.h"
@interface SubmissionDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *topBg;
@property (weak, nonatomic) IBOutlet UIView *paggerWarper;
@property (strong, nonatomic) Submission* submission;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;

@end
