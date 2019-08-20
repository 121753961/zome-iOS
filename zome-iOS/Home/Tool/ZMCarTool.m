//
//  ZMCarTool.m
//  zome-iOS
//
//  Created by CFW on 2017/12/23.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMCarTool.h"
#import "ZMCarBrandModel.h"
#import "ZMCartModelModel.h"
#import "ZMCarStyleYearColorModel.h"

@implementation ZMCarTool

/** *  查询所有汽车品牌 */
+(void)getCarBrandListSuccess:(void(^)(NSArray *array))successBlock failure:(void (^)(NSError *error))failure{
    [ZMHttpTool postWithPath:kApi_carBrand params:nil success:^(NSDictionary *result) {
        ZMCommonResult *resultModel = [[ZMCommonResult alloc] init];
        resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
        if (resultModel.status == 0) {
            NSArray *list = [ZMCarBrandModel mj_objectArrayWithKeyValuesArray:resultModel.data];
            successBlock(list);
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"NetworkError", nil)];
        failure(error);
    }];
}

/** *  根据品牌ID查询所有分类信息 */
+(void)getCarModelListWithBrand:(NSString *)brandId Success:(void(^)(NSArray *array))successBlock failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"brandId"] = brandId;
    [ZMHttpTool postWithPath:kApi_carModel params:params success:^(NSDictionary *result) {
        ZMCommonResult *resultModel = [[ZMCommonResult alloc] init];
        resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
        if (resultModel.status == 0) {
            NSArray *list = [ZMCartModelModel mj_objectArrayWithKeyValuesArray:resultModel.data];
            successBlock(list);
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"NetworkError", nil)];
        failure(error);
    }];
}

/** *  根据分类ID查询型号,生产年份和颜色信息 */
+(void)getCarStyleYearColorModel:(NSString *)modelId Success:(void(^)(NSArray *array))successBlock failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"modelId"] = modelId;
    [ZMHttpTool postWithPath:kApi_carStyleYearColor params:params success:^(NSDictionary *result) {
        ZMCommonResult *resultModel = [[ZMCommonResult alloc] init];
        resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
        if (resultModel.status == 0) {
            NSArray *list = [ZMCarStyleYearColorModel mj_objectArrayWithKeyValuesArray:resultModel.data];
            successBlock(list);
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"NetworkError", nil)];
        failure(error);
    }];
}

/** *  提交车辆信息 */
+(void)postDriverCarInfo:(NSDictionary *)params success:(void(^)(ZMCommonResult *result))successBlock failure:(void (^)(NSError *error))failure{
    [ZMHttpTool postWithPath:kApi_driverCarinfo params:params success:^(NSDictionary *result) {
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

/** *  获取车辆信息 */
+(void)getDriverCarInfoSuccess:(void(^)(ZMCommonResult *result))successBlock failure:(void (^)(NSError *error))failure{
    [ZMHttpTool getWithPath:kApi_driverCarinfo params:nil success:^(NSDictionary *result) {
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

/** *  获取本人提交的司机信息 , data为空则没有司机信息 */
+(void)getDriverProfileSuccess:(void(^)(ZMCommonResult *result))successBlock failure:(void (^)(NSError *error))failure{
    [ZMHttpTool getWithPath:kApi_driverProfile params:nil success:^(NSDictionary *result) {
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
