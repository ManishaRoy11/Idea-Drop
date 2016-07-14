//
//  IdeaDetailController.h
//  Idea Drop
//
//  Created by Manisha Roy on 01/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaDetailController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableDictionary *selectedData;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSMutableArray *listArray;
@property (weak, nonatomic) NSMutableDictionary *selectedList;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detail_height;

@end
