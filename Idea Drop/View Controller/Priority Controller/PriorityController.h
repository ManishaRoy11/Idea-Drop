//
//  PriorityController.h
//  Idea Drop
//
//  Created by Manisha Roy on 06/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriorityController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *firstLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondLbl;
@property (weak, nonatomic) IBOutlet UILabel *thirdLbl;
@property (weak, nonatomic) IBOutlet UILabel *fourthLbl;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *laterBtn;
@property (weak, nonatomic) IBOutlet UIButton *dontBtn;

@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)priorityPressed:(UIButton *)sender;
@end
