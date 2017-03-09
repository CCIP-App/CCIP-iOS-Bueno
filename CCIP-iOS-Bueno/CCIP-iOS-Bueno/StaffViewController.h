//
//  StaffViewController.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/9.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface StaffViewController : UIViewController<WKUIDelegate, WKNavigationDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end
