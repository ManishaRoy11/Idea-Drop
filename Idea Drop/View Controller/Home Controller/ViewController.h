//
//  ViewController.h
//  Idea Drop
//
//  Created by Manisha Roy on 30/06/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    NSMutableArray *ideaListArray ,*listArray;
}

@property (weak, nonatomic) IBOutlet UIButton *addIdeaBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyListLbl;


- (IBAction)addIdeaPressed:(UIButton *)sender;
@end

