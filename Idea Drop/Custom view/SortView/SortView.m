//
//  SortView.m
//  Idea Drop
//
//  Created by Manisha Roy on 24/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "SortView.h"

@implementation SortView
- (id)initWithNib
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SortView" owner:self options:nil] firstObject];
        
    }
    return self;
}

-(void)defaultSetup{
    
    self.layer.cornerRadius = 6;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 10;
//    self.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    [_tableView registerNib:[UINib nibWithNibName:@"IdeaListTVCell" bundle:nil] forCellReuseIdentifier:@"IdeaListTVCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = false;
}

#pragma mark - UITableview Datasource & Delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _sourceArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IdeaListTVCell *cell = (IdeaListTVCell *)[tableView dequeueReusableCellWithIdentifier:@"IdeaListTVCell"];
    
    if (!cell) {
        cell = [[IdeaListTVCell alloc] init];
    }
    
//    if (indexPath.row == 0) {
//        cell.titleLbl.text = @"Name";
//    }else if (indexPath.row == 1) {
//        cell.titleLbl.text = @"Create Date";
//    }else if (indexPath.row == 2) {
//        cell.titleLbl.text = @"Due Date";
//    }
    
    cell.titleLbl.text = [_sourceArray objectAtIndex:indexPath.row];

    cell.ideaOptionView.hidden = true;
    
    CGRect frame = CGRectMake(0, 0, 180, 52);
    cell.frame = frame;
    cell.dividerLbl.backgroundColor = Color_BABDBE;
    cell.dividerLbl.alpha = 0.3;
    cell.titleLbl.textColor = Color_505050;

    [_tableView sizeToFit];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_delegate respondsToSelector:@selector(sortOptionSelected:sortViewUse:)]) {
        
        NSString *purpose = @"";
        if (indexPath.row == 0) {
            purpose = @"Name";
        }else if (indexPath.row == 1) {
            purpose = @"Created Date";
        }else if (indexPath.row == 2) {
            purpose = @"Due Date";
        }
        
        [_delegate sortOptionSelected:[_sourceArray objectAtIndex:indexPath.row] sortViewUse:_sortPurpose];
        
        self.hidden = true;
    }
}
@end
