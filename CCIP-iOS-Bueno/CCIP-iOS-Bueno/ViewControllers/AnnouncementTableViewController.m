//
//  AnnouncementTableViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/4.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "AnnouncementTableViewController.h"
#import "APIManager.h"
#import "AnnouncementTableViewCell.h"
@interface AnnouncementTableViewController ()

@property (strong, nonatomic) NSArray* announcements;
@property (strong, nonatomic) NSDateFormatter* timeFormatter;

@end

@implementation AnnouncementTableViewController

- (void)setTableViewUI {
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithRed:2.0/255 green:35.0/255 blue:77.0/255 alpha:1];
    self.tableView.estimatedRowHeight = 56;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableViewUI];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sitcon"]];
    imageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 28);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;
    
    self.timeFormatter = [NSDateFormatter new];
    [self.timeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [self.timeFormatter setDateFormat:@"MM/dd HH:mm"];
    
    [[APIManager sharedManager] requestAnnouncementWithCompletion:^(NSArray * _Nonnull announcements) {
        self.announcements = announcements;
        [self.tableView reloadData];
    } Failure:^(ErrorMessage * _Nonnull errorMessage) {
        
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.announcements count]==0)
        return 1;
    return [self.announcements count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnnouncementTableViewCell *cell = (AnnouncementTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"AnnouncementCell" forIndexPath:indexPath];
    
    if([self.announcements count]==0) {
        cell.announcement = [Announcement new];
        cell.announcement.msg = NSLocalizedString(@"Oops! There is no message.", nil);
        cell.msgLabel.text = cell.announcement.msg;
        cell.timeLabel.text = @"";
        return cell;
    }
    cell.announcement = [self.announcements objectAtIndex:indexPath.row];
    cell.msgLabel.text = cell.announcement.msg;
    cell.timeLabel.text = [self.timeFormatter stringFromDate:cell.announcement.datetime];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.announcements count]==0) return;
    if(![[(Announcement*)[self.announcements objectAtIndex:indexPath.row] uri] isEqualToString:@""]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(Announcement*)[self.announcements objectAtIndex:indexPath.row] uri]] options:@{} completionHandler:nil];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
