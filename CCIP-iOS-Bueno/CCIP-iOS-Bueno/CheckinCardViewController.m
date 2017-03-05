//
//  CheckinCardViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/5.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "CheckinCardViewController.h"

@interface CheckinCardViewController ()

@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@end

@implementation CheckinCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeFormatter = [NSDateFormatter new];
    [self.timeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [self.timeFormatter setDateFormat:@"MM/dd HH:mm"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setScenario:(Scenario *)scenario {
    _scenario = scenario;
    if ([[NSLocale currentLocale].languageCode isEqualToString:@"zh"]) {
        self.titleLabel.text = scenario.display.zh;
    } else {
        self.titleLabel.text = scenario.display.en;
    }
    self.availableLabel.text = [self.timeFormatter stringFromDate:self.scenario.availableTime];
    [self setButton];
    
    if (scenario.disabled) {
        [self.actionBtn setTitle:scenario.disabled forState:UIControlStateNormal];
        [self.actionBtn setBackgroundColor:[UIColor grayColor]];
    } else if (scenario.used) {
        [self.actionBtn setTitle:@"Used" forState:UIControlStateNormal];
        [self.actionBtn setBackgroundColor:[UIColor grayColor]];
    } else {
        [self.actionBtn setTitle:@"Use" forState:UIControlStateNormal];
        [self.actionBtn setBackgroundColor:[UIColor colorWithRed:2.0/255 green:35.0/255 blue:77.0/255 alpha:1]];
    }

    
}

- (void)setButton {
    
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
