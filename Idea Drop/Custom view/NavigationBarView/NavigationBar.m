//
//  NavigationBar.m
//  DDecor
//
//  Created by webwerks on 30/11/15.
//
//

#import "NavigationBar.h"

@implementation NavigationBar

- (id)initWithNib
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NavigationBar" owner:self options:nil] firstObject];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    }
    return self;
}

-(void)defaultSetup{
    
//    _countLbl.layer.cornerRadius = _countLbl.frame.size.height/2;
//    _countLbl.layer.borderColor = [UIColor whiteColor].CGColor;
//    _countLbl.layer.borderWidth = 1.0;
//    _countLbl.clipsToBounds = YES;
//    _countLbl.hidden = YES;

    _navigationTitleLbl.text = _navigationTitle;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateBagCount:) name:@"UpdateBagCount" object:nil];
//    [self updateLabel];
    
}

-(IBAction)menuClicked:(id)sender{
    if (_isback){
        [APP_DELEGATE.navController popViewControllerAnimated:YES];
    }
    
}

-(IBAction)notificationClicked:(id)sender{
    if (!_isOption) {
        
    }
}

-(void)UpdateBagCount:(NSNotification *)notificationInfo{
//    _countLbl.hidden = YES;
//    [self updateLabel];
    
}

-(void)updateLabel{
//    NSMutableDictionary *custDic = [COMMON_METHODS readFromFile:@"CUSTOMER_DATA"];
//    
//    if (custDic) {
//        int bagId = [DDatabase returnBAG_ID:[[custDic valueForKey:@"ID"] intValue]];
//        
//        FMDatabase *db = [FMDatabase databaseWithPath:DatabasePath];
//        [db open];
//        
//        FMResultSet *fmResultSetObj ;
//        int count = 0;
//        
//        NSString *str =[NSString stringWithFormat:@"SELECT count(*) FROM BAG_ITEMS NOLOCK WHERE BAG_ID=%d",bagId];
//        fmResultSetObj = [db executeQuery:str];
//        
//        if ([fmResultSetObj next]) {
//            count= [fmResultSetObj intForColumnIndex:0];
//        }
//        
//        [fmResultSetObj close];
//        
//        str =[NSString stringWithFormat:@"SELECT count(*) FROM Swatches_Items NOLOCK WHERE BAG_ID=%d",bagId];
//        fmResultSetObj = [db executeQuery:str];
//        
//        if ([fmResultSetObj next]) {
//            count= count+[fmResultSetObj intForColumnIndex:0];
//        }
//        
//        [fmResultSetObj close];
//        
//        _countLbl.text = [NSString stringWithFormat:@"%d",count];
//        if (count==0) {
//            _countLbl.hidden = YES;
//        }else{
//            _countLbl.hidden = NO;
//            
//        }
//        _custimg.image = [UIImage imageNamed:@"user_active.png"];
//    }else{
//        _custimg.image = [UIImage imageNamed:@"user_inactive.png"];
//        
//    }
}
@end
