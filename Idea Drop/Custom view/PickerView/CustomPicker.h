//
//  CustomPicker.h
//  Idea Drop
//
//  Created by Manisha Roy on 04/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PickerDelegate <NSObject>

-(void)pickerValue:(NSString *)selectedValue andPickerUse:(int)pickerUse;

@end
@interface CustomPicker : UIView <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) id <PickerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *bgView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property  int pickerPurpose;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_height;

-(id)initWithNib;
-(void)defaultSetup;
@end
