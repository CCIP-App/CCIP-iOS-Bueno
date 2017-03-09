//
//  StaffViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/10.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "StaffViewController.h"
#import <MBProgressHUD.h>
@interface StaffViewController ()
@property (strong, nonatomic) WKWebView* webView;
@property (strong, nonnull) MBProgressHUD *hud;
@end

@implementation StaffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration* wkConfig = [WKWebViewConfiguration new];
    self.webView = [[WKWebView alloc] initWithFrame:self.contentView.frame configuration:wkConfig];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.backgroundColor = self.contentView.backgroundColor;
    [self.view addSubview:self.webView];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sitcon.org/2017/#staff-page"]];
    [self.webView loadRequest:urlRequest];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.animationType = MBProgressHUDAnimationFade;
    [self.webView setAlpha:0];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webView.scrollView setScrollEnabled:NO];
    [webView evaluateJavaScript:@"document.getElementById('navbar').remove();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.webView setAlpha:1.0];
        }];
        [self.hud hideAnimated:YES];
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.hud hideAnimated:YES];
    if(error.code == NSURLErrorNotConnectedToInternet) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"no_network" ofType:@"html"];
        [self.webView loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
        
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
