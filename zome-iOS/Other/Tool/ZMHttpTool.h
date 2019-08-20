//
//  ZMHttpTool.h
//  zome-iOS
//
//  Created by CFW on 2017/11/26.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZMUploadParam;

/**
 * 请求成功之后的回调
 * @prama json 后台返回的数据类型
 */
typedef void(^ZMHttpSuccess)(NSDictionary *result);

/**
 * 请求失败之后的回调
 * @prama error 错误信息
 */
typedef void(^ZMHttpFailure)(NSError *error);

@interface ZMHttpTool : NSObject

/**
 *  发送一个GET请求
 *
 *  @param path    请求路径
 *  @param params  请求参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 *
 */
+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(ZMHttpSuccess)success
            failure:(ZMHttpFailure)failure;


/**
 *  发送一个GET请求
 *
 *  @param path    请求路径
 *  @param host    请求主机头
 *  @param params  请求参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 *
 */
+ (void)getWithPath:(NSString *)path
               host:(NSString *)host
             params:(NSDictionary *)params
            success:(ZMHttpSuccess)success
            failure:(ZMHttpFailure)failure;

/**
 *  发送一个PSOT请求
 *
 *  @param path    请求路径
 *  @param params  请求参数
 *  @param success 请求成功回调
 *  @param failure 请求失败回调
 *
 */
+(void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(ZMHttpSuccess)success failure:(ZMHttpFailure)failure;

/**
 *  上传图片
 *
 *  @param URLString   上传图片的网址字符串
 *  @param parameters  上传图片的参数
 *  @param ZMUploadParam 上传图片的信息
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 */
+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                uploadParam:(NSArray <ZMUploadParam *> *)uploadParams
                    success:(ZMHttpSuccess)success
                    failure:(ZMHttpFailure)failure;



@end
