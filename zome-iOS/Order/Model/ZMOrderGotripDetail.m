//
//  ZMOrderGotripDetail.m
//  zome-iOS
//
//  Created by CFW on 2017/12/19.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMOrderGotripDetail.h"
#import "NSDate+ZM.h"

@implementation ZMOrderGotripDetail

//-(void)setRequestTimeStartOrig:(NSString *)requestTimeStartOrig{
//
//    _requestTimeStartOrig = [self timeStartOrig:requestTimeStartOrig];
//
////    _requestTimeStartOrig = @"2017-12-24T15:06:35.247Z";
//}
//
//-(void)setRequestTimeEndOrig:(NSString *)requestTimeEndOrig{
//    _requestTimeEndOrig = [self timeStartOrig:requestTimeEndOrig];
////   _requestTimeEndOrig= @"2017-12-24T16:06:35.247Z";
//}

-(NSString *)timeStartOrig:(NSString *)str{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    
    // NSString * -> NSDate *
//    NSDate *data = [format dateFromString:str];
    NSDate *data = [NSDate date];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    [dateFormatter setTimeZone:timeZone];
//    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSString *timeStr = [dateFormatter stringFromDate:data];
    return timeStr;
}

@end
