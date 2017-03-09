//
//  CheckinCardViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/5.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "CheckinCardViewController.h"
#import "NotificationManager.h"
#import "CountdownViewController.h"
@interface CheckinCardViewController ()

@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (strong, nonatomic) NSMutableArray *timers;

@end

@implementation CheckinCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeFormatter = [NSDateFormatter new];
    [self.timeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [self.timeFormatter setDateFormat:@"MM/dd HH:mm"];
    self.timers = [NSMutableArray new];
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
    
}

- (void)setButton {
    if (self.scenario.disabled) {
        [self.actionBtn setTitle:self.scenario.disabled forState:UIControlStateNormal];
        [self.actionBtn setBackgroundColor:[UIColor grayColor]];
    } else if (self.scenario.used) {
        if ([[NSDate date] timeIntervalSinceDate:self.scenario.used] < [self.scenario.countdown doubleValue]) {
            [self.actionBtn setTitle:NSLocalizedString(@"Using", nil) forState:UIControlStateNormal];
            [self.actionBtn setBackgroundColor:[UIColor greenColor]];
        } else {
            [self.actionBtn setTitle:NSLocalizedString(@"Used", nil) forState:UIControlStateNormal];
            [self.actionBtn setBackgroundColor:[UIColor grayColor]];
        }
    } else if ([self.scenario.expireTime timeIntervalSinceDate:[NSDate date]] < 0) {
        [self.actionBtn setTitle:NSLocalizedString(@"Expired", nil) forState:UIControlStateNormal];
        [self.actionBtn setBackgroundColor:[UIColor greenColor]];
    } else {
        [self.actionBtn setTitle:NSLocalizedString(@"Use", nil) forState:UIControlStateNormal];
        [self.actionBtn setBackgroundColor:[UIColor colorWithRed:2.0/255 green:35.0/255 blue:77.0/255 alpha:1]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionBtnDown:(id)sender {
    [self setButton];
    if(self.scenario.disabled) {
        [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Scenario Status", nil) Subtitle:NSLocalizedString(self.scenario.disabled, nil)];
    } else if(self.scenario.used) {
        if ([[NSDate date] timeIntervalSinceDate:self.scenario.used] < [self.scenario.countdown doubleValue]) {
            [self showCountDownVCWithScenario:self.scenario];
        } else {
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Scenario Status", nil) Subtitle:NSLocalizedString(@"Used", nil)];
        }
    } else if ([self.scenario.expireTime timeIntervalSinceDate:[NSDate date]] < 0) {
        [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Scenario Status", nil) Subtitle:NSLocalizedString(@"Expired", nil)];
    } else {
        [[APIManager sharedManager] useScenarioWithScenrio:self.scenario Completion:^(Scenario * _Nonnull scenario) {
            self.scenario = scenario;
            if ([self.scenario.countdown doubleValue] > 0)
                [self showCountDownVCWithScenario:scenario];
        } Failure:^(ErrorMessage * _Nonnull errorMessage) {
            
        }];
    }
}

- (void)showCountDownVCWithScenario:(Scenario*)scenario {
    CountdownViewController *countdownViewController = (CountdownViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"countdownVC"];
    countdownViewController.view.frame = [[UIScreen mainScreen] bounds];
    UIViewController* rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    countdownViewController.scenario = scenario;
    [countdownViewController config];
    [countdownViewController.view setAlpha:0.0];
    [UIView animateWithDuration:0.5 animations:^{
        [countdownViewController.view setAlpha:1.0];
    }];
    [rootVC.view addSubview:countdownViewController.view];
    [rootVC addChildViewController:countdownViewController];
}



@end
