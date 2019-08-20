//
//  ZMPushTool.h
//  zome-iOS
//
//  Created by CFW on 2017/12/6.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMPushTool : NSObject

/**
 * 跳转到Login
 */
+(void)pushLoginViewWithTarget:(UINavigationController *)target;

/**
 * 跳转到CodeLogi
 */
+(void)pushCodeLoginViewWithTarget:(UINavigationController *)target;

/**
 * 跳转到PayMentList
 */
+(void)pushPayMentListViewWithTarget:(UINavigationController *)target;

@end
