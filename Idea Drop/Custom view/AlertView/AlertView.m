//
//  AlertView.m
//  Idea Drop
//
//  Created by Manisha Roy on 11/07/16.
//  Copyright © 2016 Manisha Roy. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

- (id)initWithNib
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:self options:nil] firstObject];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.viewWithInput.layer.cornerRadius = 6;
        self.viewWithInput.clipsToBounds = YES;
        self.viewWithLabel.layer.cornerRadius = 6;
        self.viewWithLabel.clipsToBounds = YES;
        self.textView.layer.cornerRadius = 1;
        self.textView.layer.borderColor = Color_95A5A6.CGColor;
        self.textView.layer.borderWidth = 1;
        self.textView.clipsToBounds = YES;
    }
    return self;
}

-(void)defaultSetup{
}
@end
