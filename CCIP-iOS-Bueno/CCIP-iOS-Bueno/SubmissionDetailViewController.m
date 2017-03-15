//
//  SubmissionDetailViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/2/27.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "SubmissionDetailViewController.h"
#import "NotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import "SubMissionViewPagerController.h"
#import <Google/Analytics.h>
@interface SubmissionDetailViewController ()

@end

@implementation SubmissionDetailViewController

- (void)configuration {
    // Custom initialization
}

- (void)registerLocalNotificationAction {
    NotificationManager* notificationManager = [NotificationManager sharedManager];
    [notificationManager registerNotificationWithTitle:@"SITCON 議程提醒" Body:[NSString stringWithFormat:@"您所關注的「%@」將於 10 分鐘後在 %@ 開始", self.submission.subject, self.submission.room] Identifier:self.submission.subject FireDate:[self.submission.start dateByAddingTimeInterval:-(10*60)] Completion:^{
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"Star_Filled.png"]];
        });
    }];
}

- (void)cancelLocalNotificationAction {
    [[NotificationManager sharedManager] removeNotificationWithIdentifier:self.submission.subject];
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"Star.png"]];
    });
}


- (void)followAction:(id)sender {
    [self haveRegistedLocalNotificationAction:^(BOOL result) {
        if (result) {
            [self cancelLocalNotificationAction];
        } else {
            [self registerLocalNotificationAction];
        }
    }];
    
}

- (void)haveRegistedLocalNotificationAction:(void (^ _Nullable)(BOOL result))completion {
    [[NotificationManager sharedManager] haveRegistedLocalNotificationWithIdentifier:self.submission.subject Completion:completion];
}

- (void)setFollowButton {
    [self haveRegistedLocalNotificationAction:^(BOOL result) {
        UIBarButtonItem *followButton = [[UIBarButtonItem alloc] initWithImage:result ? [UIImage imageNamed:@"Star_Filled.png"] : [UIImage imageNamed:@"Star.png"]
                                                           landscapeImagePhone:nil
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(followAction:)];
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.navigationItem.rightBarButtonItem = followButton;
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.speakerLabel.text = self.submission.speaker.name;
    self.subjectLabel.text = self.submission.subject;
    [self.subjectLabel setAdjustsFontSizeToFitWidth:YES];
    [self.subjectLabel setMinimumScaleFactor:0.5];
    [self setFollowButton];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"SubmissionDetailView"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[GAI sharedInstance] dispatch];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"pagerSegue"]) {
        [(SubMissionViewPagerController*)[segue destinationViewController] setSubmission:self.submission];
    }
}


@end
