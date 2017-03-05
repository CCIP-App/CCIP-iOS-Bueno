//
//  CheckinCollectionViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/5.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "CheckinCollectionViewController.h"
#import "APIManager.h"
#import "CheckinCollectionViewCell.h"
@interface CheckinCollectionViewController ()

@property (strong, nonatomic) NSArray* scenarios;

@end

@implementation CheckinCollectionViewController

//static NSString * const reuseIdentifier = @"CardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[APIManager sharedManager] requestScenariosWithCompletion:^(NSArray * _Nonnull scenarios) {
        self.scenarios = scenarios;
        [self.collectionView reloadData];
    } Failure:^(ErrorMessage * _Nonnull errorMessage) {
        
    }];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UIView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stone"]];
    //logoView.frame = self.navigationItem.titleView.bounds;
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    self.navigationItem.titleView = logoView;
    
    // Register cell classes
    //[self.collectionView registerClass:[CheckinCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.scenarios count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CheckinCollectionViewCell *cell = (CheckinCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    NSLog(@"%lu",indexPath.row);
    cell.scenario = [self.scenarios objectAtIndex:indexPath.row];
    cell.titleLabel.text = NSLocalizedString(cell.scenario.scenarioId, nil) ;
    
    if (cell.scenario.used || cell.scenario.disabled) {
        cell.actionButton.enabled = false;
        if(cell.scenario.used) {
            cell.actionButton.titleLabel.text = NSLocalizedString(@"Used", nil);
        } else if(cell.scenario.disabled) {
            [cell.actionButton setTitle:NSLocalizedString(cell.scenario.disabled, nil) forState:UIControlStateDisabled];
        }
        cell.actionButton.backgroundColor = [UIColor grayColor];
    } else {
        cell.actionButton.enabled = true;
        cell.actionButton.backgroundColor = [UIColor colorWithRed:2.0/255 green:35.0/255 blue:77.0/255 alpha:1];
        [cell.actionButton setTitle:NSLocalizedString(@"Use", nil) forState:UIControlStateNormal];
    }
    [cell.actionButton.titleLabel sizeToFit];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetHeight(collectionView.frame)));
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
