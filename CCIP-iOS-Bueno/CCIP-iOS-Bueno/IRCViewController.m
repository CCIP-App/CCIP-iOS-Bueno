//
//  IRCViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/14.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "IRCViewController.h"
#import <MBProgressHUD.h>
#import <Google/Analytics.h>
#import "NotificationManager.h"
@interface IRCViewController ()
@property (strong, nonatomic) WKWebView* webView;
@property (strong, nonnull) MBProgressHUD *hud;
@end

@implementation IRCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration* wkConfig = [WKWebViewConfiguration new];
    self.webView = [[WKWebView alloc] initWithFrame:self.contentView.frame configuration:wkConfig];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.backgroundColor = self.contentView.backgroundColor;
    [self.view addSubview:self.webView];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://ysitd.licson.net/channel/sitcon/today"]];
    [self.webView loadRequest:urlRequest];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.animationType = MBProgressHUDAnimationFade;
    [self.webView setAlpha:0];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"IRCView"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //[self.webView.scrollView setScrollEnabled:NO];
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.webView.frame = self.contentView.frame;
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
