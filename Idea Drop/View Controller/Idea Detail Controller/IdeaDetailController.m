//
//  IdeaDetailController.m
//  Idea Drop
//
//  Created by Manisha Roy on 01/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "IdeaDetailController.h"

@interface IdeaDetailController ()<PickerDelegate>
{
    CustomPicker *picker;
    NavigationBar *navBar;
    AlertView *alertView;
}
@end

@implementation IdeaDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    navBar = [[NavigationBar alloc] initWithNib];
    navBar.navigationTitle = @"Idea Detail";
    [navBar defaultSetup];
    navBar.isback = YES;
    
    [navBar.menuIcon setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [navBar.notIcon setImage:[UIImage imageNamed:@"options"] forState:UIControlStateNormal];
    [navBar.notIcon addTarget:self action:@selector(optionsPressed:) forControlEvents:UIControlEventTouchUpInside];
    
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
    }    navBar.isOption = YES;
    [self.view addSubview:navBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.delegate = self;
    [tap setCancelsTouchesInView:NO];
    [self.optionView addGestureRecognizer:tap];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.textView  setTextContainerInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    
}

-(void)viewWillAppear:(BOOL)animated{
    _optionView.hidden = YES;

    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView reloadData];
    
    NSMutableArray *array = [Database fetchIdea:[[_selectedData valueForKey:IDEA_ID] integerValue] withListId:0 isCompletedNeeded:0];
    if (array.count > 0) {
        _selectedData = [array firstObject];
    }
    
    UIFont *font = [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:16];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 0.5 * font.lineHeight;
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSBackgroundColorAttributeName:[UIColor clearColor],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 };
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[_selectedData valueForKey:IDEA_NAME]] attributes:attributes];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:Color_21AA68 range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:16] range:NSMakeRange(0,attributedString.length)];
    
    //add due date
    
    static NSDateFormatter *dateFormatter;
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    
    NSString *str1 = @"Due Date : ";
    NSString *str2 = [dateFormatter stringFromDate:[_selectedData valueForKey:DUE_DATE]];
    if ([str2 isEqualToString:@"01-01-1970"]) {
        str2 = @"";
    }
    
    NSMutableAttributedString * newString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@%@",str1, str2] attributes:attributes];
    
    [newString addAttribute:NSForegroundColorAttributeName value:Color_3D3D3D range:NSMakeRange(0, str1.length)];
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:16] range:NSMakeRange(0,str1.length)];
    
    [newString addAttribute:NSForegroundColorAttributeName value:Color_505050 range:NSMakeRange(str1.length+1, str2.length)];
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:16] range:NSMakeRange(str1.length+1,str2.length)];
    
    [attributedString appendAttributedString:newString];
    
    //add due time
    
    str1 = @"Due Time : ";
    str2 = [_selectedData valueForKey:DUE_TIME];
    
    newString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@%@",str1, str2] attributes:attributes];
    
    [newString addAttribute:NSForegroundColorAttributeName value:Color_3D3D3D range:NSMakeRange(0, str1.length)];
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:16] range:NSMakeRange(0,str1.length)];
    
    [newString addAttribute:NSForegroundColorAttributeName value:Color_505050 range:NSMakeRange(str1.length+1, str2.length)];
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:16] range:NSMakeRange(str1.length+1,str2.length)];
    
    [attributedString appendAttributedString:newString];
    
    
    //add reminder
    
    str1 = @"Reminder : ";
    str2 = [_selectedData valueForKey:REMINDER];
    
    newString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@%@",str1, str2] attributes:attributes];
    
    [newString addAttribute:NSForegroundColorAttributeName value:Color_3D3D3D range:NSMakeRange(0, str1.length)];
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:16] range:NSMakeRange(0,str1.length)];
    
    [newString addAttribute:NSForegroundColorAttributeName value:Color_505050 range:NSMakeRange(str1.length+1, str2.length)];
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:16] range:NSMakeRange(str1.length+1,str2.length)];
    
    [attributedString appendAttributedString:newString];
    
    
    //add Repeat
    
    str1 = @"Repeat : ";
    str2 = [_selectedData valueForKey:REPEAT];
    
    newString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@%@",str1, str2] attributes:attributes];
    
    [newString addAttribute:NSForegroundColorAttributeName value:Color_3D3D3D range:NSMakeRange(0, str1.length)];
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:16] range:NSMakeRange(0,str1.length)];
    
    [newString addAttribute:NSForegroundColorAttributeName value:Color_505050 range:NSMakeRange(str1.length+1, str2.length)];
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:16] range:NSMakeRange(str1.length+1,str2.length)];
    
    [attributedString appendAttributedString:newString];
    
    self.textView.attributedText = attributedString;
    
    CGFloat fixedWidth = _textView.frame.size.width;
    CGSize newSize = [_textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = _textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    _textView.frame = newFrame;
    if (newFrame.size.height < (SCREEN_HEIGHT-64)) {
        _detail_height.constant = newFrame.size.height;
    }else
        _detail_height.constant = (SCREEN_HEIGHT-64);

    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
}

-(void)tapGesture:(UITapGestureRecognizer *)gesture{
    [self optionsPressed:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)optionsPressed:(UIButton *)sender{
    _optionView.hidden = !_optionView.hidden;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_selectedData valueForKey:IS_COMPLETED] isEqualToString:@"1"]) {
        return 1;
    }
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell for menu
    NSString *CellIdentifier;
    if ([[_selectedData valueForKey:IS_COMPLETED] isEqualToString:@"1"]) {
        CellIdentifier=[@"Cell" stringByAppendingString:@"3"];
    }
    else
        CellIdentifier=[@"Cell" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_selectedData valueForKey:IS_COMPLETED] isEqualToString:@"1"]) {
        
        alertView = [[AlertView alloc] initWithNib];
        alertView.titleLbl.text = @"Delete Idea";
        alertView.subTitleLbl.text = @"Are you sure you want to delete this idea?";
        alertView.okBtn.tag = 1;
        alertView.cancelBtn.tag = 0;
        [alertView.okBtn addTarget:self action:@selector(alertViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [alertView.cancelBtn addTarget:self action:@selector(alertViewAction:) forControlEvents:UIControlEventTouchUpInside];
        alertView.viewWithInput.hidden = YES;
        [self.view addSubview:alertView];
        
    }else{
        if (indexPath.row == 0){
            
            if (_listArray.count==0) {
                [ToastPopup toastInView:self.view withText:@"First create new list." withY:64];
                return;
            }
            
            picker = [[CustomPicker alloc] initWithNib];
            NSMutableArray *array = [NSMutableArray new];
            
            for (int i = 0; i<_listArray.count; i++) {
                NSDictionary * dic = [_listArray objectAtIndex:i];
                [array addObject:[dic valueForKey:LIST_NAME]];
            }
            
            picker.pickerPurpose = MoveTo_Purpose;
            
            picker.dataSource = array;
            [picker defaultSetup];
            picker.delegate = self;
            [self.view addSubview:picker];
            
        }else if (indexPath.row == 1){
            
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
            
        }else if (indexPath.row == 2){
            
            AddIdeaViewController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddIdeaViewController"];
            homeVc.selectedData = _selectedData;
            [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
            
        }else if (indexPath.row == 3){
            
            alertView = [[AlertView alloc] initWithNib];
            alertView.titleLbl.text = @"Delete Idea";
            alertView.subTitleLbl.text = @"Are you sure you want to delete this idea?";
            alertView.okBtn.tag = 1;
            alertView.cancelBtn.tag = 0;
            [alertView.okBtn addTarget:self action:@selector(alertViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [alertView.cancelBtn addTarget:self action:@selector(alertViewAction:) forControlEvents:UIControlEventTouchUpInside];
            alertView.viewWithInput.hidden = YES;
            [self.view addSubview:alertView];
            
        }else if (indexPath.row == 4){
            
            NSString* query = [NSString stringWithFormat:@"update idea_master set IS_COMPLETED = 1 where idea_id=%ld", [[_selectedData valueForKey:IDEA_ID] integerValue]];
            
            bool isFound = [Database dbOperation:query];
            
            if (isFound){
                
                UIApplication *app = (UIApplication *)[UIApplication sharedApplication];
                NSArray *oldNotifications = [app scheduledLocalNotifications];
                
                for (int i = 0; i<oldNotifications.count; i++) {
                    UILocalNotification * notification = [oldNotifications objectAtIndex:i];
                    if ([[_selectedData valueForKey:IDEA_ID] integerValue] == [[notification.userInfo valueForKey:IDEA_ID] integerValue]) {
                        [app cancelLocalNotification:notification];
                        break;
                    }
                }
                
                if ([[_selectedData valueForKey:LIST_ID] integerValue] == CAPTURE_LIST_ID) {
                    query = [NSString stringWithFormat:@"update idea_master set list_id = %d where idea_id=%ld",UNCATEGORIZED_LIST_ID ,[[_selectedData valueForKey:IDEA_ID] integerValue]];
                    
                    [Database dbOperation:query];
                }
                
                [ToastPopup toastInView:APP_DELEGATE.window withText:@"Successfully completed the idea." withY:64];
                [_selectedData setValue:@"1" forKey:IS_COMPLETED];
                [self optionsPressed:nil];
                [_tableView reloadData];
            }else{
                [ToastPopup toastInView:APP_DELEGATE.window withText:@"Error while completing in idea" withY:64];
                
            }
            
        }
    }
}

#pragma mark - UIAlertview Delegate

-(void)alertViewAction:(UIButton *)buttonIndex{
    if (buttonIndex.tag == 1) {
        bool isFound = [Database dbOperation:[NSString stringWithFormat:@"delete from IDEA_MASTER where idea_id=%ld",[[_selectedData valueForKey:IDEA_ID] integerValue]]];
        
        if (isFound){
            
            UIApplication *app = (UIApplication *)[UIApplication sharedApplication];
            NSArray *oldNotifications = [app scheduledLocalNotifications];
            
            for (int i = 0; i<oldNotifications.count; i++) {
                UILocalNotification * notification = [oldNotifications objectAtIndex:i];
                if ([[_selectedData valueForKey:IDEA_ID] integerValue] == [[notification.userInfo valueForKey:IDEA_ID] integerValue]) {
                    [app cancelLocalNotification:notification];
                    break;
                }
            }
            
            [self.menuContainerViewController.centerViewController popViewControllerAnimated:YES];

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
                query = [NSString stringWithFormat:@"update idea_master set list_id = %d where idea_id=%ld",FIRST_LIST_ID, [[_selectedData valueForKey:IDEA_ID] integerValue]];
            }else if ([selectedValue isEqualToString:@"Do Next - Action"]) {
                query = [NSString stringWithFormat:@"update idea_master set list_id = %d where idea_id=%ld",NEXT_LIST_ID, [[_selectedData valueForKey:IDEA_ID] integerValue]];
            }else if ([selectedValue isEqualToString:@"Do Later - Action"]) {
                query = [NSString stringWithFormat:@"update idea_master set list_id = %d where idea_id=%ld",LATER_LIST_ID, [[_selectedData valueForKey:IDEA_ID] integerValue]];
            }else if ([selectedValue isEqualToString:@"Don't Do - No Action"]) {
                query = [NSString stringWithFormat:@"update idea_master set list_id = %d where idea_id=%ld",DONT_LIST_ID, [[_selectedData valueForKey:IDEA_ID] integerValue]];
            }
            bool isFound = [Database dbOperation:query];
            if (isFound){
                [ToastPopup toastInView:APP_DELEGATE.window withText:[NSString stringWithFormat:@"Successfully added in '%@' matrix.",selectedValue] withY:64];
            }else{
                [ToastPopup toastInView:APP_DELEGATE.window withText:@"Error while adding in matrix" withY:64];
                
            }
        }else{
            NSString *query = @"";
            
            for (int i = 0; i<_listArray.count; i++) {
                NSDictionary * dic = [_listArray objectAtIndex:i];
                if ([[dic valueForKey:LIST_NAME] isEqualToString:selectedValue]) {
                    query = [NSString stringWithFormat:@"update idea_master set list_id = %ld where idea_id=%ld",[[dic valueForKey:LIST_ID] integerValue], [[_selectedData valueForKey:IDEA_ID] integerValue]];
                    break;
                }
            }
            
            bool isFound = [Database dbOperation:query];
            if (isFound){
                [self.menuContainerViewController.centerViewController popViewControllerAnimated:YES];

                [ToastPopup toastInView:APP_DELEGATE.window withText:[NSString stringWithFormat:@"Successfully moved to '%@' list.",selectedValue] withY:64];
            }else{
                [ToastPopup toastInView:APP_DELEGATE.window withText:@"Error while moving to list" withY:64];
                
            }
        }
        
    }
    
}

@end
