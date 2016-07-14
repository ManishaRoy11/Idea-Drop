//
//  CommonMethods.h
//  Jotun-Surveyor
//
//  Created by Manisha Roy on 8/26/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonMethods : NSObject
+(CommonMethods*) sharedInstance;

-(BOOL)ValidEmail:(NSString *)checkString;
-(BOOL)ValidateMobileNumber: (NSString *) candidate;
-(BOOL)ValidateAlphaNumeric: (NSString *) candidate;
-(BOOL)ValidatePasswordField:(UITextField *)textField;
-(id)isStringNull:(id) str;
-(void)showAlertForInternet;
-(void)showAlertTitle:(NSString *)title message :(NSString *)message;
-(NSString *)plistData;
-(id)defaultsGetObjecForKey:(id)key;
-(void)defaultsSetObject:(id)object ForKey:(id)key;
-(UIFont *)getFontWithSize:(int)size;
-(UIColor *)colorFromHexString:(NSString *)hexString;
//- (UIColor *)colorWithHex:(UInt32)col;
-(void)RunOnMainThread:(void (^)(void))block;
-(void)RunOnBackgroundThread:(void (^)(void))block;
-(NSString *)getDateStringFromDate:(NSDate *)date usingFormatterString:(NSString *)strFormat;
-(UIImage *)takeScreenShot;
- (void)setPadding:(UITextField*)textField;
- (void)setPadding:(UITextField*)textField withPixels:(float)withPixels;

-(BOOL)writefile:(id)file toFileName:(NSString *)fileName;
-(id)readFromFile:(NSString *)fileName;
-(void)removeFile:(NSString *)filename;

-(void)addActivityViewToImg:(UIImageView *)imgView imgUrl:(NSString *)imgUrl;
-(BOOL)isMBO;
- (void)saveImage:(UIImage *)image withName:(NSString *)imageName;
- (UIImage *)getImage:(NSString *)imageName;
-(NSString *)encodeBase_64:(NSString *)input;
-(NSString *)decodeBase_64:(NSString *)input;

-(bool)hasCellular;
- (void)scheduleAutoSync:(NSDate *)syncDate;
-(UIImage*)GetCenterSquareOfImage:(UIImage*)image;
@end