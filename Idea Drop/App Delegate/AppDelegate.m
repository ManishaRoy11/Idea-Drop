//
//  AppDelegate.m
//  Idea Drop
//
//  Created by Manisha Roy on 30/06/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "RightSideMenu.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    sleep(1);
    [Database datebaseInit];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) | UIUserNotificationTypeAlert];
//    }
//    
//    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
//    {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    UIStoryboard *storyboard;
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    _navController = [[UINavigationController alloc] initWithRootViewController:vc];
    SideMenu *leftMenuViewController=[storyboard instantiateViewControllerWithIdentifier:@"SideMenu"];
    RightSideMenu *rightMenuViewController=[storyboard instantiateViewControllerWithIdentifier:@"RightSideMenu"];
    MFSideMenuContainerViewController *container=[MFSideMenuContainerViewController containerWithCenterViewController:_navController leftMenuViewController:leftMenuViewController rightMenuViewController:rightMenuViewController];
    APP_DELEGATE.window.rootViewController = container;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark local notification

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    NSDictionary *dic = notification.userInfo;
    
    NSDate *date = [NSDate date];
    if ([date compare:[dic objectForKey:DUE_DATE]] == NSOrderedDescending) {
        [application cancelLocalNotification:notification];
    }else{
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:notification.alertTitle
                                           message:notification.alertBody
                                          delegate:nil cancelButtonTitle:@"Ok"
                                 otherButtonTitles: nil];
        [alert show];
    }

    application.applicationIconBadgeNumber = 0;

}
@end
