//
//  CheckinViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "CheckinViewController.h"
#import "APIManager.h"
@interface CheckinViewController ()

@end

@implementation CheckinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UIViewController* redeemViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RedeemVC"];
    [self.view addSubview:redeemViewController.view];
    [self addChildViewController:redeemViewController];
}

- (void)presentCheckinViewControllerWithAnimation:(BOOL)animate {
    UIViewController* checkinViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckinVC"];
    if(animate){
        [checkinViewController.view setAlpha:0.0];
        [UIView animateWithDuration:0.5 animations:^{
            [checkinViewController.view setAlpha:1.0];
        }];
    }
    [self.view addSubview:checkinViewController.view];
    [self addChildViewController:checkinViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
