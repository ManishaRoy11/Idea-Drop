//
//  AppDelegate.h
//  Idea Drop
//
//  Created by Manisha Roy on 30/06/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabaseQueue.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FMDatabaseQueue *DBQueue;
@property(strong,nonatomic) UINavigationController *navController;


@end

