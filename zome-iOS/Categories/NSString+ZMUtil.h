//
//  NSString+ZMUtil.h
//  zome-iOS
//
//  Created by CFW on 2017/12/6.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZMUtil)

/**
 * @brief  生成一个指定长度的随机字符串
 * @param  length  长度
 * @return 随机字符串
 */
+(NSString *)randomStrLength:(int)length;



/**
 # String 是否存在字典中
 *
 */
+(BOOL)isDictContain:(NSDictionary *)dict withStr:(NSString *)key;



/**
 # 将字符URL转换成NSDictionary
 *
 */
+(NSDictionary *)stringUrlToDictionary:(NSString *)string;

/**
 # 获取当前时间戳  （以毫秒为单位）
 *
 */
+(NSString *)getNowTimeTimestamp;

//邮箱
+ (BOOL)validateEmail:(NSString *)email;

@end
