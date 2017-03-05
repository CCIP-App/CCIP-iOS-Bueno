//
//  CheckinCardWarpperViewController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/5.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "CheckinCardWarpperViewController.h"
#import "CheckinCardViewController.h"
#import "CheckinCardView.h"
#import "Scenario.h"
#import "APIManager.h"
@interface CheckinCardWarpperViewController ()

@property (strong, nonatomic) NSArray* scenarios;

@end

@implementation CheckinCardWarpperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardWarpper.dataSource = self;
    self.cardWarpper.delegate = self;
    
    // Init configure carousel
    self.cardWarpper.type = iCarouselTypeRotary;
    self.cardWarpper.pagingEnabled = YES;
    self.cardWarpper.bounceDistance = 0.3f;
    self.cardWarpper.contentOffset = CGSizeMake(0, -5.0f);

    
    [[APIManager sharedManager] requestScenariosWithCompletion:^(NSArray * _Nonnull scenarios) {
        self.scenarios = scenarios;
        [self reloadData];
    } Failure:^(ErrorMessage * _Nonnull errorMessage) {
        
    }];
    
    // Do any additional setup after loading the view.
}

- (void)reloadData {
    [self.cardWarpper reloadData];
    self.pagecontrol.numberOfPages = [self.scenarios count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.scenarios count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    CheckinCardView* cardView = (CheckinCardView*)view;
    if(view == nil) {
        CheckinCardViewController* viewController = (CheckinCardViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CheckinCardVC"];
        view = viewController.view;
        cardView = (CheckinCardView*)view;
        viewController.cardView.controller = viewController;
    } else {
    }
    [cardView.controller setScenario:[self.scenarios objectAtIndex:index]];
    return view;
}

#pragma mark iCarousel methods
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    
    [self.pagecontrol setCurrentPage:carousel.currentItemIndex];
    
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
