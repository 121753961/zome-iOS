//
//  ZMAppInfomationSingleton.h
//  zome-iOS
//
//  Created by CFW on 2017/12/8.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZMUserInfo.h"

@interface ZMAppInfomationSingleton : NSObject
{
    /**
     * 保存单例中数据字典
     */
    NSMutableDictionary *_saveDataDic;
}

/**
 * @brief  获取单例的实例化对象
 * @return 单例类的实例化对象
 */
+(ZMAppInfomationSingleton *)sharedInstance;

/**
 * @brief  在单例中保存用户登录后获取的token值，并实例化到本地
 */
- (void)setUserId:(NSString *)uId;
- (NSString *)getUserId;



/**
 * @brief  获取单例中登录后存储的token
 */
- (NSString *)getAccessToken;
- (void)setAccessToken:(NSString *)accessToken;

- (NSString *)getoginCode;

- (NSString *)getDefaultProfileId;



- (NSString *)getCurrLatitude;

- (NSString *)getCurrLongitude;


/**
 * @brief  在单例中存储键值对，并不会系列化到本地
 * @param  aKey  为存储的键
 * @param  aObjectStr 为值
 */
- (void)saveObject:(NSString *)aObjectStr forKey:(NSString *)aKey;

/**
 * @brief  从单例类中获得给定键的值
 * @param  aKey 键值对中得键
 */
- (NSString *)objectForKey:(NSString *)aKey;

//清楚单例中保存的所有信息
- (void)clearAllInformation;

-(void)setUserDefault:(ZMUserInfo *)userInfo;

-(ZMUserInfo *)getUserDefault;


@end
