//
//  NavigationBar.m
//  DDecor
//
//  Created by webwerks on 30/11/15.
//
//

#import "NavigationBar.h"

@implementation NavigationBar

- (id)initWithNib
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NavigationBar" owner:self options:nil] firstObject];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    }
    return self;
}

-(void)defaultSetup{
    
    _navigationTitleLbl.text = _navigationTitle;
    
}

-(IBAction)menuClicked:(id)sender{
    if (_isback){
        [APP_DELEGATE.navController popViewControllerAnimated:YES];
    }
    
}

@end
