//
//  IdeaViewController.m
//  Idea Drop
//
//  Created by Manisha Roy on 01/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "IdeaViewController.h"

@interface IdeaViewController ()<PickerDelegate>
{
    NSMutableArray *ideaListArray,*listArray;
    NavigationBar *navBar;
    CustomPicker *picker;
    IdeaListTVCell *selectedCell;
    int selectedIndex, selectedCellIndex;
    SortView *sortView;

    AlertView *alertView;

}
@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    navBar = [[NavigationBar alloc] initWithNib];
    navBar.navigationTitle = [_selectedList valueForKey:LIST_NAME];
    [navBar defaultSetup];
    navBar.isback = YES;
    [navBar.menuIcon setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    if ([[_selectedList objectForKey:LIST_ID] intValue] == FIRST_LIST_ID) {
        navBar.backgroundColor = Color_E74C3C;

    }else if ([[_selectedList objectForKey:LIST_ID] intValue] == NEXT_LIST_ID) {
        navBar.backgroundColor = Color_E67E22;
        
    }else if ([[_selectedList objectForKey:LIST_ID] intValue] == LATER_LIST_ID) {
        navBar.backgroundColor = Color_2ECC71;
        
    }else if ([[_selectedList objectForKey:LIST_ID] intValue] == DONT_LIST_ID) {
        navBar.backgroundColor = Color_95A5A6;
        
    }else{
        navBar.backgroundColor = Color_21AA68;
    }
    
    
    navBar.notIcon.hidden = NO;
    [navBar.notIcon setImage:[UIImage imageNamed:@"sort"] forState:UIControlStateNormal];
    [navBar.notIcon addTarget:self action:@selector(sortListClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:navBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setNeedsStatusBarAppearanceUpdate];
    
    sortView = [[SortView alloc] initWithNib];
    sortView.frame = CGRectMake(SCREEN_WIDTH-210, 64, 200, 207);
    sortView.sortPurpose = 1;
    sortView.sourceArray = @[@"Name (A-Z)",@"Name (Z-A)", @"Due Date"];
    [sortView defaultSetup];
    [self.view addSubview:sortView];

    sortView.delegate = self;
    sortView.hidden = true;

    ideaListArray = [NSMutableArray new];
    
    listArray = [Database fetchAllList:@"0" isUncatReq:NO];
    
    for (int i = 0; i<listArray.count; i++) {
        NSDictionary * dic = [listArray objectAtIndex:i];
        if ([[dic valueForKey:LIST_NAME] isEqualToString:[_selectedList valueForKey:LIST_NAME]]) {
            [listArray removeObjectAtIndex:i];
            break;
        }
    }
    
    ideaListArray = [Database fetchIdea:0 withListId:[[_selectedList objectForKey:LIST_ID] integerValue] isCompletedNeeded:YES];
    
    [_tableView registerNib:[UINib nibWithNibName:@"IdeaListTVCell" bundle:nil] forCellReuseIdentifier:@"IdeaListTVCell"];

    
    //    [Database dbOperation:[NSString stringWithFormat:@"insert into idea_master(list_id,idea_name,is_completed) values(1,'manisha',0)"]];

}
-(void)viewWillAppear:(BOOL)animated
{

    if (ideaListArray.count == 0) {
        _emptyView.hidden = NO;
        _tableView.hidden = YES;
    }else{
        _emptyView.hidden = YES;
        _tableView.hidden = NO;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_tableView reloadData];

}

-(void)viewDidDisappear:(BOOL)animated{
    sortView.hidden = true;
}

-(IBAction)sortListClicked:(id)sender{
    sortView.hidden = !sortView.hidden;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableview Datasource & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (ideaListArray.count == 0) {
        _emptyView.hidden = NO;
        _tableView.hidden = YES;
    }
    return ideaListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IdeaListTVCell *cell = (IdeaListTVCell *)[tableView dequeueReusableCellWithIdentifier:@"IdeaListTVCell"];
    
    if (!cell) {
        cell = [[IdeaListTVCell alloc] init];
    }
    
    if ([[[ideaListArray objectAtIndex:indexPath.row] valueForKey:IS_COMPLETED] isEqualToString:@"0"]) {
        cell.matrixBtn.tag = indexPath.row;
        cell.moveBtn.tag = indexPath.row;
        cell.editBtn.tag = indexPath.row;
        cell.trashBtn.tag = indexPath.row;
        [cell.matrixBtn addTarget:self action:@selector(matrixPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.moveBtn addTarget:self action:@selector(movePressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.editBtn addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.trashBtn addTarget:self action:@selector(trashPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.halfCircleCell.layer.cornerRadius= cell.halfCircleCell.frame.size.height/2;
        cell.halfCircle_x.constant = cell.halfCircleCell.frame.size.height/2;
        cell.greenView_width.constant = 215-(cell.halfCircleCell.frame.size.height/2);
        
        UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc] init];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [recognizer addTarget:self action:@selector(recognizerLeft:)];
        [cell addGestureRecognizer:recognizer];
        
        recognizer = [[UISwipeGestureRecognizer alloc] init];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [recognizer addTarget:self action:@selector(recognizerRight:)];
        [cell addGestureRecognizer:recognizer];
        
        cell.titleLbl.text = [[ideaListArray objectAtIndex:indexPath.row] valueForKey:IDEA_NAME];
        cell.backgroundColor = [UIColor whiteColor];

    }else{
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[[ideaListArray objectAtIndex:indexPath.row] valueForKey:IDEA_NAME]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        [attributeString addAttribute:NSStrokeColorAttributeName
                                value:Color_3D3D3D
                                range:NSMakeRange(0, [attributeString length])];
        cell.titleLbl.attributedText = attributeString;
        cell.backgroundColor = Color_EAEAEA;
        
    }

    cell.ideaOptionView_x.constant = SCREEN_WIDTH;
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IdeaDetailController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"IdeaDetailController"];
    homeVc.selectedData = [ideaListArray objectAtIndex:indexPath.row];
    homeVc.listArray = listArray;
    homeVc.selectedList = _selectedList;
    [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
}

-(void) recognizerRight:(UISwipeGestureRecognizer *)gesture{
    
    IdeaListTVCell *cell = (IdeaListTVCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:0]];
    cell.ideaOptionView_x.constant = SCREEN_WIDTH;
    
    cell = (IdeaListTVCell *)gesture.view;
    cell.ideaOptionView_x.constant = SCREEN_WIDTH;
    
    selectedCellIndex = 100000;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void) recognizerLeft:(UISwipeGestureRecognizer *)gesture{
    
    IdeaListTVCell *cell = (IdeaListTVCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndex inSection:0]];
    
    cell.ideaOptionView_x.constant = SCREEN_WIDTH;
    
    cell = (IdeaListTVCell *)gesture.view;
    cell.ideaOptionView_x.constant = SCREEN_WIDTH - 210;
    selectedCellIndex = (int)cell.tag;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - IBAction (Cell buttons)

- (IBAction)trashPressed:(UIButton *)sender{
    
    alertView = [[AlertView alloc] initWithNib];
    alertView.titleLbl.text = @"Delete Idea";
    alertView.subTitleLbl.text = @"Are you sure you want to delete this idea?";
    alertView.okBtn.tag = 1;
    alertView.cancelBtn.tag = 0;
    [alertView.okBtn addTarget:self action:@selector(alertViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertView.cancelBtn addTarget:self action:@selector(alertViewAction:) forControlEvents:UIControlEventTouchUpInside];
    alertView.tag = sender.tag;
    
    alertView.viewWithInput.hidden = YES;
    [self.view addSubview:alertView];
    
}

- (IBAction)editPressed:(UIButton *)sender{
    [_tableView reloadData];
    AddIdeaViewController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddIdeaViewController"];
    homeVc.selectedData = [ideaListArray objectAtIndex:sender.tag];
    [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
}

- (IBAction)movePressed:(UIButton *)sender{
    
    if (listArray.count==0) {
        [ToastPopup toastInView:self.view withText:@"First create new list." withY:64];
        return;
    }
    
    selectedIndex = (int)sender.tag;
    picker = [[CustomPicker alloc] initWithNib];
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i = 0; i<listArray.count; i++) {
        NSDictionary * dic = [listArray objectAtIndex:i];
        [array addObject:[dic valueForKey:LIST_NAME]];
    }
    
    picker.pickerPurpose = MoveTo_Purpose;
    
    picker.dataSource = array;
    [picker defaultSetup];
    picker.delegate = self;
    [self.view addSubview:picker];
    
}

- (IBAction)matrixPressed:(UIButton *)sender{
    
    selectedIndex = (int)sender.tag;
    picker = [[CustomPicker alloc] initWithNib];
    NSMutableArray *array = [NSMutableArray new];
    
    [array addObject:@"Do First - Action"];
    [array addObject:@"Do Next - Action"];
    [array addObject:@"Do Later - Action"];
    [array addObject:@"Don't Do - No Action"];
    picker.pickerPurpose = Matrix_Purpose;
    
    picker.dataSource = array;
    [picker defaultSetup];
    picker.delegate = self;
    [self.view addSubview:picker];
    
}

#pragma mark - UIAlertview Delegate

-(void)alertViewAction:(UIButton *)buttonIndex{
    if (buttonIndex.tag == 1) {
        bool isFound = [Database dbOperation:[NSString stringWithFormat:@"delete from IDEA_MASTER where idea_id=%ld",[[[ideaListArray objectAtIndex:alertView.tag] valueForKey:IDEA_ID] integerValue]]];
        
        if (isFound){
            
            UIApplication *app = (UIApplication *)[UIApplication sharedApplication];
            NSArray *oldNotifications = [app scheduledLocalNotifications];
            
            for (int i = 0; i<oldNotifications.count; i++) {
                UILocalNotification * notification = [oldNotifications objectAtIndex:i];
                if ([[[ideaListArray objectAtIndex:alertView.tag] valueForKey:IDEA_ID] integerValue] == [[notification.userInfo valueForKey:IDEA_ID] integerValue]) {
                    [app cancelLocalNotification:notification];
                    break;
                }
            }
            [ideaListArray removeObjectAtIndex:alertView.tag];
            [_tableView reloadData];
            [ToastPopup toastInView:APP_DELEGATE.window withText:@"Successfully deleted idea." withY:64];
        }else{
            [ToastPopup toastInView:APP_DELEGATE.window withText:@"Error while deleting idea" withY:64];
            
        }
        
    }
    [alertView removeFromSuperview];
}

#pragma mark - PickerDelegate

-(void)pickerValue:(NSString *)selectedValue andPickerUse:(int)pickerUse{
    
    //    [self.view addGestureRecognizer:gesture];
    if (selectedValue) {
        
        if (pickerUse == Matrix_Purpose) {
            NSString *query = @"";
            if ([selectedValue isEqualToString:@"Do First - Action"]) {
                query = [NSString stringWithFormat:@"update idea_master set list_id = %d where idea_id=%ld",FIRST_LIST_ID, [[[ideaListArray objectAtIndex:selectedIndex] valueForKey:IDEA_ID] integerValue]];
            }else if ([selectedValue isEqualToString:@"Do Next - Action"]) {
                query = [NSString stringWithFormat:@"update idea_master set list_id = %d where idea_id=%ld",NEXT_LIST_ID, [[[ideaListArray objectAtIndex:selectedIndex] valueForKey:IDEA_ID] integerValue]];
            }else if ([selectedValue isEqualToString:@"Do Later - Action"]) {
                query = [NSString stringWithFormat:@"update idea_master set list_id = %d where idea_id=%ld",LATER_LIST_ID, [[[ideaListArray objectAtIndex:selectedIndex] valueForKey:IDEA_ID] integerValue]];
            }else if ([selectedValue isEqualToString:@"Don't Do - No Action"]) {
                query = [NSString stringWithFormat:@"update idea_master set list_id = %d where idea_id=%ld",DONT_LIST_ID, [[[ideaListArray objectAtIndex:selectedIndex] valueForKey:IDEA_ID] integerValue]];
            }
            bool isFound = [Database dbOperation:query];
            if (isFound){
                [ideaListArray removeObjectAtIndex:selectedIndex];
                [_tableView reloadData];
                [ToastPopup toastInView:self.view withText:[NSString stringWithFormat:@"Successfully added in '%@' matrix.",selectedValue] withY:64];
            }else{
                [ToastPopup toastInView:self.view withText:@"Error while adding in matrix" withY:64];
                
            }
        }else{
            NSString *query = @"";
            
            for (int i = 0; i<listArray.count; i++) {
                NSDictionary * dic = [listArray objectAtIndex:i];
                if ([[dic valueForKey:LIST_NAME] isEqualToString:selectedValue]) {
                    query = [NSString stringWithFormat:@"update idea_master set list_id = %ld where idea_id=%ld",[[dic valueForKey:LIST_ID] integerValue], [[[ideaListArray objectAtIndex:selectedIndex] valueForKey:IDEA_ID] integerValue]];
                    break;
                }
            }
            
            bool isFound = [Database dbOperation:query];
            if (isFound){
                [ideaListArray removeObjectAtIndex:selectedIndex];
                [_tableView reloadData];
                [ToastPopup toastInView:self.view withText:[NSString stringWithFormat:@"Successfully moved to '%@' list.",selectedValue] withY:64];
            }else{
                [ToastPopup toastInView:self.view withText:@"Error while moving to list" withY:64];
                
            }
        }
        
    }
    
}

#pragma mark - SortViewDelegate

-(void)sortOptionSelected:(NSString *)selectedValue sortViewUse:(int)use{
    NSSortDescriptor * sortDesc;
    
    if ([selectedValue isEqualToString:@"Name (A-Z)"]) {
        sortDesc = [NSSortDescriptor sortDescriptorWithKey:IDEA_NAME ascending:YES selector:@selector(caseInsensitiveCompare:)];
        
    }else if ([selectedValue isEqualToString:@"Name (Z-A)"]) {
        sortDesc = [NSSortDescriptor sortDescriptorWithKey:IDEA_NAME ascending:NO selector:@selector(caseInsensitiveCompare:)];
        
    }else if ([selectedValue isEqualToString:@"Due Date"]) {
        
        sortDesc = [[NSSortDescriptor alloc] initWithKey:DUE_DATE ascending:YES];
        
    }
    ideaListArray=[[ideaListArray sortedArrayUsingDescriptors:@[sortDesc]] mutableCopy];
    [_tableView reloadData];
}

@end
