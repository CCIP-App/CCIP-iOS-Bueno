//
//  ForumsViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/9.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "ForumsViewController.h"
#import <MBProgressHUD.h>
#import <Google/Analytics.h>
#import "NotificationManager.h"
@interface ForumsViewController ()

@property (strong, nonatomic) WKWebView* webView;
@property (strong, nonnull) MBProgressHUD *hud;
@end

@implementation ForumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration* wkConfig = [WKWebViewConfiguration new];
    wkConfig.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore];
    self.webView = [[WKWebView alloc] initWithFrame:self.contentView.frame configuration:wkConfig];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.backgroundColor = self.contentView.backgroundColor;
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pd.sitcon.org/"]];
    [self.webView loadRequest:urlRequest];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.animationType = MBProgressHUDAnimationFade;
    [self.webView setAlpha:0.0];
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"ForumsView"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[GAI sharedInstance] dispatch];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.webView.frame = self.contentView.frame;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
