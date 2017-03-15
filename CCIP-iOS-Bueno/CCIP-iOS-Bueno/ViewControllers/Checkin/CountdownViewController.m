//
//  CountdownViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/9.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "CountdownViewController.h"
#import <Google/Analytics.h>
@interface CountdownViewController ()
@property (strong ,nonatomic) NSTimer* timer;
@end

@implementation CountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"CountdownView"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)config {
    [self updateTime];
    
    if([self.scenario.scenarioId isEqualToString:@"lunch"]) {
        if([[self.scenario.attr objectForKey:@"diet"] isEqualToString:@"meat"]) {
            self.view.backgroundColor = [UIColor colorWithRed:1 green:160.0/255 blue:0 alpha:1];//FFA000
        } else {
            self.view.backgroundColor = [UIColor colorWithRed:41.0/255 green:138.0/255 blue:8.0/255 alpha:1];
        }//298A08
        [self.effectView setAlpha:0.0];
    }
    
    if([[[NSLocale currentLocale] languageCode] isEqualToString:@"zh"])
        self.titleLabel.text = self.scenario.display.zh;
    else
        self.titleLabel.text = self.scenario.display.en;
    self.attrLabel.text = @"";
    for (NSString* key in [self.scenario.attr allKeys]) {
        
        self.attrLabel.text = [self.attrLabel.text stringByAppendingFormat:@"%@\n", [self.scenario.attr objectForKey:key]];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}

- (void)updateTime {
    if([[self.scenario.used dateByAddingTimeInterval:[self.scenario.countdown doubleValue]] timeIntervalSinceDate:[NSDate date]] <= 0) {
        [self dissmissBtnDown:nil];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%i",(int)([[self.scenario.used dateByAddingTimeInterval:[self.scenario.countdown doubleValue]] timeIntervalSinceDate:[NSDate date]])];
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

- (IBAction)dissmissBtnDown:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}
@end
