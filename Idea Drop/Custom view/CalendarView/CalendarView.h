//
//  CalendarView.h
//  Idea Drop
//
//  Created by Manisha Roy on 04/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <JTCalendar/JTCalendar.h>
#import "JTCalendar.h"

@protocol CalendarDelegate <NSObject>

-(void)calendarDate:(NSDate *)date;

@end
@interface CalendarView : UIView<JTCalendarDelegate>

@property (weak, nonatomic) id <CalendarDelegate> delegate;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIView *outerView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

- (IBAction)cancelPressed:(UIButton *)sender;
- (IBAction)okPressed:(UIButton *)sender;

-(id)initWithNib;
-(void)defaultSetup;
@end




