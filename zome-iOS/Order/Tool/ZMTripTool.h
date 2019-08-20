//
//  ZMTripTool.h
//  zome-iOS
//
//  Created by CFW on 2017/12/24.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMTripTool : NSObject

/** *  乘客发起的匹配请求 */
+(void)postTripReqWithParams:(NSDictionary *)params success:(void(^)(ZMCommonResult *result))successBlock failure:(void (^)(NSError *error))failure;


@end
