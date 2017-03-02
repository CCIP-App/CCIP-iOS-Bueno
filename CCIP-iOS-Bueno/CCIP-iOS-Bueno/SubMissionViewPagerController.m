//
//  SubMissionViewPagerController.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2017/3/2.
//  Copyright © 2017年 高宜誠. All rights reserved.
//

#import "SubMissionViewPagerController.h"
#import "AbstractViewController.h"
#import "SpeakerInfoViewController.h"
@interface SubMissionViewPagerController ()

@property (strong, nonatomic) AbstractViewController *abstractViewController;
@property (strong, nonatomic) SpeakerInfoViewController *speakerInfoViewController;
@property (strong, nonatomic) UIViewController *currentContentViewController;

@end

@implementation SubMissionViewPagerController

- (instancetype)init {
    self = [super init];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        self.abstractViewController = (AbstractViewController *)[storyboard instantiateViewControllerWithIdentifier:@"abstractVC"];
        self.speakerInfoViewController = (SpeakerInfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"speakerInfoVC"];
    }
    return self;
}

- (instancetype)initWithSubmission:(Submission *)submission {
    self = [self init];
    if (self) {
        [self setSubmission:submission];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        self.abstractViewController = (AbstractViewController *)[storyboard instantiateViewControllerWithIdentifier:@"abstractVC"];
        self.speakerInfoViewController = (SpeakerInfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"speakerInfoVC"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.currentContentViewController != nil) {
        if ([self.currentContentViewController canPerformAction:@selector(viewWillAppear:) withSender:@(animated)]) {
            [self.currentContentViewController viewWillAppear:animated];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.currentContentViewController != nil) {
        if ([self.currentContentViewController canPerformAction:@selector(viewDidAppear:) withSender:@(animated)]) {
            [self.currentContentViewController viewDidAppear:animated];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSubmission:(Submission *)submission {
    _submission = submission;
    
    [self.abstractViewController setSubmission:submission];
    [self.speakerInfoViewController setSubmission:submission];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    if([self.submission.speaker.name isEqualToString:@""])
        return 1;
    return 2;
}

#pragma mark - ViewPagerDataSource
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Noto Sans" size:17];
    switch (index) {
        case 0:
            label.text = NSLocalizedString(@"Introduction", nil);
            break;
        case 1:
            label.text = NSLocalizedString(@"Speaker", nil);
            break;
        default:
            label.text = @"(NULL)";
            break;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [self.view bringSubviewToFront:label];
    
    return label;
}

#pragma mark - ViewPagerDataSource
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            self.currentContentViewController = self.abstractViewController;
            break;
        case 1:
            self.currentContentViewController = self.speakerInfoViewController;
            break;
        default:
            self.currentContentViewController = [UIViewController new];
            break;
    }
    return self.currentContentViewController;
}

#pragma mark - ViewPagerDelegate
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    // Do something useful
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabDisableTopLine:
            return 1.0;
        case ViewPagerOptionTabDisableBottomLine:
            return 1.0;
        case ViewPagerOptionTabNarmalLineWidth:
            return 5.0;
        case ViewPagerOptionTabSelectedLineWidth:
            return 5.0;
        case ViewPagerOptionTabWidth:
            if([self.submission.speaker.name isEqualToString:@""])
                return [[UIScreen mainScreen] bounds].size.width;
            return [[UIScreen mainScreen] bounds].size.width/2;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerIndicator: {
            return [UIColor colorWithRed:244.0f/255.0f green:0.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
        }
        case ViewPagerTabsView: {
            return [UIColor clearColor];
        }
        case ViewPagerContent: {
            return [UIColor clearColor];
        }
        default: {
            return color;
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

@end
