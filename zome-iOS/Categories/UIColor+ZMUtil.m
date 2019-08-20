//
//  UIColor+ZMUtil.m
//  zome-iOS
//
//  Created by CFW on 2017/11/26.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "UIColor+ZMUtil.h"

@implementation UIColor (ZMUtil)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

/* 导航栏背景色 */
+ (UIColor *)navigationbarColor
{
    return [UIColor colorWithHex:0x228EE2]; //colorWith 34 142 226
}

/* 输入框底线色 */
+(UIColor *)inputLineColor{
    return [UIColor colorWithHex:0xEBEBF1]; //colorWith 235 235 241
}

/* 输入框正在输入底线色 */
+(UIColor *)inputLineSelectdColor{
    return [UIColor colorWithHex:0x2B83DC]; //colorWith 43 131 220
}

@end
