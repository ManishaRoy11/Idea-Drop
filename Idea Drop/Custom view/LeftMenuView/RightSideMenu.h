//
//  RightSideMenu.h
//  Idea Drop
//
//  Created by Manisha Roy on 07/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightSideMenu : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closePressed:(UIButton *)sender;

@end
