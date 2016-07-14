//
//  ListTVCell.h
//  Idea Drop
//
//  Created by Manisha Roy on 01/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;


@property (weak, nonatomic) IBOutlet UIView *ideaOptionView;

@property (weak, nonatomic) IBOutlet UIView *halfCircleCell;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *trashBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *halfCircle_x;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ideaOptionView_x;
@end
