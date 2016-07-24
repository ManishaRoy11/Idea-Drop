//
//  SortView.h
//  Idea Drop
//
//  Created by Manisha Roy on 24/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SortViewDelegate <NSObject>

-(void)sortOptionSelected:(NSString *)selectedValue sortViewUse:(int)use;

@end


@interface SortView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *sourceArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) id <SortViewDelegate> delegate;


@property  int sortPurpose;


-(id)initWithNib;
-(void)defaultSetup;
@end
