//
//  AbstractViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/2.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "AbstractViewController.h"

@interface AbstractViewController ()

@end

@implementation AbstractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSubmission:(Submission *)submission {
    _submission = submission;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.abstractTextView.text = self.submission.summary;
    self.roomLabel.text = self.submission.room;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"HH:mm"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",[formatter stringFromDate:self.submission.start],[formatter stringFromDate:self.submission.end]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
