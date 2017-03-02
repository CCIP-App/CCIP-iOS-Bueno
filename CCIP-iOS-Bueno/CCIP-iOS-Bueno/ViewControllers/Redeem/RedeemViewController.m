//
//  RedeemViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "RedeemViewController.h"
#import <FontAwesomeKit.h>
#import <MTBBarcodeScanner.h>
#import <MBProgressHUD.h>
#import "APIManager.h"
#import "CheckinViewController.h"
@interface RedeemViewController ()
@property (strong, nonatomic) MTBBarcodeScanner *qrScanner;
@property (strong, nonatomic) UIAlertController *errorMessageViewController;
@end

@implementation RedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.qrScanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.qrPreviewView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.qrScanner stopScanning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
- (IBAction)startScanQR:(id)sender {
 
    
}*/

- (void)requestCameraPermission {
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            [self startScanQR];
        } else {
            // The user denied access to the camera
        }
    }];
}

- (void)startScanQR {
    [UIView animateWithDuration:0.5 animations:^{
        [self.infoWrapperView setAlpha:0.0f];
        [self.qrWarpperView setAlpha:1.0f];
    }];
    NSError *error = nil;
    [self.qrScanner startScanningWithResultBlock:^(NSArray *codes) {
        AVMetadataMachineReadableCodeObject *code = [codes firstObject];
        if(code) {
            [self loadAttendeeWithAccessToken:code.stringValue];
            [self stopScanQR];
        }
    } error:&error];
}

- (void)stopScanQR {
    [self.qrScanner stopScanning];
    [UIView animateWithDuration:0.5 animations:^{
        [self.infoWrapperView setAlpha:1.0f];
        [self.qrWarpperView setAlpha:0.0f];
    }];
}

- (void)loadAttendeeWithAccessToken:(NSString *)accessToken {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    
    [[APIManager sharedManager] setAccessToken:accessToken Completion:^(Attendee *attendee) {
        [(CheckinViewController*)self.parentViewController presentCheckinViewControllerWithAnimation:YES];
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setAlpha:0.0];
        } completion:^(BOOL finished) {
            [hud hideAnimated:NO];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    } Failure:^(ErrorMessage *errorMessage) {
        [hud hideAnimated:YES];
        self.errorMessageViewController = [UIAlertController alertControllerWithTitle:NSLocalizedString(errorMessage.title, nil) message:NSLocalizedString(errorMessage.message, nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [self.errorMessageViewController addAction:defaultAction];
        [self presentViewController:self.errorMessageViewController animated:YES completion:nil];
    }];
}

- (IBAction)startButtonPressed:(id)sender {
    [self requestCameraPermission];
}
@end
