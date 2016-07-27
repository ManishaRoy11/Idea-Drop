//
//  ListViewController.m
//  Idea Drop
//
//  Created by Manisha Roy on 01/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()
{
    NavigationBar *navBar;
    NSMutableArray *listArray;
    AlertView *alertView;
    SortView *sortView;
    int selectedIndex, selectedCellIndex;
    NSMutableArray *defaultArray;

}
@end

@implementation ListViewController
@synthesize upArrow;

- (void)viewDidLoad {
    [super viewDidLoad];
    navBar = [[NavigationBar alloc] initWithNib];
    navBar.navigationTitle = @"List";
    [navBar.menuIcon setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [navBar defaultSetup];
    navBar.backgroundColor = Color_21AA68;
    navBar.addListBtn.hidden = NO;
    [navBar.menuIcon addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navBar.notIcon addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];

    [navBar.addListBtn addTarget:self action:@selector(addListClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBar];
    navBar.sortBtn.hidden = NO;
    [navBar.sortBtn addTarget:self action:@selector(sortListClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    listArray = [Database fetchAllList:@"0" isUncatReq:YES];
    defaultArray = listArray;
    
    sortView = [[SortView alloc] initWithNib];
    sortView.frame = CGRectMake(SCREEN_WIDTH-210, 75, 200, 210);
    sortView.sourceArray = @[@"Default",@"Name (A-Z)",@"Name (Z-A)"];
    sortView.sortPurpose = 1;
    [sortView defaultSetup];
    [self.view addSubview:sortView];

    [_tableView registerNib:[UINib nibWithNibName:@"ListTVCell" bundle:nil] forCellReuseIdentifier:@"ListTVCell"];

    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(void)viewWillAppear:(BOOL)animated{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    sortView.delegate = self;
    sortView.hidden = true;
    upArrow.hidden = true;
}

-(void)viewDidAppear:(BOOL)animated{
    [_tableView reloadData];

}

-(void)viewDidDisappear:(BOOL)animated{
    sortView.delegate = nil;
    sortView.hidden = true;
    upArrow.hidden = true;

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)menuClicked:(id)sender{
    if (sender == navBar.notIcon) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateNotification" object:self];

        [self.menuContainerViewController toggleRightSideMenuCompletion:^{}];
    }else
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
    
}

-(IBAction)addListClicked:(id)sender{
    
    alertView = [[AlertView alloc] initWithNib];
    alertView.textView.text = @"";
    alertView.textView.delegate = self;
    alertView.okBtn1.tag = 1;
    alertView.cancelBtn1.tag = 0;
    alertView.tag = 100000;
    [alertView.okBtn1 addTarget:self action:@selector(alertViewEditAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertView.cancelBtn1 addTarget:self action:@selector(alertViewEditAction:) forControlEvents:UIControlEventTouchUpInside];
    
    alertView.viewWithLabel.hidden = YES;
    [alertView.textView becomeFirstResponder];

    [self.view addSubview:alertView];
    
}

-(IBAction)sortListClicked:(id)sender{
    sortView.hidden = !sortView.hidden;
    upArrow.hidden = !upArrow.hidden;
}

#pragma mark - UITableview Datasource & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTVCell *cell = (ListTVCell *)[tableView dequeueReusableCellWithIdentifier:@"ListTVCell"];
    
    if (!cell) {
        cell = [[ListTVCell alloc] init];
    }
    
    cell.editBtn.tag = indexPath.row;
    cell.trashBtn.tag = indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.trashBtn addTarget:self action:@selector(trashPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.ideaOptionView_x.constant = SCREEN_WIDTH;
    cell.halfCircleCell.layer.cornerRadius= cell.halfCircleCell.frame.size.height/2;
    cell.halfCircle_x.constant = cell.halfCircleCell.frame.size.height/2;
    
    UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc] init];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [recognizer addTarget:self action:@selector(recognizerLeft:)];
    [cell addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] init];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [recognizer addTarget:self action:@selector(recognizerRight:)];
    [cell addGestureRecognizer:recognizer];
    
    cell.tag = indexPath.row;
    
    if ([[[listArray objectAtIndex:indexPath.row] valueForKey:LIST_ID] integerValue]==CAPTURE_LIST_ID || [[[listArray objectAtIndex:indexPath.row] valueForKey:LIST_ID] integerValue]==UNCATEGORIZED_LIST_ID) {
        cell.rightArrow.hidden = NO;
    }else{
        cell.rightArrow.hidden = YES;
    }
    
    cell.titleLbl.text = [[listArray objectAtIndex:indexPath.row] valueForKey:LIST_NAME];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IdeaViewController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"IdeaViewController"];
    homeVc.selectedList = [listArray objectAtIndex:indexPath.row];
    
    [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
}

-(void) recognizerRight:(UISwipeGestureRecognizer *)gesture{
    
    ListTVCell *cell = (ListTVCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:0]];
    cell.ideaOptionView_x.constant = SCREEN_WIDTH;
    
    cell = (ListTVCell *)gesture.view;
    cell.ideaOptionView_x.constant = SCREEN_WIDTH;
    
    selectedCellIndex = 100000;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void) recognizerLeft:(UISwipeGestureRecognizer *)gesture{
    
    ListTVCell *cell = (ListTVCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:0]];
    
    cell.ideaOptionView_x.constant = SCREEN_WIDTH;
    
    cell = (ListTVCell *)gesture.view;
    if ([[[listArray objectAtIndex:cell.tag] valueForKey:LIST_ID] integerValue]==CAPTURE_LIST_ID || [[[listArray objectAtIndex:cell.tag] valueForKey:LIST_ID] integerValue]==UNCATEGORIZED_LIST_ID) {
        return;
    }
    
    selectedCellIndex = (int)cell.tag;

    cell.ideaOptionView_x.constant = SCREEN_WIDTH - 140;
    

    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - IBAction (Cell buttons)

- (IBAction)trashPressed:(UIButton *)sender{
    alertView = [[AlertView alloc] initWithNib];
    alertView.titleLbl.text = @"Delete List";
    alertView.subTitleLbl.text = @"Are you sure you want to delete this list?\nNote: All ideas from this will get deleted.";
    alertView.okBtn.tag = 1;
    alertView.cancelBtn.tag = 0;
    [alertView.okBtn addTarget:self action:@selector(alertViewDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertView.cancelBtn addTarget:self action:@selector(alertViewDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    alertView.tag = sender.tag;
    
    alertView.viewWithInput.hidden = YES;
    [self.view addSubview:alertView];
    
}

- (IBAction)editPressed:(UIButton *)sender{
    
    alertView = [[AlertView alloc] initWithNib];
    alertView.textView.text = [[listArray objectAtIndex:sender.tag] valueForKey:LIST_NAME];
    alertView.textView.delegate = self;
    alertView.okBtn1.tag = 1;
    alertView.cancelBtn1.tag = 0;
    alertView.tag = sender.tag;
    [alertView.okBtn1 addTarget:self action:@selector(alertViewEditAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertView.cancelBtn1 addTarget:self action:@selector(alertViewEditAction:) forControlEvents:UIControlEventTouchUpInside];
    
    alertView.viewWithLabel.hidden = YES;
    [alertView.textView becomeFirstResponder];

    [self.view addSubview:alertView];
}

#pragma mark - UITextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertview Delegate

-(void)alertViewEditAction:(UIButton *)buttonIndex{
    if (buttonIndex.tag == 1) {
        if ([alertView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
            
            BOOL isFound = false;
            
            isFound = [Database checkAlreadyEsistingRec:[NSString stringWithFormat:@"select count(LIST_NAME) from LIST_MASTER where LIST_NAME='%@'",alertView.textView.text]];
            
            if (isFound) {
                [ToastPopup toastInView:self.view withText:[NSString stringWithFormat:@"List with name '%@' already existing.",alertView.textView.text] withY:64];
                
            }else{
                
                if (alertView.tag == 100000) {
                    isFound = [Database dbOperation:[NSString stringWithFormat:@"insert into list_master(LIST_NAME, IS_MATRIX) values ('%@',0)",alertView.textView.text]];
                    if (isFound){
                        listArray = [Database fetchAllList:@"0" isUncatReq:YES];
                        [_tableView reloadData];
                        
                        [ToastPopup toastInView:self.view withText:[NSString stringWithFormat:@"Created new list named."] withY:64];
                    }else{
                        [ToastPopup toastInView:self.view withText:@"Error while creating list" withY:64];
                        
                    }
                    
                }else{
                    isFound = [Database dbOperation:[NSString stringWithFormat:@"update list_master set LIST_NAME = '%@' where LIST_ID=%ld",alertView.textView.text, [[[listArray objectAtIndex:alertView.tag] valueForKey:LIST_ID] integerValue]]];
                    
                    if (isFound){
                        listArray = [Database fetchAllList:@"0" isUncatReq:YES];
                        [_tableView reloadData];
                        
                        [ToastPopup toastInView:self.view withText:[NSString stringWithFormat:@"Successfully updated list."] withY:64];
                    }else{
                        [ToastPopup toastInView:self.view withText:@"Error while updating list name" withY:64];
                        
                    }
                }

            }
            
        }
        else{
            [ToastPopup toastInView:self.view withText:@"List name cannot be empty." withY:64];
            
        }
        
    }
    [alertView removeFromSuperview];
}

-(void)alertViewDeleteAction:(UIButton *)buttonIndex{
    if (buttonIndex.tag == 1) {
        bool isFound = [Database dbOperation:[NSString stringWithFormat:@"delete from list_master where LIST_ID=%ld",[[[listArray objectAtIndex:alertView.tag] valueForKey:LIST_ID] integerValue]]];
        
        if (isFound){
            
            UIApplication *app = (UIApplication *)[UIApplication sharedApplication];
            NSArray *oldNotifications = [app scheduledLocalNotifications];
            
            for (int i = 0; i<oldNotifications.count; i++) {
                UILocalNotification * notification = [oldNotifications objectAtIndex:i];
                if ([[[listArray objectAtIndex:alertView.tag] valueForKey:LIST_ID] integerValue] == [[notification.userInfo valueForKey:LIST_ID] integerValue]) {
                    [app cancelLocalNotification:notification];
                }
            }
            
            isFound = [Database dbOperation:[NSString stringWithFormat:@"delete from idea_master where LIST_ID=%ld",[[[listArray objectAtIndex:alertView.tag] valueForKey:LIST_ID] integerValue]]];
            
            listArray = [Database fetchAllList:@"0" isUncatReq:YES];
            [_tableView reloadData];
            
            [ToastPopup toastInView:APP_DELEGATE.window withText:@"Successfully deleted list." withY:64];
        }else{
            [ToastPopup toastInView:APP_DELEGATE.window withText:@"Error while deleting list" withY:64];
            
        }
        
    }
    [alertView removeFromSuperview];
}

#pragma mark - SortViewDelegate

-(void)sortOptionSelected:(NSString *)selectedValue sortViewUse:(int)use{
    NSSortDescriptor * sortDesc;
    
    if ([selectedValue isEqualToString:@"Default"]) {
        listArray = defaultArray;
    }

    if ([selectedValue isEqualToString:@"Name (A-Z)"]) {
        sortDesc = [NSSortDescriptor sortDescriptorWithKey:LIST_NAME ascending:YES selector:@selector(caseInsensitiveCompare:)];
        listArray=[[listArray sortedArrayUsingDescriptors:@[sortDesc]] mutableCopy];


    }else if ([selectedValue isEqualToString:@"Name (Z-A)"]) {
        sortDesc = [NSSortDescriptor sortDescriptorWithKey:LIST_NAME ascending:NO selector:@selector(caseInsensitiveCompare:)];
        listArray=[[listArray sortedArrayUsingDescriptors:@[sortDesc]] mutableCopy];

        
    }
    [_tableView reloadData];
}

@end
