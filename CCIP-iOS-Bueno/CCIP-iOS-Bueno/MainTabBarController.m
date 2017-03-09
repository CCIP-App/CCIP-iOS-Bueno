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
