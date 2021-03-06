//
//  RedeemViewController.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/1/22.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeemViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *infoWrapperView;
@property (weak, nonatomic) IBOutlet UIView *qrWarpperView;
@property (weak, nonatomic) IBOutlet UIView *qrPreviewView;

- (IBAction)startButtonPressed:(id)sender;
- (IBAction)qrFilePick:(id)sender;

@end
