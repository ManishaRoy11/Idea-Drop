//
//  CustomView.h
//  DemoforAlertView
//
//  Created by Apple on 23/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastPopup : UIView {
    
@private
    UILabel *_textLabel;
    
}

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text withY:(CGFloat)CustomY;

@end
