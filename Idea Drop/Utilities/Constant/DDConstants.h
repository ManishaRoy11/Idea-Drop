//
//  SLConstants.h
//  ShoLyne
//
//  Created by Atul on 07/11/15.
//  Copyright © 2015 asdf. All rights reserved.
//

#ifndef SLConstants_h
#define SLConstants_h

typedef enum
{
    kClickedIndexYES=1,
    kClickedIndexNO=0,
}kClickedIndex;


typedef NS_ENUM(NSUInteger, PickerPurpose) {
    None,
    Matrix_Purpose,
    MoveTo_Purpose,
    Reminder_Purpose,
    Repeater_purpose,
    
} ;

typedef enum {
    Home,
    Catalogue,
    Shop_By_Look,
    Style_Discovery,
    Dimaginer,
    Shortlist,
    Web_Lookup,
    BlankCell,
    My_Customer,
    Settings
} SideMenuIndex;

typedef enum {
    Design_View_More,
    Similar_Colln_View_More,
    People_View_More_Colln,
    Prod_Look_View_More,
    By_Same_View_More,
    Similar_Prod_View_More,
    Best_Matches_View_More,
    Also_Available_Beds_View_More,
    Similar_Beds_View_More,
    People_View_More_QDS
    
} ViewMoreType;

typedef enum {
    CustomerLogin_Bag,
    CustomerLogin_Shortlist,
    CustomerLogin_Share,
    CustomerLogin_Side_Shortlist,
    CustomerLogin_Style_Discovery,
    CustomerLogin_Dimaginer,
    CustomerLogin_None,
    CustomerLogin_Nav_Bag,
    CustomerLogin_RequestSample,
    CustomerLogin_HomeConsultation,
} CustomerLoginFor;

#define mark - Checking Devices
#define XAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define Database [DDatabase sharedObject]

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] integerValue])

#define IS_IPHIS_IPHONE_6IS_IPH ([[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)

#define IS_IPAD_PRO (IS_IPAD && [[UIScreen mainScreen] bounds].size.height == 1024)
#define IS_IPAD_PRO_1024 (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1024.0)
#define IS_IPAD_PRO_1366 (IS_IPAD && MAX(SCREEN_WIDTH,SCREEN_HEIGHT) == 1366.0)

//#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6P ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )1104 ) < DBL_EPSILON )

#define APP_DELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define Database [DDatabase sharedObject]
#define COMMON_METHODS [CommonMethods sharedInstance]
#define WEBSERVICE_INTERFACE [WebService sharedInstance]

#define KEYBOARD_ANIMATION_DURATION 0.3
#define MINIMUM_SCROLL_FRACTION 0.2
#define MAXIMUM_SCROLL_FRACTION 0.8
#define PORTRAIT_KEYBOARD_HEIGHT 236
#define LANDSCAPE_KEYBOARD_HEIGHT 162

#define COLOR_CV_TAG 1000
#define DESIGN_CV_TAG 1001
#define SIMILAR_COLLECTION_CV_TAG 1002
#define ALSO_AVAILALBE_AS_CV_TAG 1009
#define PEOPLE_ALSO_VIEWED_CV_TAG 1003
#define RESTRICTION_CV_TAG 1004
#define CARAUSEL_CV_TAG 1005
#define FABRIC_IN_SHORTLIST_CV_TAG 1006
#define PRODUCT_IN_SHORTLIST_CV_TAG 1007
#define MATERIAL_CV_TAG 1008
#define DIMAGINER_IN_SAVED_CV_TAG 10010

#define CUST_LOGOUT_ALERT ( double )100000
#define CUST_LOGIN_ALERT ( double )100001
#define ASK_EMAIL_ALERT 100002
#define SHOW_EMAIL_ALERT 100003
#define CONFIRM_EMAIL_ALERT 100004
#define GET_QUANTITY 100005
#define CONFIRM_DELETE 100006
#define CONFIRM_ORDER_PLACING 100007

#define APP_D_SYNC_ALERT 20000
#define APP_C_SYNC_ALERT 20001
#define APP_BLOCK_ALERT 20002
#define APP_VERSION_CHANGED_ALERT 20003



#endif /* SLConstants_h */
