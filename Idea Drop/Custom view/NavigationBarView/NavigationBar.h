//
//  NavigationBar.h
//  DDecor
//
//  Created by webwerks on 30/11/15.
//
//

#import <UIKit/UIKit.h>

@protocol NavigationBarDelegate <NSObject>
-(void) leftButtonPressed;
@end


@interface NavigationBar : UIView
{
    BOOL menuState;
}

@property BOOL isback, isOption;
@property (weak,nonatomic) id<NavigationBarDelegate> delegate;

@property (strong, nonatomic)NSString *navigationTitle;
@property (nonatomic, weak) IBOutlet UIButton *menuIcon;
@property (nonatomic, weak) IBOutlet UIButton *notIcon;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *addListBtn;


-(id)initWithNib;
-(void)defaultSetup;
-(IBAction)menuClicked:(id)sender;
-(IBAction)notificationClicked:(id)sender;


@end
