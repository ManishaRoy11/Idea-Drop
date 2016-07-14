//
//  AlertView.h
//  Idea Drop
//
//  Created by Manisha Roy on 11/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView

@property (weak, nonatomic) IBOutlet UIView *viewWithLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *viewWithInput;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn1;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn1;
-(id)initWithNib;
-(void)defaultSetup;
@end
