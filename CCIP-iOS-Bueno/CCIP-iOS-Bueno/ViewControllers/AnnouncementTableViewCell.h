//
//  AnnouncementTableViewCell.h
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/4.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Announcement.h"
@interface AnnouncementTableViewCell : UITableViewCell

@property (strong, nonatomic) Announcement* announcement;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
