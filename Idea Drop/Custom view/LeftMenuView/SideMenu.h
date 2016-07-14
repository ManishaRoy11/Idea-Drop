//
//  SideMenu.h
//  FixItApp
//
//  Created by webwerks on 2/24/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriorityController.h"

@interface SideMenu : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closePressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
