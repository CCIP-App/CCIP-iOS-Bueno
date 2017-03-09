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
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sitcon"]];
    imageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 28);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageView;
    // Init configure carousel
    self.cardWarpper.type = iCarouselTypeRotary;
    self.cardWarpper.pagingEnabled = YES;
    self.cardWarpper.bounceDistance = 0.3f;
    self.cardWarpper.contentOffset = CGSizeMake(0, -5.0f);
    [self.nodataView setAlpha:0.0];
    
    [[[APIManager sharedManager] delegates] addObject:self];
    
    [[APIManager sharedManager] requestScenariosWithCompletion:^(NSArray * _Nonnull scenarios) {
        self.scenarios = scenarios;
        [self reloadData];
    } Failure:^(ErrorMessage * _Nonnull errorMessage) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.nodataView setAlpha:1.0];
        }];
    }];
    
    // Do any additional setup after loading the view.
}

- (void)attendeeStatusChange:(Attendee *)attendee {
    self.scenarios = attendee.scenarios;
    [self reloadData];
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
    if ([(Scenario*)[self.scenarios objectAtIndex:index] countdown]>0) {
        cardView.controller.timer = [NSTimer scheduledTimerWithTimeInterval:[[[self.scenarios objectAtIndex:index] countdown] doubleValue] target:cardView.controller selector:@selector(setButton) userInfo:nil repeats:NO];
    }
    [cardView.controller setScenario:[self.scenarios objectAtIndex:index]];
    return view;
}

#pragma mark iCarousel methods
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    
    [self.pagecontrol setCurrentPage:carousel.currentItemIndex];
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap: {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing: {
            //add a bit of spacing between the item views
            return value * 1.08f;
        }
        case iCarouselOptionFadeMax: {
            return 0.0;
        }
        case iCarouselOptionFadeMin: {
            return 0.0;
        }
        case iCarouselOptionFadeMinAlpha: {
            return 0.85;
        }
        case iCarouselOptionArc: {
            return value * (carousel.numberOfItems/48.0f);
        }
        case iCarouselOptionRadius: {
            return value * 1.0f;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionAngle:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems: {
            return value;
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dataRetry:(id)sender {
    [[APIManager sharedManager] requestScenariosWithCompletion:^(NSArray * _Nonnull scenarios) {
        self.scenarios = scenarios;
        [self reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            [self.nodataView setAlpha:0.0];
        }];
    } Failure:^(ErrorMessage * _Nonnull errorMessage) {
        
    }];
}
@end
