//
//  TicketViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/9.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "TicketViewController.h"
#import "APIManager.h"
#import <Google/Analytics.h>
@interface TicketViewController ()

@property (strong, nonatomic) NSString* accessToken;

@end

@implementation TicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.accessToken = [[APIManager sharedManager] accessToken];
    if(![@"" isEqualToString:self.accessToken]) {
        CIFilter* filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setValue:[self.accessToken dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
        [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
        CGAffineTransform transform = CGAffineTransformMakeScale(5.0f, 5.0f);
        self.QRImage.image = [UIImage imageWithCIImage:[[filter outputImage] imageByApplyingTransform:transform]];
    } else {
        
    }
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"TicketView"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[GAI sharedInstance] dispatch];
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
