//
//  AddIdeaViewController.m
//  Idea Drop
//
//  Created by Manisha Roy on 04/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "AddIdeaViewController.h"

@interface AddIdeaViewController ()<PickerDelegate>
{
    CustomPicker *picker;

    NavigationBar *navBar;
    UITapGestureRecognizer *gesture;
    
}
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSCalendar *calendar;
@property (nonatomic,strong) NSDate *date;
@end

@implementation AddIdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    navBar = [[NavigationBar alloc] initWithNib];
    if (_selectedData) {
        navBar.navigationTitle = @"Edit Idea";
    }else
        navBar.navigationTitle = @"Add Idea";
    [navBar defaultSetup];
    navBar.isback = YES;
    
    if (!_isFromMenu) {
        [navBar.menuIcon setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
    }else{
        [navBar.menuIcon setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        
        [navBar.menuIcon addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    navBar.backgroundColor = Color_21AA68;
    navBar.notIcon.hidden = YES;
    [self.view addSubview:navBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:gesture];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TextViewCell" bundle:nil] forCellReuseIdentifier:@"TextViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"Date_TimeCell" bundle:nil] forCellReuseIdentifier:@"Date_TimeCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ReminderCell" bundle:nil] forCellReuseIdentifier:@"ReminderCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)tapGesture:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}

-(IBAction)menuClicked:(id)sender{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
    
}

#pragma mark - UITableview Datasource & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (IS_IPHONE_6) {
            return 222;
        }
        if (IS_IPHONE_6_PLUS) {
            return 272;
        }
        return 172;
    }else if (indexPath.row < 3){
        if (IS_IPHONE_6) {
            return 54;
        }
        if (IS_IPHONE_6_PLUS) {
            return 64;
        }
        return 44;
    }
    if (IS_IPHONE_6) {
        return 80;
    }
    if (IS_IPHONE_6_PLUS) {
        return 90;
    }
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        TextViewCell *cell = (TextViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TextViewCell"];
        
        if (!cell) {
            cell = [[TextViewCell alloc] init];
        }
        
        cell.textView.layer.cornerRadius = 2;
        if (_selectedData) {
            cell.textView.text = [_selectedData valueForKey:IDEA_NAME];
        }else
            cell.textView.text = @"";
        //        cell.textView.delegate = self;
        
        cell.textView.delegate = self;
        
//        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:@"Done" forState:UIControlStateNormal];
//        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
//        [button addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
//        button.layer.backgroundColor = Color_21AA68.CGColor;
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
        barButton.tintColor = Color_21AA68;
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil action:nil];
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar sizeToFit];
        toolbar.items = [NSArray arrayWithObjects:flexBarButton,barButton,flexBarButton,nil];
        toolbar.backgroundColor = Color_21AA68;
        
        cell.textView.inputAccessoryView = toolbar;
        
        if (!_selectedData) {
            [cell.textView becomeFirstResponder];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = 1000 + indexPath.row;
        return cell;
    }
    else if (indexPath.row < 3){
        Date_TimeCell *cell = (Date_TimeCell *)[tableView dequeueReusableCellWithIdentifier:@"Date_TimeCell"];
        
        if (!cell) {
            cell = [[Date_TimeCell alloc] init];
        }
        
        if (indexPath.row == 1) {
            cell.titleLbl.text = @"Due date :";
            if (_selectedData) {
                static NSDateFormatter *dateFormatter;
                dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat = @"dd-MM-yyyy";
                dateFormatter.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"GMT"];

                NSString *str = [dateFormatter stringFromDate:[_selectedData valueForKey:DUE_DATE]];
                
                if (![str isEqualToString:@"01-01-1970"]) {
                    _selectedDate = [_selectedData valueForKey:DUE_DATE];
                    
                    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                    [dateFormatter setTimeZone:timeZone];
                    str = [dateFormatter stringFromDate:[_selectedData valueForKey:DUE_DATE]];
                    
                    [cell.btn setTitle:str forState:UIControlStateNormal];
                }
            }
            
        }else{
            cell.titleLbl.text = @"Due time :";
            if (_selectedData) {
                if (![[_selectedData valueForKey:DUE_TIME] isEqualToString:@""]) {
                    
                    [cell.btn setTitle:[_selectedData valueForKey:DUE_TIME] forState:UIControlStateNormal];
                }
            }
        }
        
        cell.btn.tag = indexPath.row;
        cell.btn.layer.cornerRadius = 2;
        cell.btn.clipsToBounds = YES;
        [cell.btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 42)];
        [cell.btn addTarget:self action:@selector(openCalendarOrTime:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([cell.btn titleForState:UIControlStateNormal].length>0) {
            cell.refrshBtn.hidden = false;
        }else{
            cell.refrshBtn.hidden = true;
        }
        
        
        
        cell.refrshBtn.tag = indexPath.row;
        [cell.refrshBtn addTarget:self action:@selector(clearSelectedCell:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tag = 1000 + indexPath.row;
        return cell;
    }
    ReminderCell *cell = (ReminderCell *)[tableView dequeueReusableCellWithIdentifier:@"ReminderCell"];
    
    if (!cell) {
        cell = [[ReminderCell alloc] init];
    }
    
    cell.sliderBtn.tag = indexPath.row;
    cell.valueBtn.tag = indexPath.row;
    
    if (indexPath.row == 3) {
        cell.titleLbl.text = @"Reminder";
        if (_selectedData) {
            if (![[_selectedData valueForKey:REMINDER] isEqualToString:@""]) {
                [self sliderPressed:cell.sliderBtn];
                [cell.valueBtn setTitle:[_selectedData valueForKey:REMINDER] forState:UIControlStateNormal];
                [cell.valueBtn setTitleColor:Color_9E9E9E forState:UIControlStateNormal];

            }
        }
    }else{
        if (_selectedData) {
            if (![[_selectedData valueForKey:REPEAT] isEqualToString:@""]) {
                [self sliderPressed:cell.sliderBtn];
                [cell.valueBtn setTitle:[_selectedData valueForKey:REPEAT] forState:UIControlStateNormal];
                [cell.valueBtn setTitleColor:Color_9E9E9E forState:UIControlStateNormal];

            }
        }
        cell.titleLbl.text = @"Repeat";
    }

    [cell.sliderBtn setImage:[UIImage imageNamed:@"slider off"] forState:UIControlStateNormal];
    [cell.sliderBtn setImage:[UIImage imageNamed:@"slider on"] forState:UIControlStateSelected];
    [cell.sliderBtn addTarget:self action:@selector(sliderPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.valueBtn addTarget:self action:@selector(openCustomPicker:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.valueBtn.layer.cornerRadius = 2;
    cell.valueBtn.clipsToBounds = YES;
    [cell.valueBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 32 )];
    
    
    if (![[cell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"]) {
        cell.refrshBtn.hidden = false;
    }else{
        cell.refrshBtn.hidden = true;
    }
    
    cell.refrshBtn.tag = indexPath.row;
    [cell.refrshBtn addTarget:self action:@selector(clearSelectedCell:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = 1000 + indexPath.row;
    return cell;
}

#pragma mark - UITextView Delegate

- (IBAction)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - IBAction

-(void)clearSelectedCell:(UIButton *)sender{
    
//    Date_TimeCell *dateCell =  (Date_TimeCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//
//    Date_TimeCell *timeCell =  (Date_TimeCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    
//    ReminderCell *reminderCell =  (ReminderCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//    
//    ReminderCell *repeatCell =  (ReminderCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    Date_TimeCell *dateCell =  (Date_TimeCell *)[_tableView viewWithTag:1001];
    
    Date_TimeCell *timeCell =  (Date_TimeCell *)[_tableView viewWithTag:1002];
    
    ReminderCell *reminderCell =  (ReminderCell *)[_tableView viewWithTag:1003];
    
    ReminderCell *repeatCell =  (ReminderCell *)[_tableView viewWithTag:1004];

    if (sender.tag == 1) {
        [dateCell.btn setTitle:@"" forState:UIControlStateNormal];
        _selectedDate = nil;
        dateCell.refrshBtn.hidden = true;

//        [timeCell.btn setTitle:@"" forState:UIControlStateNormal];
//
//        timeCell.refrshBtn.hidden = true;
//        reminderCell.refrshBtn.hidden = true;
//        repeatCell.refrshBtn.hidden = true;
//        
//        [reminderCell.valueBtn setTitle:@"Select" forState:UIControlStateNormal];
//        [reminderCell.valueBtn setTitleColor:Color_9E9E9E forState:UIControlStateNormal];
//        reminderCell.sliderBtn.selected = false;
//        
//        [repeatCell.valueBtn setTitle:@"Select" forState:UIControlStateNormal];
//        [repeatCell.valueBtn setTitleColor:Color_9E9E9E forState:UIControlStateNormal];
//        repeatCell.sliderBtn.selected = false;

    
    }else if (sender.tag == 2){
        [timeCell.btn setTitle:@"" forState:UIControlStateNormal];
        
        timeCell.refrshBtn.hidden = true;
        
//        reminderCell.refrshBtn.hidden = true;
//        repeatCell.refrshBtn.hidden = true;
//        
//        [reminderCell.valueBtn setTitle:@"Select" forState:UIControlStateNormal];
//        [reminderCell.valueBtn setTitleColor:Color_9E9E9E forState:UIControlStateNormal];
//        reminderCell.sliderBtn.selected = false;
//        
//        [repeatCell.valueBtn setTitle:@"Select" forState:UIControlStateNormal];
//        [repeatCell.valueBtn setTitleColor:Color_9E9E9E forState:UIControlStateNormal];
//        repeatCell.sliderBtn.selected = false;
        
    }else if (sender.tag == 3){
        [self sliderPressed:reminderCell.sliderBtn];

        reminderCell.refrshBtn.hidden = true;

//        [self sliderPressed:repeatCell.sliderBtn];
//
//        repeatCell.refrshBtn.hidden = true;
        
    }else if (sender.tag == 4){
        [self sliderPressed:repeatCell.sliderBtn];

        repeatCell.refrshBtn.hidden = true;

    }
    
    
}

-(void)openCalendarOrTime:(UIButton *)sender{
    [self.view endEditing:YES];
    if (sender.tag == 1) {
        calView = [[CalendarView alloc] initWithNib];
        
        if (_selectedDate) {
            calView.selectedDate = _selectedDate;
        }
        
        [calView defaultSetup];
        calView.delegate = self;
        
        [self.view addSubview:calView];
        
    }if (sender.tag == 2) {
        clockView = [[ClockView alloc] initWithNib];
        [clockView defaultSetup];
        clockView.delegate = self;
        [self.view addSubview:clockView];
    }
}

-(void)openCustomPicker:(UIButton *)sender{
    [self.view endEditing:YES];

    [self.view removeGestureRecognizer:gesture];
    ReminderCell *cell ;
    
    if (sender.tag == 3) {
        cell =  (ReminderCell *)[_tableView viewWithTag:1003];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        if (!cell.sliderBtn.isSelected) {
            [ToastPopup toastInView:self.view withText:@"Please activate the reminder switch." withY:64];
            return;
        }
        
    }else{
        cell =  (ReminderCell *)[_tableView viewWithTag:1004];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        if (!cell.sliderBtn.isSelected) {
            [ToastPopup toastInView:self.view withText:@"Please activate the repeater switch." withY:64];
            return;
        }
        
    }
    
    picker = [[CustomPicker alloc] initWithNib];
    NSMutableArray *array = [NSMutableArray new];
    
    if (sender.tag == 3) {
        
        [array addObject:@"1 hour before"];
        [array addObject:@"6 hours before"];
        [array addObject:@"12 hours before"];
        [array addObject:@"1 day before"];
        [array addObject:@"1 week before"];
        picker.pickerPurpose = Reminder_Purpose;
        
    }if (sender.tag == 4) {
        
//        [array addObject:@"Daily"];
//        [array addObject:@"Weekly"];
//        [array addObject:@"Monthly"];
//        [array addObject:@"Six Months"];
        
        [array addObject:@"Hourly"];
        [array addObject:@"Daily"];
        [array addObject:@"Weekly"];
        [array addObject:@"Monthly"];
        
        picker.pickerPurpose = Repeater_purpose;
        
    }
    picker.dataSource = array;
    [picker defaultSetup];
    picker.delegate = self;
    [self.view addSubview:picker];
    
}

-(void)sliderPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    ReminderCell *cell =  (ReminderCell *)[_tableView viewWithTag:(1000+sender.tag)];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    
    if (sender.selected) {
        [cell.valueBtn setTitleColor:Color_3D3D3D forState:UIControlStateNormal];
    }else{
        [cell.valueBtn setTitle:@"Select" forState:UIControlStateNormal];
        [cell.valueBtn setTitleColor:Color_9E9E9E forState:UIControlStateNormal];
    }
}

- (IBAction)cancelPressed:(UIButton *)sender {
    if (_isFromMenu) {
        ViewController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
        [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
    }else{
        [self.menuContainerViewController.centerViewController popViewControllerAnimated:YES];
    }
}

- (IBAction)savePressed:(UIButton *)sender {
    TextViewCell *textCell =  (TextViewCell *)[_tableView viewWithTag:1000];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    Date_TimeCell *dateCell =  (Date_TimeCell *)[_tableView viewWithTag:1001];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    Date_TimeCell *timeCell =  (Date_TimeCell *)[_tableView viewWithTag:1002];[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    ReminderCell *reminderCell =  (ReminderCell *)[_tableView viewWithTag:1003];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    ReminderCell *repeatCell =  (ReminderCell *)[_tableView viewWithTag:1004];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    if ([textCell.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
        [ToastPopup toastInView:self.view withText:@"Please enter your idea." withY:64];
        return;
        
    }else if ([Database checkAlreadyEsistingRec:[NSString stringWithFormat:@"select count(IDEA_NAME) from IDEA_MASTER where IDEA_NAME='%@'",textCell.textView.text]] && ! _selectedData){
        [ToastPopup toastInView:self.view withText:@"idea with same description already existing" withY:64];
        return;
        
    }else if (([dateCell.btn titleForState:UIControlStateNormal].length>0) && ([timeCell.btn titleForState:UIControlStateNormal].length == 0)){
        [ToastPopup toastInView:self.view withText:@"Please give due time." withY:64];
        return;
        
    }else if (([timeCell.btn titleForState:UIControlStateNormal].length > 0) && ([dateCell.btn titleForState:UIControlStateNormal].length == 0)){
        [ToastPopup toastInView:self.view withText:@"Please give due date." withY:64];
        return;
        
    }else if (reminderCell.sliderBtn.selected && ([dateCell.btn titleForState:UIControlStateNormal].length==0)){
        [ToastPopup toastInView:self.view withText:@"Please give due time." withY:64];
        return;
        
    }else if (reminderCell.sliderBtn.selected && ([[reminderCell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"])){
        [ToastPopup toastInView:self.view withText:@"Please select reminder details." withY:64];
        return;
        
    }else if (repeatCell.sliderBtn.selected){
        
        if (!reminderCell.sliderBtn.selected) {
            [ToastPopup toastInView:self.view withText:@"Please activate the reminder switch." withY:64];
            return;
            
        }else if (reminderCell.sliderBtn.selected && ([[reminderCell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"])){
            [ToastPopup toastInView:self.view withText:@"Please select reminder details." withY:64];
            return;
            
        }else if ([[repeatCell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"]){
            [ToastPopup toastInView:self.view withText:@"Please select repeat details." withY:64];
            return;
        }
    }
    //add idea
    __block NSMutableDictionary *dic;
    FMDatabaseQueue *queueObj=[Database getDBQueue];
    __block BOOL response;
    [queueObj inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (_selectedData) {
            response =[db executeUpdate:@"update IDEA_MASTER set LIST_ID=?, IDEA_NAME=?, DUE_DATE=?, DUE_TIME=?, REMINDER=?, REPEAT=? where idea_id=?",[_selectedData valueForKey:LIST_ID],
                       textCell.textView.text,
                       [[COMMON_METHODS isStringNull:[dateCell.btn titleForState:UIControlStateNormal]] isEqualToString:@""]?@"":_selectedDate,
                       [COMMON_METHODS isStringNull:[timeCell.btn titleForState:UIControlStateNormal]],
                       [[reminderCell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"]?@"":[reminderCell.valueBtn titleForState:UIControlStateNormal],
                       [[repeatCell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"]?@"":[repeatCell.valueBtn titleForState:UIControlStateNormal],
                       [_selectedData valueForKey:IDEA_ID],nil];
        }else{
            response =[db executeUpdate:@"insert into IDEA_MASTER (LIST_ID, IDEA_NAME, DUE_DATE , DUE_TIME, REMINDER, REPEAT, IS_COMPLETED) values (1, ?, ?, ?, ?, ?, 0 )", textCell.textView.text,
                   [[COMMON_METHODS isStringNull:[dateCell.btn titleForState:UIControlStateNormal]] isEqualToString:@""]?@"":_selectedDate,
                   [COMMON_METHODS isStringNull:[timeCell.btn titleForState:UIControlStateNormal]],
                   [[reminderCell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"]?@"":[reminderCell.valueBtn titleForState:UIControlStateNormal],
                   [[repeatCell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"]?@"":[repeatCell.valueBtn titleForState:UIControlStateNormal],nil];

        }
        if(!response)
        {
            NSLog(@"Record %@",[db lastError].localizedDescription);
        }
        if (response) {
            
            UIApplication *app = (UIApplication *)[UIApplication sharedApplication];
            NSArray *oldNotifications = [app scheduledLocalNotifications];
            if (_selectedData) {
                for (int i = 0; i<oldNotifications.count; i++) {
                    UILocalNotification * notification = [oldNotifications objectAtIndex:i];
                    if ([[_selectedData valueForKey:IDEA_ID] integerValue] == [[notification.userInfo valueForKey:IDEA_ID] integerValue]) {
                        [app cancelLocalNotification:notification];
                        return;
                    }
                }
            }
            
            if (reminderCell.sliderBtn.selected) {
                
                dic = [NSMutableDictionary new];
                
                if (_selectedData) {
                    [dic setObject:[_selectedData objectForKey:IDEA_ID] forKey:IDEA_ID];
                }else{
                    [dic setObject:[NSString stringWithFormat:@"%d",(int)[db lastInsertRowId]] forKey:IDEA_ID];
                }
                
                static NSDateFormatter *dateFormatter;
                dateFormatter = [NSDateFormatter new];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                dateFormatter.timeZone=[NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                NSString *dateStr = [dateFormatter stringFromDate:_selectedDate];
                NSString *timeStr = [COMMON_METHODS isStringNull:[timeCell.btn titleForState:UIControlStateNormal]];
                
                if ([timeStr containsString:@"PM"] && ![[timeStr substringToIndex:2] isEqualToString:@"12"]) {
                    int x = [[timeStr substringToIndex:2] intValue];
                    x = x+12;
                    timeStr = [timeStr stringByReplacingOccurrencesOfString:[timeStr substringToIndex:2] withString:[NSString stringWithFormat:@"%d",x]];
                }
                timeStr = [timeStr substringToIndex:5];
                dateStr = [dateStr stringByReplacingOccurrencesOfString:[[dateStr substringToIndex:16] substringFromIndex:11] withString:timeStr];
                _selectedDate = [dateFormatter dateFromString:dateStr];

                [dic setObject:textCell.textView.text forKey:IDEA_NAME];
                [dic setObject:[[COMMON_METHODS isStringNull:[dateCell.btn titleForState:UIControlStateNormal]] isEqualToString:@""]?@"":_selectedDate==nil?@"":_selectedDate forKey:DUE_DATE];
                [dic setObject:[COMMON_METHODS isStringNull:[timeCell.btn titleForState:UIControlStateNormal]] forKey:DUE_TIME];
                [dic setObject:[[reminderCell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"]?@"":[reminderCell.valueBtn titleForState:UIControlStateNormal] forKey:REMINDER];
                [dic setObject:[[repeatCell.valueBtn titleForState:UIControlStateNormal] isEqualToString:@"Select"]?@"":[repeatCell.valueBtn titleForState:UIControlStateNormal] forKey:REPEAT];
                               
                UILocalNotification *alarm = [[UILocalNotification alloc] init];
                alarm.timeZone = [NSTimeZone localTimeZone];
                
                if (alarm)
                {
                    
                    if ([[dic valueForKey:REMINDER] isEqualToString:@"1 hour before"]) {
                        alarm.fireDate = [_selectedDate dateByAddingTimeInterval:-3600*1];
                    }else if ([[dic valueForKey:REMINDER] isEqualToString:@"6 hours before"]) {
                        alarm.fireDate = [_selectedDate dateByAddingTimeInterval:-3600*6];
                    }else if ([[dic valueForKey:REMINDER] isEqualToString:@"12 hours before"]) {
                        alarm.fireDate = [_selectedDate dateByAddingTimeInterval:-3600*12];
                    }else if ([[dic valueForKey:REMINDER] isEqualToString:@"1 day before"]) {
                        alarm.fireDate = [_selectedDate dateByAddingTimeInterval:-3600*24];
                    }else if ([[dic valueForKey:REMINDER] isEqualToString:@"1 week before"]) {
                        alarm.fireDate = [_selectedDate dateByAddingTimeInterval:-3600*168];
                    }
                    
//                    NSDate *date = [NSDate date];
//                    if ([date compare:alarm.fireDate] == NSOrderedAscending) {
//                        return;  // fire date
//                    }
                    
                    if ([[dic valueForKey:REPEAT] isEqualToString:@"Hourly"]) {
                        alarm.repeatInterval = kCFCalendarUnitHour;
                    }else if ([[dic valueForKey:REPEAT] isEqualToString:@"Daily"]) {
                        alarm.repeatInterval = kCFCalendarUnitDay;
                    }else if ([[dic valueForKey:REPEAT] isEqualToString:@"Weekly"]) {
                        alarm.repeatInterval = kCFCalendarUnitWeek;
                    }else if ([[dic valueForKey:REPEAT] isEqualToString:@"Monthly"]) {
                        alarm.repeatInterval = kCFCalendarUnitMonth;
                    }else
                        alarm.repeatInterval = 0;
                    
//                    alarm.fireDate = [_selectedDate dateByAddingTimeInterval:120];
//                    alarm.repeatInterval = kCFCalendarUnitMinute;
                    
                    alarm.soundName = UILocalNotificationDefaultSoundName;
                    alarm.alertTitle = @"Idea Drop";
                    
                    dateFormatter.dateFormat = @"dd-MM-yyyy hh-mm a";
                    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                    [dateFormatter setTimeZone:timeZone];
                    
                    alarm.alertBody = [NSString stringWithFormat:@"Your upcoming event is '%@'\nDue date: %@",[dic valueForKey:IDEA_NAME], [dateFormatter stringFromDate:[dic valueForKey:DUE_DATE]]];
                    
                    alarm.userInfo = dic;
                    
                    alarm.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"]; //[NSTimeZone defaultTimeZone];
                    alarm.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                    [app scheduleLocalNotification:alarm];
                }

            }
            
            [ToastPopup toastInView:self.view withText:@"Successfully added idea in 'Capture List'" withY:64];
            [self cancelPressed:nil];
            
        }else{
            [ToastPopup toastInView:self.view withText:@"Something went wrong." withY:64];
            [self cancelPressed:nil];
        }
    }];

}

#pragma mark - PickerDelegate

-(void)pickerValue:(NSString *)selectedValue andPickerUse:(int)pickerUse{
    
    [self.view addGestureRecognizer:gesture];
    if (selectedValue) {
        ReminderCell *cell ;
        
        if (pickerUse == Reminder_Purpose) {
            cell =  (ReminderCell *)[_tableView viewWithTag:1003];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        }else{
            cell =  (ReminderCell *)[_tableView viewWithTag:1004];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        }
        cell.refrshBtn.hidden = false;
        [cell.valueBtn setTitle:selectedValue forState:UIControlStateNormal];
        
    }

}

#pragma mark - ClockDelegate

-(void)clockTime:(NSString *)timeStr{
    
    Date_TimeCell *cell =  (Date_TimeCell *)[_tableView viewWithTag:1002];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell.btn setTitle:timeStr forState:UIControlStateNormal];
    cell.refrshBtn.hidden = false;


}

#pragma mark - CalendarDelegate

-(void)calendarDate:(NSDate *)date{
    _selectedDate = date;
    
    static NSDateFormatter *dateFormatter;
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    
    Date_TimeCell *cell =  (Date_TimeCell *)[_tableView viewWithTag:1001];//[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell.btn setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
    cell.refrshBtn.hidden = false;

    
    
}

@end
