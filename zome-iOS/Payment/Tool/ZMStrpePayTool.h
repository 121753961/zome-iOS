//
//  ZMStrpePayTool.h
//  zome-iOS
//
//  Created by CFW on 2017/12/21.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMStrpePayTool : NSObject

/** *  获取银行卡列表 */
+(void)getStripeCardListSuccess:(void(^)(NSArray *array))successBlock failure:(void (^)(NSError *error))failure;

/** *  设置默认支付方式 */
+(void)setStripeDefaultCard:(NSString *)cardId Success:(void(^)(ZMCommonResult *resultModel))successBlock failure:(void (^)(NSError *error))failure;

/** *  删除卡 */
+(void)setStripeDelCard:(NSString *)cardId Success:(void(^)(ZMCommonResult *resultModel))successBlock failure:(void (^)(NSError *error))failure;

/** *  更新银行卡 */
+(void)upDateCardWithParams:(NSDictionary *)params Success:(void(^)(BOOL isSuccess))successBlock failure:(void (^)(NSError *error))failure;

@end
