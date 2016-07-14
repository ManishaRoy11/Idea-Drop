//
//  IdeaViewController.h
//  Idea Drop
//
//  Created by Manisha Roy on 01/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) NSMutableDictionary *selectedList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyView;

@end
