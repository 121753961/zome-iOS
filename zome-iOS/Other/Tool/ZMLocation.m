//
//  ZMLocation.m
//  zome-iOS
//
//  Created by CFW on 2018/1/2.
//  Copyright © 2018年 KunagBing. All rights reserved.
//


#import "ZMLocation.h"

@implementation ZMLocation

static id _sLocation;

+(id)sharedLocation{
    if (_sLocation == nil) {
        _sLocation = [[ZMLocation alloc] init];
    }
    return _sLocation;
}

-(id)init{
    self = [super init];
    if (self) {
        _placesClient = [[GMSPlacesClient alloc] init];
        _loacationManager = [[CLLocationManager alloc] init];
        // 请求前台定位权限
        [_loacationManager requestWhenInUseAuthorization];
    }
    return self;
}

// 定位
-(void)currentPlaceWithCallback:(ZMZMLocationCallback)callback{
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
        callback(likelihoodList,error);
        if(likelihoodList != nil){
            GMSPlace *place = [[[likelihoodList likelihoods] lastObject] place];
            if(place != nil){
                NSLog(@"place === %@",place);
                // 持久化操作者
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *user_la = [NSString stringWithFormat:@"%f",place.coordinate.latitude];
                NSString *user_ln = [NSString stringWithFormat:@"%f",place.coordinate.longitude];
                [userDefaults setValue:user_la forKey:@"USER_curr_Latitude"];
                [userDefaults setValue:user_ln forKey:@"USER_curr_longitude"];
                [userDefaults setValue:place.name forKey:@"USER_curr_Address"];
                [userDefaults synchronize];
            }
        }
    }];
}

-(void)requestWhenInUseAuthorization{
    // 请求前台定位权限
    [_loacationManager requestWhenInUseAuthorization];
}


+(BOOL)isLocationServicesEnabled{
    if ([CLLocationManager locationServicesEnabled]){
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        BOOL result;
        switch (status) {
            case kCLAuthorizationStatusAuthorizedAlways:
                NSLog(@"持续使用授权");
                result = true;
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"使用中授权");
                result = true;
                break;
            case kCLAuthorizationStatusDenied:
                result = false;
                NSLog(@"授权被拒绝");
                break;
            case kCLAuthorizationStatusNotDetermined:
                result = false;
                NSLog(@"等待用户授权");
                break;
            default:
                result = false;
                break;
        }
        return result;
    }else{
        return false;
    }
}




@end
