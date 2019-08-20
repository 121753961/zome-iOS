//
//  UIColor+ZMUtil.h
//  zome-iOS
//
//  Created by CFW on 2017/11/26.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZMUtil)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(int)hexValue;

/* 导航栏背景色 */
+ (UIColor *)navigationbarColor;

/* 输入框正在输入底线色 */
+(UIColor *)inputLineSelectdColor;

/* 输入框底线色 */
+(UIColor *)inputLineColor;

@end
