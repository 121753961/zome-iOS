//
//  ZMHttpTool.m
//  zome-iOS
//
//  Created by CFW on 2017/11/26.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMHttpTool.h"
#import <AFNetworking.h>
#import "ZMUploadParam.h"
#import "ZMUtilityTools.h"
#import "NSString+ZMUtil.h"

@implementation ZMHttpTool

+(void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(ZMHttpSuccess)success failure:(ZMHttpFailure)failure{
    [self getWithPath:path host:@"" params:params success:success failure:failure];
}

+(void)getWithPath:(NSString *)path host:(NSString *)host params:(NSDictionary *)params success:(ZMHttpSuccess)success failure:(ZMHttpFailure)failure{
    //1.创建AFHTTPSessionManager管理者
    NSString *url = [host isEqualToString:@""] ? [NSString stringWithFormat:@"%@/%@",kAPIHost,path] : path;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *token = [[ZMAppInfomationSingleton sharedInstance]getAccessToken];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"x-access-token"];
    // 打印请求报文
    [ZMHttpTool httpLog:url params:params];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


+(void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(ZMHttpSuccess)success failure:(ZMHttpFailure)failure{
    [self postWithPath:path host:@"" params:params success:success failure:failure];
}

+(void)postWithPath:(NSString *)path host:(NSString *)host params:(NSDictionary *)params success:(ZMHttpSuccess)success failure:(ZMHttpFailure)failure{
    NSMutableDictionary *newParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    
//    // 随机字符串(长度8-16位)
//    NSString *noncstr = [NSString randomStrLength:16];
//    [newParams setObject:noncstr forKey:@"noncstr"];
//
//    // 当前时间 Timestamp
//    NSString *timestamp = [NSString getNowTimeTimestamp];
//    [newParams setObject:timestamp forKey:@"timestamp"];
//
//    NSString *sign =  [ZMUtilityTools signWithSourceDic:newParams];
//    ZMLog(@"%@",sign);
//
//    [newParams setObject:sign forKey:@"sign"];
    
    
    NSString *url = [host isEqualToString:@""] ? [NSString stringWithFormat:@"%@/%@",kAPIHost,path] : path;
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    // 申明返回的结果是json类型
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 申明请求的数据是json类型
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //[sessionManager.requestSerializer setValue:sign forHTTPHeaderField:@"x-sign"];
    
//    [sessionManager.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
    [sessionManager.requestSerializer setValue:@"1001" forHTTPHeaderField:@"x-app-id"];

    NSString *token = [[ZMAppInfomationSingleton sharedInstance]getAccessToken];
    [sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"x-access-token"];
    
    // 3.设置超时时间为10s
    sessionManager.requestSerializer.timeoutInterval = 10;
    // 打印请求报文
    [ZMHttpTool httpLog:url params:params];
    [sessionManager POST:url parameters:newParams progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+(void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters uploadParam:(NSArray<ZMUploadParam *> *)uploadParams success:(ZMHttpSuccess)success failure:(ZMHttpFailure)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (ZMUploadParam *uploadParam in uploadParams) {
            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(NSString *)paramsString:(NSDictionary *)params{
    NSMutableString *paramString = [[NSMutableString alloc] init];
    
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramString appendString:str];
        [paramString appendString:@"&"];
    }];
    if([paramString hasSuffix:@"&"]){
        paramString = [[paramString substringToIndex:[paramString length]-1] mutableCopy];
        
    }
    return paramString;
}

+(void)httpLog:(NSString *)url params:(id)params{
    NSString *paramsStr = [self paramsString:params];
    ZMLog(@"--------  ZMHttpTool  ---------");
    ZMLog(@"-------------------------------");
    ZMLog(@"  %@?%@",url,paramsStr);
    ZMLog(@"--------  ZMHttpTool  ---------");
}


@end
