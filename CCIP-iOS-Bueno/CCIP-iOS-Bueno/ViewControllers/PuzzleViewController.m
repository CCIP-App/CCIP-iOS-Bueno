//
//  PuzzleViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/9.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "PuzzleViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "APIManager.h"
#import <MBProgressHUD.h>
#import <Google/Analytics.h>
#import "NotificationManager.h"
@interface PuzzleViewController ()

@property (strong, nonatomic) WKWebView* webView;
@property (strong, nonnull) MBProgressHUD *hud;

@end

@implementation PuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!self.webView) {
        WKWebViewConfiguration* wkConfig = [WKWebViewConfiguration new];
        wkConfig.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore];
        self.webView = [[WKWebView alloc] initWithFrame:self.contentView.frame configuration:wkConfig];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.scrollView.backgroundColor = self.contentView.backgroundColor;
        [self.view addSubview:self.webView];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://puzzle.sitcon.party/?token=%@",[self sha1WithString:[[APIManager sharedManager] accessToken]]]]];
        [self.webView loadRequest:urlRequest];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.animationType = MBProgressHUDAnimationFade;
        [self.webView setAlpha:0];
    }
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"PuzzleView"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[GAI sharedInstance] dispatch];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIView animateWithDuration:0.5 animations:^{
        [self.webView setAlpha:1.0];
    }];
    [self.hud hideAnimated:YES];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.hud hideAnimated:YES];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"no_network" ofType:@"html"];
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
    [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"Network Error", nil) Subtitle:[error localizedDescription]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)sha1WithString:(NSString*)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.webView.frame = self.contentView.frame;
}

- (void)shareAction:(id)sender {
    
    NSURL* shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://puzzle.sitcon.party/?token=%@",[self sha1WithString:[[APIManager sharedManager] accessToken]]]];
    
    NSArray *activityItems = @[shareURL];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
    [self presentViewController:activityVC animated:TRUE completion:nil];
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
