//
//  ZMCarTool.h
//  zome-iOS
//
//  Created by CFW on 2017/12/23.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMCarTool : NSObject

/** *  查询所有汽车品牌 */
+(void)getCarBrandListSuccess:(void(^)(NSArray *array))successBlock failure:(void (^)(NSError *error))failure;


/** *  根据品牌ID查询所有分类信息 */
+(void)getCarModelListWithBrand:(NSString *)brandId Success:(void(^)(NSArray *array))successBlock failure:(void (^)(NSError *error))failure;

/** *  根据分类ID查询型号,生产年份和颜色信息 */
+(void)getCarStyleYearColorModel:(NSString *)modelId Success:(void(^)(NSArray *array))successBlock failure:(void (^)(NSError *error))failure;

/** *  提交车辆信息 */
+(void)postDriverCarInfo:(NSDictionary *)params success:(void(^)(ZMCommonResult *result))successBlock failure:(void (^)(NSError *error))failure;

/** *  获取车辆信息 */
+(void)getDriverCarInfoSuccess:(void(^)(ZMCommonResult *result))successBlock failure:(void (^)(NSError *error))failure;

/** *  获取本人提交的司机信息 , data为空则没有司机信息 */
+(void)getDriverProfileSuccess:(void(^)(ZMCommonResult *result))successBlock failure:(void (^)(NSError *error))failure;


@end
