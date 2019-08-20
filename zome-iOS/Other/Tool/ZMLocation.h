//
//  ZMLocation.h
//  zome-iOS
//
//  Created by CFW on 2018/1/2.
//  Copyright © 2018年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlaces/GooglePlaces.h>
#import <UIKit/UIKit.h>

typedef void (^ZMZMLocationCallback)(GMSPlaceLikelihoodList *likelihoodList,
                                               NSError *error);

@interface ZMLocation : NSObject

@property (nonatomic, strong) CLLocationManager *loacationManager;

@property(nonatomic, strong) GMSPlacesClient *placesClient;

+(id)sharedLocation;

/*
 * 是否打开手机定位服务
 */
+(BOOL)isLocationServicesEnabled;

-(void)requestWhenInUseAuthorization;

-(void)currentPlaceWithCallback:(ZMZMLocationCallback)callback;

@end
