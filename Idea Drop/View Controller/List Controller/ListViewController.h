//
//  ListViewController.h
//  Idea Drop
//
//  Created by Manisha Roy on 01/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
