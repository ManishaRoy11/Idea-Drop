//
//  CommonMethods.m
//  Jotun-Surveyor
//
//  Created by Manisha Roy on 8/26/15.
//  Copyright (c) 2015 webwerks. All rights reserved.
//

#import "CommonMethods.h"
#include <ifaddrs.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation CommonMethods

static CommonMethods *sharedInstance;

+(CommonMethods*) sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[CommonMethods alloc] init];
    }
    return sharedInstance;
}

#pragma mark - Textfield Placeholder color

/*!
 *  To change color of textfield's placeholder
 *
 *  @param color     color of placeholder
 *  @param textField name of textfield
 */

- (void)setPlaceholderColor:(UIColor *)color textField:(UITextField*)textField
{
    
    [textField setValue:color forKeyPath:@"_placeholderLabel.textColor" ];
    
}


#pragma mark - Validations

-(BOOL)ValidEmail:(NSString *)checkString
{
    if([checkString length] <=0)
        return FALSE;
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
    
}

/*!
 *  Mobile number validation
 *
 *  @param candidate mobile number
 *
 *  @return true/false
 */

-(BOOL)ValidateMobileNumber: (NSString *) candidate
{
    if([candidate length] <=0)
        return FALSE;
    NSString *regex = @"^([0-9]{8,25})$";
    
    NSPredicate *rp = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([rp evaluateWithObject:candidate])
    {
        return TRUE;
    }
    
    return FALSE;
    
}

-(BOOL)ValidateAlphaNumeric: (NSString *) candidate
{
    NSString *regex = @"^[a-zA-Z0-9'-~&$ ]*$";
    
    NSPredicate *rp = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([rp evaluateWithObject:candidate])
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    
}

-(BOOL)ValidatePasswordField:(UITextField *)textField
{
    NSString *string = textField.text;
    
    NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'";
    NSString *numberString = @"0123456789";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacterString];
    NSCharacterSet *numberCharacterSet = [NSCharacterSet characterSetWithCharactersInString:numberString];
    
    specialCharacterString = numberString = Nil;
    
    if ([string.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length && [string.lowercaseString rangeOfCharacterFromSet:numberCharacterSet].length)
    {
        return TRUE;
    }
    return FALSE;
}

-(id)isStringNull:(id) str {
    
    if ([str isKindOfClass:[NSString class]]) {
        
        //        str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
        str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        //        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if([str isKindOfClass:[NSNull class]] || str==nil)
            return @"";
        if([str length] == 0)
            return @"";
        if(![[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
            return @"";
        if([str isEqualToString:@"(null)"])
            return @"";
        if([str isEqualToString:@"<null>"])
            return @"";
        
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return str;
    }
    else{
        
        if([str isKindOfClass:[NSNull class]] || str==nil)
            return @"";
        return str;
    }
    
}

-(BOOL)isNull:(id)param{
    
    if (param == nil || param== NULL || param == (id)[NSNull null] || ([param isKindOfClass:[NSString class]] && ([param isEqualToString:@"\"<null>\""] || [param isEqualToString:@"null"] || [param isEqualToString:@"(null)"])) )
        return YES;
    
    return NO;
}

#pragma mark - Alerts
-(void)showAlertForInternet
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !" message:@"No internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

-(void)showAlertTitle:(NSString *)title message :(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

-(NSString *)plistData
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"CachedData.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"CachedData" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    return path;
}


-(id)defaultsGetObjecForKey:(id)key{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

-(void)defaultsSetObject:(id)object ForKey:(id)key{
    
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(UIFont *)getFontWithSize:(int)size{
    UIFont *font = [UIFont systemFontOfSize:size];
    return font;
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    
    NSString *noHashString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
    
}

//- (UIColor *)colorWithHex:(UInt32)col {
//    unsigned char r, g, b;
//    b = col & 0xFF;
//    g = (col >> 8) & 0xFF;
//    r = (col >> 16) & 0xFF;
//    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
//}

#pragma mark getting Main Thread..and background thread..
-(void)RunOnMainThread:(void (^)(void))block
{
    //Check Recieved Block Of Code whether they are running on main thread or not .if Not then Forcefully make run them on main thread
    
    if ([NSThread isMainThread]) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

-(void)RunOnBackgroundThread:(void (^)(void))block
{
    if ([NSThread currentThread].isMainThread)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block);
    }
}

#pragma mark - Get Formatted Date
-(NSString *)getDateStringFromDate:(NSDate *)date usingFormatterString:(NSString *)strFormat
{
    NSDateFormatter *dateFormatterObj = [[NSDateFormatter alloc]init];
    [dateFormatterObj setDateFormat:strFormat];
    [dateFormatterObj setLocale:[NSLocale currentLocale]];
    return [dateFormatterObj stringFromDate:date];
}

#pragma mark - HUD

-(void)addActivityViewToImg:(UIImageView *)imgView imgUrl:(NSString *)imgUrl{
    
    NSString *dirPath = [NSString stringWithFormat:@"%@",[@"~/Documents/Images" stringByExpandingTildeInPath]];
    
    NSString *imageName = [NSString stringWithFormat:@"%@",[[imgUrl componentsSeparatedByString:@"/"] lastObject]];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",dirPath,imageName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        UIImage *img = [UIImage imageWithContentsOfFile:filePath];
        
        if (![COMMON_METHODS isStringNull:imgUrl] || [imgUrl isEqualToString:@""] || [imageName isEqualToString:@""] || (img.size.width == 0 && img.size.height == 0))
        {
            imgUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"PLACEHOLDER_IMAGE"];
            imgUrl = [imgUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            imageName = [NSString stringWithFormat:@"%@",[[imgUrl componentsSeparatedByString:@"/"] lastObject]];
            
            filePath = [NSString stringWithFormat:@"%@/%@",dirPath,imageName];
            img = [UIImage imageWithContentsOfFile:filePath];
        }
        [imgView setImage:img];
        
    }else{
        
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setCenter:CGPointMake(imgView.frame.size.width/2.0, imgView.frame.size.height/2.0)];
        [imgView addSubview:spinner];
        [spinner startAnimating];
        
        NSMutableArray *arrDetails = [COMMON_METHODS readFromFile:@"download_images"];
        if ([arrDetails containsObject:imgUrl]) {
            NSInteger index = [arrDetails indexOfObject:imgUrl];
            [arrDetails removeObjectAtIndex:index];
            
            [COMMON_METHODS writefile:arrDetails toFileName:@"download_images"];
            
            int imageCount = [[COMMON_METHODS defaultsGetObjecForKey:@"DOWNLOADED_IMAGE_COUNT"] intValue];
            imageCount++;
            [COMMON_METHODS defaultsSetObject:[NSString stringWithFormat:@"%d",imageCount] ForKey:@"DOWNLOADED_IMAGE_COUNT"];
        }
        
        if (![COMMON_METHODS isStringNull:imgUrl] || [imgUrl isEqualToString:@""]) {
            imgUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"PLACEHOLDER_IMAGE"];
            imgUrl = [imgUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            imageName = [NSString stringWithFormat:@"%@",[[imgUrl componentsSeparatedByString:@"/"] lastObject]];
            
            filePath = [NSString stringWithFormat:@"%@/%@",dirPath,imageName];
            imgView.image = [UIImage imageWithContentsOfFile:filePath];
            return;
        }
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imgUrl]];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   NSString *dirPath = [NSString stringWithFormat:@"%@",[@"~/Documents/Images" stringByExpandingTildeInPath]];
                                   if ( !error )
                                   {
                                       NSString *requestUrl = [NSString stringWithFormat:@"%@",request.URL];
                                       NSString *imageName = [NSString stringWithFormat:@"%@",[[requestUrl componentsSeparatedByString:@"/"] lastObject]];
                                       
                                       NSString *getImagePath = [dirPath stringByAppendingPathComponent:imageName];
                                       [[NSFileManager defaultManager] createFileAtPath:getImagePath contents:data attributes:nil];
                                       imgView.image = [UIImage imageWithData:data];
                                   }else{
                                       NSString* imgUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"PLACEHOLDER_IMAGE"];
                                       imgUrl = [imgUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                                       NSString *imageName = [NSString stringWithFormat:@"%@",[[imgUrl componentsSeparatedByString:@"/"] lastObject]];
                                       imgView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",dirPath,imageName]];
                                       
                                   }
                                   [spinner stopAnimating];
                                   [spinner removeFromSuperview];
                                   
                               }];
    }
}

- (UIImage *)takeScreenShot {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, NO, [UIScreen mainScreen].scale);
    
    [keyWindow drawViewHierarchyInRect:keyWindow.bounds afterScreenUpdates:YES];
    UIImage * image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)setPadding:(UITextField*)textField
{
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, textField.frame.size.height)];
    
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)setPadding:(UITextField*)textField withPixels:(float)withPixels
{
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, withPixels, textField.frame.size.height)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

-(BOOL)writefile:(id)file toFileName:(NSString *)fileName{
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",[@"~/Documents" stringByExpandingTildeInPath],fileName];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:file forKey:fileName];
    [archiver finishEncoding];
    return [data writeToFile:filePath atomically:YES];
    
}

-(id)readFromFile:(NSString *)fileName{
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",[@"~/Documents" stringByExpandingTildeInPath],fileName];
    
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    
    if (data != nil) {
        
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        id fileData = [unarchiver decodeObjectForKey:fileName];
        
        return fileData;
    }
    
    return nil;
}

-(void)removeFile:(NSString *)filename{
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",[@"~/Documents" stringByExpandingTildeInPath],filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    }
    
}

-(BOOL)isMBO{
    
    NSMutableDictionary *retailerDic = [COMMON_METHODS readFromFile:@"MERCHANT_DATA"];
    if (retailerDic && [[retailerDic valueForKey:@"MERCHANT_TYPE"] isEqualToString:@"MBO"]) {
        
        return YES;
        
    }
    
    return NO;
}

- (void)saveImage:(UIImage *)image withName:(NSString *)imageName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
    
}

- (UIImage *)getImage:(NSString *)imageName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    
    return img;
}

-(NSString *)encodeBase_64:(NSString *)input{
    NSData *plainData = [input dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64EncodedStringWithOptions:0];
    return base64String;
}

-(NSString *)decodeBase_64:(NSString *)input{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:input options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

- (bool) hasCellular {
    
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    bool found = false;
    if (getifaddrs(&addrs) == 0) {
        cursor = addrs;
        while (cursor != NULL) {
            NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
            if ([name isEqualToString:@"pdp_ip0"])
                found = true;
        }
        cursor = cursor->ifa_next;
    }
    freeifaddrs(addrs);
    
    return found;
}


- (void)scheduleAutoSync:(NSDate *)syncDate
{
    
    UIApplication *app = (UIApplication *)[UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    // Clear out the old notification before scheduling a new one.
    if ([oldNotifications count] > 0)
        [app cancelAllLocalNotifications];
    
    
    if (syncDate == nil) {
        syncDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
        NSString *currentTime = [dateFormatter stringFromDate:today];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        today = [dateFormatter dateFromString:currentTime];
        
        [[NSUserDefaults standardUserDefaults] setObject:today forKey:@"NOTIFICATION_DATE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    // Create a new notification.
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    alarm.timeZone = [NSTimeZone localTimeZone];
    
    if (alarm)
    {
        alarm.fireDate = syncDate;
        alarm.repeatInterval = kCFCalendarUnitDay;
        alarm.soundName = UILocalNotificationDefaultSoundName;
        alarm.alertBody = @"Please sync data, It might take few minutes.";
        [app scheduleLocalNotification:alarm];
    }
    
}

-(UIImage*)GetCenterSquareOfImage:(UIImage*)image
{
    CGImageRef bigImage = image.CGImage;
    int x,y,width,height = 0;
    width = image.size.width/2;
    height = image.size.height/2;
    x = width/2;
    y = height/2;
    CGImageRef partOfBigImage = CGImageCreateWithImageInRect(bigImage, CGRectMake(x, y, width, height));
    UIImage *partOfImage = [UIImage imageWithCGImage:partOfBigImage];
    UIImage *PartImage = partOfImage;
    return PartImage;
}

@end
