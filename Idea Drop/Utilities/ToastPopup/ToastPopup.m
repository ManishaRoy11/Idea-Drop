//
//  CustomView.m
//  DemoforAlertView
//
//  Created by Apple on 23/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

#import "ToastPopup.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kDuration = 2;
static NSMutableArray *toasts;

@interface ToastPopup ()

@property (nonatomic, readonly) UILabel *textLabel;

- (void)fadeToastOut;
+ (void)nextToastInView:(UIView *)parentView;

@end

@implementation ToastPopup
@synthesize textLabel = _textLabel;

//========================================================================================================
#pragma mark - NSObject CALLED HERE
//========================================================================================================

- (id)initWithText:(NSString *)text {
    if ((self = [self initWithFrame:CGRectZero])) {
        // Add corner radius
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.autoresizesSubviews = NO;
        
        // Init and add label
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = text;
        _textLabel.minimumScaleFactor = 14;
        _textLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:14];
        
        _textLabel.textColor = Color_3D3D3D;
        _textLabel.adjustsFontSizeToFitWidth = NO;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        [_textLabel sizeToFit];
        
        [self addSubview:_textLabel];
        _textLabel.frame = CGRectOffset(_textLabel.frame, 10, 5);
    }
    
    return self;
}
//========================================================================================================
#pragma mark - Public
//========================================================================================================

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text withY:(CGFloat)CustomY
{
    ToastPopup *view = [[ToastPopup alloc] initWithText:text];
    view.frame = CGRectMake(0,CustomY, parentView.frame.size.width, view.textLabel.frame.size.height);
    view.textLabel.center = CGPointMake(view.center.x, (view.textLabel.center.y+50)/2);
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.0f;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 5);
    view.layer.shadowOpacity = 0.1;
    view.layer.shadowRadius = 6.0;
    
    
    if (toasts == nil) {
        toasts = [[NSMutableArray alloc] initWithCapacity:1];
        [toasts addObject:view];
        [ToastPopup nextToastInView:parentView withYCord:CustomY];
    }
    else {
        [toasts addObject:view];
    }
    
}
//========================================================================================================
#pragma mark - Private
//========================================================================================================

- (void)fadeToastOut
{
   
    UIView *parentView = self.superview;
    [parentView setUserInteractionEnabled:YES];
    [UIView animateWithDuration:.30 delay:0.20 usingSpringWithDamping:0.65 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self setFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0)];
        [self setAlpha:0.0f];
    } completion:^(BOOL finished)
     {
         
         [self removeFromSuperview];
         [toasts removeObject:self];
         if ([toasts count] == 0) {
             
             toasts = nil;
         }
         else
             [ToastPopup nextToastInView:parentView];
     }];
    
    
}

+ (void)nextToastInView:(UIView *)parentView withYCord:(CGFloat)CustomY{
    if ([toasts count] > 0) {
        ToastPopup *view = [toasts objectAtIndex:0];
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            [view setFrame:[self alertRectWithYCord:CustomY]];
            [view setAlpha:1.0f];
            [parentView addSubview:view];
            [parentView setUserInteractionEnabled:NO];
        } completion:^(BOOL finished) {
            
        }];
        [view performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
    }
}


+ (void)nextToastInView:(UIView *)parentView {
    if ([toasts count] > 0) {
        ToastPopup *view = [toasts objectAtIndex:0];
        [UIView animateWithDuration:.40 delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0.9 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            [view setFrame:[self alertRect]];
            [view setAlpha:1.0f];
            [parentView addSubview:view];
            [parentView setUserInteractionEnabled:NO];
        } completion:^(BOOL finished) {
          
        }];
        [view performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
    }
}

+(CGRect)alertRectWithYCord:(CGFloat)CustomY
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    return CGRectMake(0,CustomY, mainScreen.bounds.size.width, 68);
    
}

+(CGRect)alertRect
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    return CGRectMake(0,64, mainScreen.bounds.size.width, 68);
    
}
@end
