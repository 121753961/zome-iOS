//
//  ZMTripTool.m
//  zome-iOS
//
//  Created by CFW on 2017/12/24.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMTripTool.h"

@implementation ZMTripTool

/** *  乘客发起的匹配请求 */
+(void)postTripReqWithParams:(NSDictionary *)params success:(void(^)(ZMCommonResult *result))successBlock failure:(void (^)(NSError *error))failure{
    [ZMHttpTool postWithPath:kApi_tripReq params:params success:^(NSDictionary *result) {
        ZMCommonResult *resultModel = [[ZMCommonResult alloc] init];
        resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
        if (resultModel.status == 0) {
            successBlock(resultModel);
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"NetworkError", nil)];
        failure(error);
    }];
}

@end
