//
//  RightSideMenu.m
//  Idea Drop
//
//  Created by Manisha Roy on 07/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "RightSideMenu.h"

@interface RightSideMenu ()
{
    NSMutableArray *tableArray;
}
@end

@implementation RightSideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self setNeedsStatusBarAppearanceUpdate];
    UIApplication *app = (UIApplication *)[UIApplication sharedApplication];
    tableArray = [[app scheduledLocalNotifications] mutableCopy];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData:) name:@"UpdateNotification" object:nil];

}

-(void)reloadTableData:(NSNotification *)notificationInfo{
    UIApplication *app = (UIApplication *)[UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    NSDate *date = [NSDate date];

    [tableArray removeAllObjects];
    
        for (int i = 0; i<oldNotifications.count; i++) {
            UILocalNotification * notification = [oldNotifications objectAtIndex:i];
            NSDictionary *dic = notification.userInfo;
            
            if ([date compare:[dic objectForKey:DUE_DATE]] == NSOrderedDescending) {
                [app cancelLocalNotification:notification];
            }else if ([notification.fireDate compare: [date dateByAddingTimeInterval:3600*720]] == NSOrderedAscending) {
                [tableArray addObject:notification];
            }
        }
    
    [_tableView reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableArray.count;//[[[UIApplication sharedApplication] scheduledLocalNotifications] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell for menu
    NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *lbl1 = (UILabel *)[cell viewWithTag:1];
    UILabel *lbl2 = (UILabel *)[cell viewWithTag:2];

//    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *localNotification = [tableArray objectAtIndex:indexPath.row];
    
    // Display notification info
    [lbl1 setText:[localNotification.userInfo valueForKey:IDEA_NAME]];
    static NSDateFormatter *dateFormatter;
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy hh-mm a";
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];

    [lbl2 setText:[NSString stringWithFormat:@"Due time :%@", [dateFormatter stringFromDate:[localNotification.userInfo valueForKey:DUE_DATE]]]];
    
    cell.backgroundColor=[UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (IBAction)closePressed:(UIButton *)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
    }];
}


@end
