//
//  CustomPicker.m
//  Idea Drop
//
//  Created by Manisha Roy on 04/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "CustomPicker.h"

@implementation CustomPicker

- (id)initWithNib
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CustomPicker" owner:self options:nil] firstObject];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    }
    return self;
}

-(void)defaultSetup{
    if (_pickerPurpose == MoveTo_Purpose) {
        if (_dataSource.count>4) {
            _table_height.constant = 52 * 5;
        }else{
            _table_height.constant = 52 * (_dataSource.count+1);
        }
    }else{
    _table_height.constant = 52 * _dataSource.count;
    }
//    _tableView.backgroundColor= [UIColor redColor];
    [_tableView registerNib:[UINib nibWithNibName:@"IdeaListTVCell" bundle:nil] forCellReuseIdentifier:@"IdeaListTVCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView reloadData];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    gesture.delegate = self;
    [gesture setCancelsTouchesInView:NO];
    [self addGestureRecognizer:gesture];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
}

-(void)tapGesture:(UITapGestureRecognizer *)gesture{
    if ([_delegate respondsToSelector:@selector(pickerValue:andPickerUse:)]) {
        
        [_delegate pickerValue:nil andPickerUse:_pickerPurpose];
        
        _delegate = nil;
        [self removeFromSuperview];
    }
}

#pragma mark - UITableview Datasource & Delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
    vw.backgroundColor = [UIColor whiteColor];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
    lb.textColor = Color_21AA68;
    lb.text = @"Move To";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:15];
    [vw addSubview:lb];
    return vw;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_pickerPurpose == MoveTo_Purpose)
        return 52;
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_pickerPurpose == MoveTo_Purpose)
//        return _dataSource.count+1;
    return _dataSource.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IdeaListTVCell *cell = (IdeaListTVCell *)[tableView dequeueReusableCellWithIdentifier:@"IdeaListTVCell"];
    
    if (!cell) {
        cell = [[IdeaListTVCell alloc] init];
    }

        if (indexPath.row == 0) {
            cell.backgroundColor = Color_E74C3C;
        }else if (indexPath.row == 1) {
            cell.backgroundColor = Color_E67E22;
        }else if (indexPath.row == 2) {
            cell.backgroundColor = Color_2ECC71;
        }else if (indexPath.row == 3) {
            cell.backgroundColor = Color_3D3D3D ;
        }else {
            cell.backgroundColor = Color_9E9E9E;
        }
    cell.ideaOptionView_x.constant = SCREEN_WIDTH;

    cell.dividerLbl.backgroundColor = [UIColor whiteColor];
    cell.titleLbl.textColor = [UIColor whiteColor];
    
//    if (_pickerPurpose == MoveTo_Purpose && (indexPath.row == 0))
//        cell.titleLbl.text = @"Move To";
//    else
        cell.titleLbl.text = [_dataSource objectAtIndex:indexPath.row];
//    cell.titleLbl.userInteractionEnabled = YES;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        if ([_delegate respondsToSelector:@selector(pickerValue:andPickerUse:)]) {
            
            [_delegate pickerValue:[_dataSource objectAtIndex:indexPath.row] andPickerUse:_pickerPurpose];
            
            _delegate = nil;
            [self removeFromSuperview];
        }
}


@end
