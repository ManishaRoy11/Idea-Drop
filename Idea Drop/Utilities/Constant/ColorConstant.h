//
//  ColorConstant.h
//  DDecor
//
//  Created by Manisha Roy on 12/4/15.
//  Copyright © 2015 webwerks. All rights reserved.
//

#ifndef ColorConstant_h
#define ColorConstant_h

#define RGB(r, g, b) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define Color_21AA68 UIColorFromRGB(0x21AA68)
#define Color_1D935A UIColorFromRGB(0x1D935A)
#define Color_1A8853 UIColorFromRGB(0x1A8853)
#define Color_E74C3C UIColorFromRGB(0xE74C3C)
#define Color_E67E22 UIColorFromRGB(0xE67E22)
#define Color_2ECC71 UIColorFromRGB(0x2ECC71)
#define Color_95A5A6 UIColorFromRGB(0x95A5A6)

#define Color_BABDBE UIColorFromRGB(0xBABDBE)
#define Color_9E9E9E UIColorFromRGB(0x9E9E9E)
#define Color_505050 UIColorFromRGB(0x505050)
#define Color_3D3D3D UIColorFromRGB(0x3D3D3D)
#define Color_323232 UIColorFromRGB(0x323232)
#define Color_EAEAEA UIColorFromRGB(0xEAEAEA)

#define Color_EEEEEE UIColorFromRGB(0xEEEEEE)


#endif /* ColorConstant_h */
