//
//  ZMUtilityTools.m
//  zome-iOS
//
//  Created by CFW on 2017/12/7.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMUtilityTools.h"
#import <CocoaSecurity/CocoaSecurity.h>
#import "NSString+ZMUtil.h"
#import "NSString+URLEncoding.h"
#import "NSString+ZMUrl.h"

@implementation ZMUtilityTools

+(NSString *)signWithSourceDic:(NSDictionary *)sourceDic{
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithCapacity:1];
    if([sourceDic isKindOfClass:[NSDictionary class]]){
        NSArray *allKeysArr = [[sourceDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSComparisonResult result = [obj1 compare:obj2];
            return result == NSOrderedDescending;
        }];
        for (NSString *key in allKeysArr) {
            if ([key isKindOfClass:[NSString class]]) {
                NSString *valueStr = [sourceDic objectForKey:key];
                if(mutableStr.length > 0){
                    NSString *key_valueStr = [NSString stringWithFormat:@"&%@=%@",key,valueStr];
                    [mutableStr appendString:key_valueStr];
                }else{
                    NSString *key_valueStr = [NSString stringWithFormat:@"%@=%@",key,valueStr];
                    [mutableStr appendString:key_valueStr];
                }
            }
        }
        
        mutableStr = [mutableStr URLEncodedString];
//        mutableStr = [[NSMutableString alloc] initWithString:[mutableStr URLEncodedString]];
//        NSString *tmepStr = []
        
        NSString *signStr = nil;
        if (mutableStr.length > 0) {
            // 使用HmacSHA1对KV字符串加密生成byte[]
//            CocoaSecurityResult *result_SHA1 = [CocoaSecurity sha1:mutableStr];
            CocoaSecurityResult *result_SHA1 = [CocoaSecurity hmacSha1:mutableStr hmacKey:@"5d2ccbd3f03e41b0a849fabca97d1970"];
            
            //使用base64对加密后的byte[] 进行encode
            CocoaSecurityEncoder *encoder = [CocoaSecurityEncoder new];
            NSString *bases64Str = [encoder base64:[result_SHA1.hex dataUsingEncoding:NSUTF8StringEncoding]];
            
            // 使用base64对加密后的byte[] 进行encode
            CocoaSecurityResult *result_md5 = [CocoaSecurity md5:bases64Str];
            
            signStr = result_md5.hex;
        }
        if (signStr) {
            return signStr;
        }
        
        return nil;
        
    }
    
    return nil;
}



@end
