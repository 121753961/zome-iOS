//
//  ZMAPI.h
//  zome-iOS
//
//  Created by CFW on 2017/11/30.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#ifndef ZMAPI_h
#define ZMAPI_h

#pragma mark -- user
#define kApi_userRegister  @"api/user/register"

#define kApi_userVerifyinfo @"api/user/verifyinfo"

// 发送短信验证码. debug=1 不发会真实送短信，返回结果中会有产生的短信验证码，可以用在注册接口中。
#define kApi_userSendsms @"api/user/sendsms"

#define kApi_userLogin @"api/user/login"

#define kApi_userForgotpwd @"api/user/forgotpwd"


// Stripe - Pay
#define kApi_stripeCardAdd @"api/pay/stripe/card/add" // 用户绑定银行卡

#define kApi_stripeCardList @"api/pay/stripe/card/list" // 查询用户所有银行卡

#define kApi_stripeCardDefault @"api/pay/stripe/card/default" // 用户设置默认支付银行卡

#define kApi_stripeCardDelete @"api/pay/stripe/card/delete" // 用户删除银行卡

#define kApi_stripeCardUpdate @"api/pay/stripe/card/update" // 更新银行卡


// Car
#define kApi_carBrand @"api/car/brand" // 查询所有汽车品牌

#define kApi_carModel @"api/car/model" // 根据品牌ID查询所有分类信息

#define kApi_carStyleYearColor @"api/car/styleYearColor" // 根据分类ID查询型号,生产年份和颜色信息


// Driver
#define kApi_driverCarinfo @"api/driver/carinfo" // 车辆信息

#define kApi_driverProfile @"api/driver/driverprofile" // 司机的信息


// Trip
#define kApi_tripReq @"api/trip/req" // 乘客发起的匹配请求



#endif /* ZMAPI_h */
