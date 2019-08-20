//
//  ZMUserInfo.h
//  zome-iOS
//
//  Created by CFW on 2017/12/5.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMUserInfo : NSObject

@property(nonatomic,copy) NSString *accessToken;

@property(nonatomic,copy) NSString *avatar;

@property(nonatomic,copy) NSString *email;

@property(nonatomic,copy) NSString *firstName;

@property(nonatomic,copy) NSString *gender;

@property(nonatomic,copy) NSString *lastName;

@property(nonatomic,copy) NSString *phone;

@property(nonatomic,copy) NSString *status;

@property(nonatomic,copy) NSString *userId;

@property(nonatomic,copy) NSString *userType;

@property(nonatomic,copy) NSString *homeAddr;

@property(nonatomic,copy) NSString *defaultProfileId;

@property(nonatomic,copy) NSString *homeLatitude;

@property(nonatomic,copy) NSString *homeLongitude;

@property(nonatomic,copy) NSString *workAddr;

@property(nonatomic,copy) NSString *workLatitude;

@property(nonatomic,copy) NSString *workLongitude;



@end
