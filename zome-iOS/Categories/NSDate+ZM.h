//
//  NSDate+ZM.h
//  zome-iOS
//
//  Created by CFW on 2017/12/15.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZM)

+(NSString *)getHourMinString:(NSDate *)date;

-(NSString *)stringWithISOFormat;

+ (NSDate *)dateWithISOFormatString:(NSString *)dateString;

+(NSString *)stringWithYMD:(NSDate *)data;

+(NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 Returns a date parsed from given string interpreted using the format.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (NSDate *)dateWithString:(NSString *)dateString
                             format:(NSString *)format
                           timeZone:(NSTimeZone *)timeZone
                             locale:(NSLocale *)locale;


@end
