//
//  SideMenu.m
//  FixItApp
//
//  Created by webwerks on 2/24/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "SideMenu.h"

@interface SideMenu ()
{
}
@end

@implementation SideMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self setNeedsStatusBarAppearanceUpdate];
//    _icon.clipsToBounds = YES;
//    _icon.layer.cornerRadius = _icon.frame.size.height/2.0f;
//    _icon.layer.borderWidth = 3;
//    _icon.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell for menu
    NSString *CellIdentifier=[@"Cell" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.backgroundColor=[UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self closeOtherView];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    if(indexPath.row == 0){

        if (![[self.menuContainerViewController.centerViewController visibleViewController] isKindOfClass:[ViewController class]]) {
            ViewController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];

                [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
        }
    }else if (indexPath.row==1) {
        
        if (![[self.menuContainerViewController.centerViewController visibleViewController] isKindOfClass:[AddIdeaViewController class]]) {
            AddIdeaViewController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddIdeaViewController"];
            homeVc.isFromMenu = YES;
            [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
        }
    } else if (indexPath.row==2) {
        
        if (![[self.menuContainerViewController.centerViewController visibleViewController] isKindOfClass:[ListViewController class]]) {
            ListViewController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
            
            [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
        }
    }else if (indexPath.row==3) {
        
        if (![[self.menuContainerViewController.centerViewController visibleViewController] isKindOfClass:[PriorityController class]]) {
            PriorityController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"PriorityController"];
            
            [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
        }
    }
    
}

- (IBAction)closePressed:(UIButton *)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
}
@end
