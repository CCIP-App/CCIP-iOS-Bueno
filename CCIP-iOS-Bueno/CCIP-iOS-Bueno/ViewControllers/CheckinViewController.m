//
//  CheckinViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "CheckinViewController.h"
@interface CheckinViewController ()

@property (strong, nonatomic) UIViewController* checkinViewController;
@property (strong, nonatomic) UIViewController* redeemViewController;

@end

@implementation CheckinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[APIManager sharedManager] delegates] addObject:self];
}

- (void)viewWillAppear:(BOOL)animated {
    if(![[APIManager sharedManager] haveAccessToken]) {
        [self presentRedeemViewController];
    } else {
        [self presentCheckinViewControllerWithAnimation:NO];
    }
    [super viewWillAppear:animated];
}

- (void)presentRedeemViewController {
    if(!self.redeemViewController)
        self.redeemViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RedeemVC"];
    [self.view addSubview:self.redeemViewController.view];
    [self addChildViewController:self.redeemViewController];
}

- (void)presentCheckinViewControllerWithAnimation:(BOOL)animate {
    if(!self.checkinViewController)
        self.checkinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinVC"];
    if(animate){
        [self.checkinViewController.view setAlpha:0.0];
        [UIView animateWithDuration:0.5 animations:^{
            [self.checkinViewController.view setAlpha:1.0];
        }];
    }
    [self.view addSubview:self.checkinViewController.view];
    [self addChildViewController:self.checkinViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tokenHaveChangedWithAttendee:(Attendee *)attendee {
    if(![[APIManager sharedManager] haveAccessToken]) {
        [self presentRedeemViewController];
    } else {
        [self presentCheckinViewControllerWithAnimation:YES];
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

@end
