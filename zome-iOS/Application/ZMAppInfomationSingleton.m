//
//  ZMAppInfomationSingleton.m
//  zome-iOS
//
//  Created by CFW on 2017/12/8.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMAppInfomationSingleton.h"

@implementation ZMAppInfomationSingleton

static ZMAppInfomationSingleton *_singleton = NULL;

bool _isLogin;

//返回单例实例化对象
+(ZMAppInfomationSingleton *)sharedInstance{
    if (nil == _singleton){
        _singleton = [[self alloc] init];
    }
    return _singleton;
}

//保存信息
- (void)saveObject:(NSString *)aObjectStr forKey:(NSString *)aKey{
    @synchronized(self){
        if (nil == _saveDataDic) {
            _saveDataDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        if ([aKey isKindOfClass:[NSString class]] && [aObjectStr isKindOfClass:[NSString class]]) {
            [_saveDataDic setObject:aObjectStr forKey:aKey];
        }
    }
}

//获取保存的信息
- (NSString *)objectForKey:(NSString *)aKey{
    @synchronized(self){
        NSString *obj = nil;
        if (_saveDataDic) {
            if (aKey) {
                if ([aKey isKindOfClass:[NSString class]]) {
                    NSArray *keys = [_saveDataDic allKeys];
                    for (NSString *key in keys) {
                        if ([aKey isEqualToString:key]) {
                            obj = [_saveDataDic objectForKey:aKey];
                            break;
                        }
                    }
                }
            }
        }
        return obj;
    }
}

- (void)setLogin:(BOOL)isLogin{
    _isLogin = isLogin;
}

- (BOOL)isLogin{
    return _isLogin;
}


- (void)setUserId:(NSString *)uId{
    @synchronized(self){
        if (nil == _saveDataDic) {
            _saveDataDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        if ([uId isKindOfClass:[NSString class]]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:uId forKey:@"USERID"];
            [user synchronize];
            [_saveDataDic setObject:uId forKey:@"USERID"];
            
        }
    }
}

//获取登录后的userId
- (NSString *)getUserId{
    NSString *codeSrt;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    @synchronized(self){
        codeSrt = [user objectForKey:@"USERID"];
        if (codeSrt && [codeSrt isKindOfClass:[NSString class]]) {
            return codeSrt;
        }else{
          return nil;;
        }
    }
}

// accessToken
- (void)setAccessToken:(NSString *)accessToken{
    @synchronized(self){
        if (nil == _saveDataDic) {
            _saveDataDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        if ([accessToken isKindOfClass:[NSString class]]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:accessToken forKey:@"ACCESSTOKEN"];
            [user synchronize];
            [_saveDataDic setObject:accessToken forKey:@"ACCESSTOKEN"];
            
        }
    }
}

- (NSString *)getAccessToken{
    NSString *codeSrt;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    @synchronized(self){
        codeSrt = [user objectForKey:@"ACCESSTOKEN"];
        if (codeSrt && [codeSrt isKindOfClass:[NSString class]]) {
            return codeSrt;
        }else{
            return nil;
        }
    }
}

- (NSString *)getoginCode{
    NSString *codeSrt;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    @synchronized(self){
        codeSrt = [user objectForKey:@"ACCESSTOKEN"];
        if (codeSrt && [codeSrt isKindOfClass:[NSString class]]) {
            return codeSrt;
        }else{
            return nil;
        }
    }
}

- (NSString *)getDefaultProfileId{
    NSString *codeSrt;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    @synchronized(self){
        codeSrt = [user objectForKey:@"defaultProfileId"];
        if (codeSrt && [codeSrt isKindOfClass:[NSString class]]) {
            return codeSrt;
        }else{
            return nil;
        }
    }
}

- (NSString *)getCurrLatitude{
    NSString *codeSrt;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    @synchronized(self){
        codeSrt = [user objectForKey:@"USER_curr_Latitude"];
        if (codeSrt && [codeSrt isKindOfClass:[NSString class]]) {
            return codeSrt;
        }else{
            return nil;
        }
    }
}

- (NSString *)getCurrLongitude{
    NSString *codeSrt;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    @synchronized(self){
        codeSrt = [user objectForKey:@"USER_curr_longitude"];
        if (codeSrt && [codeSrt isKindOfClass:[NSString class]]) {
            return codeSrt;
        }else{
            return nil;
        }
    }
}



-(void)setUserDefault:(ZMUserInfo *)userInfo{
    // 持久化操作者
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:userInfo.accessToken forKey:@"ACCESSTOKEN"];
    [userDefaults setValue:userInfo.userId forKey:@"USERID"];
    [userDefaults setValue:userInfo.status forKey:@"status"];
    [userDefaults setValue:userInfo.userType forKey:@"userType"];
    [userDefaults setValue:userInfo.workAddr forKey:@"workAddr"];
    [userDefaults setValue:userInfo.workLatitude forKey:@"workLatitude"];
    [userDefaults setValue:userInfo.workLongitude forKey:@"workLongitude"];
    [userDefaults setValue:userInfo.homeAddr forKey:@"homeAddr"];
    [userDefaults setValue:userInfo.homeLatitude forKey:@"homeLatitude"];
    [userDefaults setValue:userInfo.homeLongitude forKey:@"homeLongitude"];
    [userDefaults setValue:userInfo.defaultProfileId forKey:@"defaultProfileId"];
    [userDefaults setValue:userInfo.email forKey:@"userEmail"];
    [userDefaults setValue:userInfo.avatar forKey:@"userAvatar"];
    [userDefaults setValue:userInfo.firstName forKey:@"userFirstName"];
    [userDefaults setValue:userInfo.lastName forKey:@"userLastName"];
    [userDefaults setValue:userInfo.phone forKey:@"userPhone"];
    
    [userDefaults synchronize];
}

-(ZMUserInfo *)getUserDefault{
    ZMUserInfo *userInfo = [[ZMUserInfo alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    @synchronized(self){
        userInfo.accessToken = [self getUserDefaults:user WithKey:@"ACCESSTOKEN"];
        
        userInfo.userId = [self getUserDefaults:user WithKey:@"USERID"];
        
        userInfo.status = [self getUserDefaults:user WithKey:@"status"];
        
        userInfo.userType = [self getUserDefaults:user WithKey:@"userType"];
        
        userInfo.workAddr = [self getUserDefaults:user WithKey:@"workAddr"];
        userInfo.workLatitude = [self getUserDefaults:user WithKey:@"workLatitude"];
        userInfo.workLongitude = [self getUserDefaults:user WithKey:@"workLongitude"];
        
        userInfo.homeAddr = [self getUserDefaults:user WithKey:@"homeAddr"];
        userInfo.homeLatitude = [self getUserDefaults:user WithKey:@"homeLatitude"];
        userInfo.homeLongitude = [self getUserDefaults:user WithKey:@"homeLongitude"];
        
        userInfo.defaultProfileId = [self getUserDefaults:user WithKey:@"defaultProfileId"];
        userInfo.email = [self getUserDefaults:user WithKey:@"userEmail"];
        userInfo.avatar = [self getUserDefaults:user WithKey:@"userAvatar"];
        userInfo.lastName = [self getUserDefaults:user WithKey:@"userLastName"];
        userInfo.firstName = [self getUserDefaults:user WithKey:@"userFirstName"];
        userInfo.phone = [self getUserDefaults:user WithKey:@"userPhone"];
    }
    return userInfo;
}

-(NSString *)getUserDefaults:(NSUserDefaults *)user WithKey:(NSString *)key{
    NSString *codeStr;
    codeStr = [user objectForKey:key];
    if (codeStr && [codeStr isKindOfClass:[NSString class]]) {
        return codeStr;
    }else{
        return @"";
    }
}

//清楚单例中保存的所有信息
- (void)clearAllInformation{
    if (_saveDataDic) {
        [_saveDataDic removeAllObjects];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"USERID"];
    [user removeObjectForKey:@"ACCESSTOKEN"];
    [user synchronize];
    _isLogin = NO;
}

+ (id)alloc {
    @synchronized (self) {
        if (nil == _singleton) {
            _singleton = [super alloc];
        }
    }
    return _singleton;
}




@end
