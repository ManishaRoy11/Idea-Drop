//
//  AddIdeaViewController.h
//  Idea Drop
//
//  Created by Manisha Roy on 04/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewCell.h"
#import "Date_TimeCell.h"
#import "ReminderCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ClockView.h"
#import "CalendarView.h"


@interface AddIdeaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, ClockDelegate, CalendarDelegate>{
    ClockView *clockView;
    CalendarView *calView;
    NSDate *_selectedDate;
}

@property BOOL isFromMenu;
@property (weak, nonatomic) NSMutableDictionary *selectedData;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

- (IBAction)cancelPressed:(UIButton *)sender;
- (IBAction)savePressed:(UIButton *)sender;

@end
