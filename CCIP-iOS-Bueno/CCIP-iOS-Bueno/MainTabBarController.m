//
//  MainTabBarController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/2/27.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "MainTabBarController.h"
#import "TelegramViewController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:244.0/255.0 green:0 blue:127.0/255.0 alpha:1]];//E4007E
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if([viewController class] == [TelegramViewController class]) {
        NSURL *telegramURL = [NSURL URLWithString:@"tg://resolve?domain=SITCONgeneral"];
        if(![[UIApplication sharedApplication] canOpenURL:telegramURL])
            telegramURL = [NSURL URLWithString:@"https://telegram.me/SITCONgeneral"];
        [[UIApplication sharedApplication] openURL:telegramURL options:@{} completionHandler:nil];
        return false;
    }
    return true;
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
