//
//  NSString+ZMUtil.m
//  zome-iOS
//
//  Created by CFW on 2017/12/6.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "NSString+ZMUtil.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation NSString (ZMUtil)

+ (NSString *)hmacSha1:(NSString*)key text:(NSString*)text{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    
    NSString *hash;
    
    NSMutableString * output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        
        [output appendFormat:@"%02x", cHMAC[i]];
    
    hash = output;
    
    return hash;
}

/**
 * @brief  生成一个指定长度的随机字符串
 * @param  length  长度
 * @return 随机字符串
 */
+(NSString *)randomStrLength:(int)length{
    // 随机字符串
    int NUMBER_OF_CHARS = length;
    char data[NUMBER_OF_CHARS];
    char a[10]={'0','1','2','3','4','5','6','7','8','9'};
    for (int x = 0; x < NUMBER_OF_CHARS ; x++){
        int value = arc4random_uniform(9);
        if (value % 2 != 0) {
            data[x] = (char)('a' + (arc4random_uniform(26)));
        }else{
            data[x] = a[value];
        }
    }
    NSString *string =  [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
    return string;
}

/**
 # String 是否存在字典中
 *
 */
+(BOOL)isDictContain:(NSDictionary *)dict withStr:(NSString *)key{
    if(dict == nil) {
        return false;
    }
    NSArray *array = [dict allKeys];
    for (NSString *str in array) {
        if ([str isEqualToString:key]) {
            return true;
        }
    }
    return false;
}

/**
 # 将字符URL转换成NSDictionary
 *
 */
+(NSDictionary *)stringUrlToDictionary:(NSString *)string{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    NSRange range = [string rangeOfString:@"?"];
    if (range.length != 0) {
        NSString *params = [string substringFromIndex:range.location+1];
        for (NSString *param in [params componentsSeparatedByString:@"&"]) {
            NSRange index = [param rangeOfString:@"="];
            if (index.length != 0) {
                NSString *key = [param substringToIndex:index.location];
                NSString *value = [param substringFromIndex:index.location+1];
                [dic setObject:value forKey:key];
            }
        }
    }
    return dic;
}


/**
 # 获取当前时间戳  （以毫秒为单位）
 *
 */
+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}

-(NSString *)URLEncodedString{
//    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8);
//    CFURLCreateStringByReplacingPercentEscapes(<#CFAllocatorRef allocator#>, <#CFStringRef originalString#>, <#CFStringRef charactersToLeaveEscaped#>)
    
    return @"";
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


@end
