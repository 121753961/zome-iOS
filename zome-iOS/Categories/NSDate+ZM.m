//
//  NSDate+ZM.m
//  zome-iOS
//
//  Created by CFW on 2017/12/15.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "NSDate+ZM.h"

@implementation NSDate (ZM)

+(NSString *)getHourMinString:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //实例化一个日期的对象,这个对象不是NSDate的是NSDateComponents的
    NSDateComponents *com = [[NSDateComponents alloc] init];
    
    //做一个标示，表示我们要什么内容
    NSInteger flags = NSCalendarUnitHour | NSCalendarUnitMinute;
    
    //从一个日期里面把这些内容取出来
    com = [calendar components:flags fromDate:date];
    
    NSInteger hour = [com hour];
    NSString *hourStr = [NSString stringWithFormat:@"%ld",hour];
    if (hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%@",hourStr];
    }
    
    NSInteger min = [com minute];
    NSString *minStr = [NSString stringWithFormat:@"%ld",min];
    if (min < 10) {
        minStr = [NSString stringWithFormat:@"0%@",minStr];
    }
    
    return [NSString stringWithFormat:@"%@:%@",hourStr,minStr];
}

- (NSString *)stringWithISOFormat {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter stringFromDate:self];
}

+ (NSDate *)dateWithISOFormatString:(NSString *)dateString {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter dateFromString:dateString];
}

+(NSString *)stringWithYMD:(NSDate *)data{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfString = [fmt stringFromDate:data];
    return selfString;
}


+ (NSDate *)dateWithString:(NSString *)dateString
                    format:(NSString *)format
                  timeZone:(NSTimeZone *)timeZone
                    locale:(NSLocale *)locale{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+(NSString *)dataToMonth:(NSDate *)date{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
////    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
////    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
////    int month = [dateComponent month];
////    return [ns];
//
//    NSDateComponents *days = [[NSDateComponents alloc] init];
////    NSDate *date1 = [calendar dateByAddingComponents:days toDate:fromDate options:0];
    return @"";
}



@end
