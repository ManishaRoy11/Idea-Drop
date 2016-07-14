//
//  ClockView.h
//  Idea Drop
//
//  Created by Manisha Roy on 04/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"

@protocol ClockDelegate <NSObject>

-(void)clockTime:(NSString *)timeStr;

@end

@interface ClockView : UIView<BEMAnalogClockDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <ClockDelegate> delegate;
@property (weak, nonatomic) IBOutlet BEMAnalogClockView *myClock1; // The big, main clock.
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *outerView;


@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSCalendar *calendar;
@property (nonatomic,strong) NSDate *date;


- (IBAction)cancelPressed:(UIButton *)sender;
- (IBAction)okPressed:(UIButton *)sender;
- (IBAction)am_pmToggle:(UIButton *)sender;

-(id)initWithNib;
-(void)defaultSetup;
@end
