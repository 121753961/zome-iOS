//
//  ZMStrpePayTool.m
//  zome-iOS
//
//  Created by CFW on 2017/12/21.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMStrpePayTool.h"
#import "ZMPaymentCardModel.h"

@implementation ZMStrpePayTool

/** *  获取银行卡列表 */
+(void)getStripeCardListSuccess:(void(^)(NSArray *array))successBlock failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [[ZMAppInfomationSingleton sharedInstance] getUserId];
    [ZMHttpTool postWithPath:kApi_stripeCardList params:params success:^(NSDictionary *result) {
        ZMCommonResult *resultModel = [[ZMCommonResult alloc] init];
        resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
        if (resultModel.status == 0) {
            NSArray *list = [ZMPaymentCardModel mj_objectArrayWithKeyValuesArray:resultModel.data];
            successBlock(list);
        }else{
           [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"NetworkError", nil)];
        failure(error);
    }];
}

/** *  设置默认支付方式 */
+(void)setStripeDefaultCard:(NSString *)cardId Success:(void(^)(ZMCommonResult *resultModel))successBlock failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [[ZMAppInfomationSingleton sharedInstance] getUserId];
    params[@"cardId"] = cardId;
    [ZMHttpTool postWithPath:kApi_stripeCardDefault params:params success:^(NSDictionary *result) {
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

/** *  删除卡 */
+(void)setStripeDelCard:(NSString *)cardId Success:(void(^)(ZMCommonResult *resultModel))successBlock failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [[ZMAppInfomationSingleton sharedInstance] getUserId];
    params[@"cardId"] = cardId;
    [ZMHttpTool postWithPath:kApi_stripeCardDelete params:params success:^(NSDictionary *result) {
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


/** *  更新银行卡 */
+(void)upDateCardWithParams:(NSDictionary *)params Success:(void(^)(BOOL isSuccess))successBlock failure:(void (^)(NSError *error))failure{
    [ZMHttpTool postWithPath:kApi_stripeCardUpdate params:params success:^(NSDictionary *result) {
        ZMCommonResult *resultModel = [[ZMCommonResult alloc] init];
        resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
        if (resultModel.status == 0) {
            successBlock(true);
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"NetworkError", nil)];
        failure(error);
    }];
}

@end
