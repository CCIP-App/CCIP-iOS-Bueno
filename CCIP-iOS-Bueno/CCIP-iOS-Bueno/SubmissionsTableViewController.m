//
//  SubmissionsTableViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/2/27.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "SubmissionsTableViewController.h"
#import "SubmissionTableViewCell.h"
#import "APIManager.h"
#import "Submission.h"
#import "SubmissionsTimeCell.h"
#import <MBProgressHUD.h>
#import "SubmissionDetailViewController.h"
@interface SubmissionsTableViewController ()

@property (strong, nonatomic) NSDictionary* submissions;
@property (strong, nonatomic) NSDateFormatter* hourFormatter;
@property (strong, nonatomic) NSDateFormatter* minFormatter;
@property (strong, nonnull) NSDateFormatter* hmFormatter;
@property (strong, nonatomic) NSArray* sortedSubmissionsKey;

@end

@implementation SubmissionsTableViewController

- (void)setTableViewUI {
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = [UIColor colorWithRed:2.0/255 green:35.0/255 blue:77.0/255 alpha:1];
    self.tableView.estimatedRowHeight = 56;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void) loadSubmissions:(NSArray *)submissions {
    NSMutableDictionary* submissionsDict = [NSMutableDictionary dictionary];
    
    submissions = [submissions sortedArrayUsingComparator:^NSComparisonResult(Submission*  _Nonnull obj1, Submission* _Nonnull obj2) {
        return obj1.room > obj2.room;
    }];
    
    for (Submission* submission in submissions) {
        if(![submissionsDict objectForKey:submission.start]) {
            [submissionsDict setObject:[NSMutableArray array] forKey:submission.start];
        }
        [[submissionsDict objectForKey:submission.start] addObject:submission];
    }
    self.sortedSubmissionsKey = [submissionsDict keysSortedByValueUsingComparator:^NSComparisonResult(NSArray*  _Nonnull obj1, NSArray* _Nonnull obj2) {
        return [((Submission*)[obj1 firstObject]).start compare:((Submission*)[obj2 firstObject]).start];
    }];
    
    self.submissions = submissionsDict;
}

- (void)setTimeFormater {
    
    self.hourFormatter = [[NSDateFormatter alloc] init];
    self.minFormatter = [[NSDateFormatter alloc] init];
    self.hmFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    [self.hourFormatter setTimeZone:zone];
    [self.minFormatter setTimeZone:zone];
    [self.hmFormatter setTimeZone:zone];
    [self.hourFormatter setDateFormat:@"HH"];
    [self.minFormatter setDateFormat:@"mm"];
    [self.hmFormatter setDateFormat:@"HH:mm"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableViewUI];
    [self setTimeFormater];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sitcon"]];
    imageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 28);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    [[APIManager sharedManager] requestSubmissionWithCompletion:^(NSArray * _Nonnull submissions) {
        [self loadSubmissions:submissions];
        [hud hideAnimated:NO];
        [self.tableView reloadData];
    } Failure:^(ErrorMessage * _Nonnull errorMessage) {
        
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.submissions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.submissions objectForKey:[self.sortedSubmissionsKey objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"submissionCell" forIndexPath:indexPath];
    Submission* submission = [[self.submissions objectForKey:[self.sortedSubmissionsKey objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.subjectLabel.text = submission.subject;
    cell.roomLabel.text = submission.room;
    cell.speakerLabel.text = submission.speaker.name;
    
    NSString* durationString = [NSString stringWithFormat:@"~ %@, %d %@",[self.hmFormatter stringFromDate:submission.end],(int)[submission.end timeIntervalSinceDate:submission.start]/60,NSLocalizedString(@"minutes", nil)];
    
    cell.durationLabel.text = [NSString stringWithFormat:@"%@", durationString];
    cell.submission = submission;
    [cell.speakerLabel sizeToFit];
    [cell.subjectLabel sizeToFit];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"submissionSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderCellIdentifier = @"timeCell";
    
    SubmissionsTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    NSDate* time = [self.sortedSubmissionsKey objectAtIndex:section];
    
    cell.hourLabel.text = [self.hourFormatter stringFromDate:time];
    cell.minLabel.text = [self.minFormatter stringFromDate:time];
    
    return cell;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SubmissionDetailViewController *detailVC = [segue destinationViewController];
    detailVC.submission = ((SubmissionTableViewCell*)[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]]).submission;
    //detailVC = sender.
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
