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
#import "NotificationManager.h"
#import <Google/Analytics.h>
@interface RedeemViewController ()
@property (strong, nonatomic) MTBBarcodeScanner *qrScanner;
@end

@implementation RedeemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.qrScanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.qrPreviewView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.qrWarpperView setAlpha:0.0];
    [self.infoWrapperView setAlpha:1.0];
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"RedeemView"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    [[GAI sharedInstance] dispatch];
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
    }];
}

- (IBAction)startButtonPressed:(id)sender {
    [self requestCameraPermission];
}

- (IBAction)qrFilePick:(id)sender {
    [self getImageFromLibrary];
}

#pragma mark QR Code from Camera Roll Library

- (void)getImageFromLibrary {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentViewController:imagePicker
                       animated:YES
                     completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy: CIDetectorAccuracyHigh }];
        CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
        NSArray *features = [detector featuresInImage:image];
        
        CIQRCodeFeature *feature = [features firstObject];
        
        NSString *result = feature.messageString;
        
        if (result != nil) {
            [self loadAttendeeWithAccessToken:result];
        } else {
            [[NotificationManager sharedManager] showErrorAlert:NSLocalizedString(@"QRFileNotAvailableTitle", nil) Subtitle:NSLocalizedString(@"QRFileNotAvailableDesc", nil)];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
