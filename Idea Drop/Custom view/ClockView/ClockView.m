//
//  ClockView.m
//  Idea Drop
//
//  Created by Manisha Roy on 04/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "ClockView.h"

@implementation ClockView{
    NSString *amPmStr;
}

- (id)initWithNib
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ClockView" owner:self options:nil] firstObject];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return self;
}

-(void)defaultSetup{
//    self.myClock1.militaryTime = YES;
    self.myClock1.enableShadows = YES;
    self.myClock1.realTime = YES;
    self.myClock1.currentTime = YES;
    self.myClock1.setTimeViaTouch = YES;
    self.myClock1.borderColor = [UIColor blackColor];
    self.myClock1.borderWidth = 3;
    self.myClock1.faceBackgroundAlpha = 0.0;
    self.myClock1.delegate = self;
    self.myClock1.digitFont = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:17];
    self.myClock1.digitColor = [UIColor blackColor];
    self.myClock1.enableDigit = YES;
    self.myClock1.hourHandColor = Color_3D3D3D;
    self.myClock1.minuteHandColor = Color_3D3D3D;
    self.myClock1.secondHandColor = Color_3D3D3D;
    
    _myClock1.layer.cornerRadius = _myClock1.frame.size.height / 2;
    _myClock1.clipsToBounds = YES;
    _outerView.layer.cornerRadius =  6;
    _outerView.clipsToBounds = YES;
    self.myClock1.backgroundColor = [UIColor whiteColor];

    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"HH:mm a"];
    _date = [NSDate date];
    NSString *str = [_dateFormatter stringFromDate:_date];
    if ([[str uppercaseString] containsString:@"PM"]) {
        amPmStr = @"PM";
    }else
        amPmStr = @"AM";
    
    _myLabel.text = [_dateFormatter stringFromDate:_date];
}

- (IBAction)cancelPressed:(UIButton *)sender {
    _myClock1.delegate = nil;
    [self removeFromSuperview];

}

- (IBAction)okPressed:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(clockTime:)]) {
        [_delegate clockTime:_myLabel.text];
        [self cancelPressed:sender];

    }
}

- (IBAction)am_pmToggle:(UIButton *)sender {
    if ([amPmStr isEqualToString:@"PM"]) {
        amPmStr = @"AM";
    }else if ([amPmStr isEqualToString:@"AM"]) {
        amPmStr = @"PM";
    }
}

- (CGFloat)analogClock:(BEMAnalogClockView *)clock graduationLengthForIndex:(NSInteger)index {
    if (clock.tag == 1) {
        if (!(index % 5) == 1) { // Every 5 graduation will be longer.
            return 20;
        } else {
            return 5;
        }
    }
    else return 0;
}

- (UIColor *)analogClock:(BEMAnalogClockView *)clock graduationColorForIndex:(NSInteger)index {
    if (!(index % 15) == 1) { // Every 15 graduation will be blue.
        return [UIColor blueColor];
    } else {
        return [UIColor whiteColor];
    }
}

- (void)currentTimeOnClock:(BEMAnalogClockView *)clock Hours:(NSString *)hours Minutes:(NSString *)minutes Seconds:(NSString *)seconds {
        int hoursInt = [hours intValue];
        int minutesInt = [minutes intValue];
        int secondsInt = [seconds intValue];
        self.myLabel.text = [NSString stringWithFormat:@"%02d:%02d %@", hoursInt, minutesInt, amPmStr];

}
@end
