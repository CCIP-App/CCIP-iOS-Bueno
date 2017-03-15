//
//  AppDelegate.m
//  CCIP-iOS-Bueno
//
//  Created by 高宜誠 on 2016/12/18.
//  Copyright © 2016年 高宜誠. All rights reserved.
//
#import "AppDelegate.h"
#import "APIManager.h"
#import <Firebase.h>
#import "NotificationManager.h"
#import <Google/Analytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
#pragma mark AppDelegate
+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark Application Event
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[[APIManager sharedManager] resetAccessToken];
    
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-34467841-12"];
    [[GAI sharedInstance].defaultTracker setAllowIDFACollection:NO];
    [[UINavigationBar appearance] setTintColor: [UIColor whiteColor]];//[UIColor colorWithRed:244.0/255 green:0 blue:119.0/255 alpha:1]];
    [OneSignal initWithLaunchOptions:launchOptions appId:@"9b74779c-bcd8-471e-a64b-e033acf0ebbd"];
    [NotificationManager sharedManager];
    [FIRApp configure];
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    return [self application:app openURL:url sourceApplication:nil annotation:@{}];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    FIRDynamicLink *dynamicLink =
    [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];
    
    if (dynamicLink) {
        [self handleFirebaseLink:dynamicLink];
        return YES;
    }
    
    return NO;
}
- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *))restorationHandler {
   BOOL handled = [[FIRDynamicLinks dynamicLinks]
                    handleUniversalLink:userActivity.webpageURL
                    completion:^(FIRDynamicLink * _Nullable dynamicLink,
                                 NSError * _Nullable error) {
                        [self handleFirebaseLink:dynamicLink];
                    }];
    
    NSLog(@"%i",handled);
    return handled;
}

- (void)handleFirebaseLink:(FIRDynamicLink*)dynamicLink {
    NSRegularExpression* tokenRe = [NSRegularExpression regularExpressionWithPattern:@"token=(\\w+)" options:0 error:nil];
    [tokenRe enumerateMatchesInString:[dynamicLink.url absoluteString] options:0 range:NSMakeRange(0, [[dynamicLink.url absoluteString] length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *token = [[dynamicLink.url absoluteString] substringWithRange:[result rangeAtIndex:1]];
        [[APIManager sharedManager] setAccessToken:token Completion:^(Attendee * _Nonnull attendee) {
            
        } Failure:^(ErrorMessage * _Nonnull errorMessage) {
            
        }];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
