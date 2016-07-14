//
//  PriorityController.m
//  Idea Drop
//
//  Created by Manisha Roy on 06/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "PriorityController.h"

@interface PriorityController ()
{
    NavigationBar *navBar;
    NSMutableArray *priorityArray;
}
@end

@implementation PriorityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    navBar = [[NavigationBar alloc] initWithNib];
    navBar.navigationTitle = @"Priority Matrix";
    [navBar.menuIcon setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [navBar defaultSetup];
    navBar.backgroundColor = Color_21AA68;
    [navBar.menuIcon addTarget:self action:@selector(menuClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBar];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    UIFont *font1 = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:14];
    UIFont *font2 = [UIFont fontWithName:@"AvenirNextLTPro-Demi"  size:16];
    UIFont *font3 = [UIFont fontWithName:@"AvenirNextLTPro-Regular"  size:10];
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSForegroundColorAttributeName: [UIColor whiteColor],
                            NSParagraphStyleAttributeName:style}; // Added line
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font2,
                            NSForegroundColorAttributeName: [UIColor whiteColor],
                            NSParagraphStyleAttributeName:style}; // Added line
    
    NSDictionary *dict3 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font3,
                            NSForegroundColorAttributeName: [UIColor whiteColor],
                            NSParagraphStyleAttributeName:style}; // Added line
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Action\n"    attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Do First"      attributes:dict2]];
    [self.firstBtn setAttributedTitle:attString forState:UIControlStateNormal];
    [[self.firstBtn titleLabel] setNumberOfLines:0];
    
    attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Action\n"    attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Do Next"      attributes:dict2]];
    [self.nextBtn setAttributedTitle:attString forState:UIControlStateNormal];
    [[self.nextBtn titleLabel] setNumberOfLines:0];
    
    attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"No Action\n"    attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Don't Do"      attributes:dict2]];
    [self.dontBtn setAttributedTitle:attString forState:UIControlStateNormal];
    [[self.dontBtn titleLabel] setNumberOfLines:0];
    
    
    attString = [[NSMutableAttributedString alloc] init];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Action\n"    attributes:dict1]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Do Later\n"      attributes:dict2]];
    [attString appendAttributedString:[[NSAttributedString alloc] initWithString:@"If Still Necessary"      attributes:dict3]];
    [_laterBtn setAttributedTitle:attString forState:UIControlStateNormal];
    [[_laterBtn titleLabel] setNumberOfLines:0];
    
    [_firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_laterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dontBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _firstBtn.layer.cornerRadius = 6;
    _firstBtn.clipsToBounds = YES;
    
    _nextBtn.layer.cornerRadius = 6;
    _nextBtn.clipsToBounds = YES;
    
    _laterBtn.layer.cornerRadius = 6;
    _laterBtn.clipsToBounds = YES;
    
    _dontBtn.layer.cornerRadius = 6;
    _dontBtn.clipsToBounds = YES;
    
    _firstLbl.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _secondLbl.transform = CGAffineTransformMakeRotation(-M_PI_2);

//    listArray = [Database fetchAllList:@"0" isUncatReq:YES];
    priorityArray = [Database fetchAllList:@"1" isUncatReq:NO];
    [self.textView  setTextContainerInset:UIEdgeInsetsMake(5, 10, 10, 10)];
    
    UIFont *font = [UIFont fontWithName:@"AvenirNextLTPro-Bold" size:13];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.paragraphSpacing = 0.5 * font.lineHeight;
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSBackgroundColorAttributeName:[UIColor clearColor],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 };
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:@"Priority Matrix is a simple way of organizing tasks and hence easier and better means of scheduling." attributes:attributes];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13] range:NSMakeRange(0,attributedString.length)];
    
    //add urgency
    
    
    NSString *str1 = @"Urgency : ";
    NSString *str2 = @"Tasks which has got a fixed deadline.  Again, there might be many jobs that have a deadline here but the priority matrix enables you to arrange the jobs in the order of their times. In a simple and a straightforward manner the matrix is based on the idea that the closer the deadline the more urgent the task.";

    NSMutableAttributedString * newString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@%@",str1, str2] attributes:attributes];
    
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:13] range:NSMakeRange(0,str1.length)];
    
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13] range:NSMakeRange(str1.length+1,str2.length)];
    
    [attributedString appendAttributedString:newString];
    
    //add Importance
    
    str1 = @"Importance : ";
    str2 = @"Tasks that has a major impact on your business or a high value on because it has a major impact on the business and hence quite important to consider in the priorities.";
    
    newString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@%@",str1, str2] attributes:attributes];
    
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Demi" size:13] range:NSMakeRange(0,str1.length)];
    
    [newString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:13] range:NSMakeRange(str1.length+1,str2.length)];
    
    [attributedString appendAttributedString:newString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:Color_3D3D3D range:NSMakeRange(0, attributedString.length)];
    _textView.attributedText = attributedString;
    _textView.textAlignment = NSTextAlignmentJustified;

}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)menuClicked:(id)sender{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
    }];
    
}

- (IBAction)priorityPressed:(UIButton *)sender {
    IdeaViewController *homeVc=[self.storyboard instantiateViewControllerWithIdentifier:@"IdeaViewController"];
    if (sender.tag == 1) {
        homeVc.selectedList = [priorityArray objectAtIndex:0];
    }else if (sender.tag == 2) {
        homeVc.selectedList = [priorityArray objectAtIndex:1];
    }else if (sender.tag == 3) {
        homeVc.selectedList = [priorityArray objectAtIndex:2];
    }else if (sender.tag == 4) {
        homeVc.selectedList = [priorityArray objectAtIndex:3];
    }
    
    [self.menuContainerViewController.centerViewController pushViewController:homeVc animated:YES];
}
@end
