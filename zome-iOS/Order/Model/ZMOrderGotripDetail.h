//
//  ZMOrderGotripDetail.h
//  zome-iOS
//
//  Created by CFW on 2017/12/19.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMOrderGotripDetail : NSObject

@property (nonatomic, copy) NSString *fromAddr;

@property (nonatomic, copy) NSString *fromLatitude;

@property (nonatomic, copy) NSString *fromLongitude;

@property (nonatomic, copy) NSString *requestTimeEndOrig;

@property (nonatomic, copy) NSString *requestTimeStartOrig;

@property (nonatomic, assign) NSInteger seats;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *toAddr;

@property (nonatomic, copy) NSString *toLatitude;

@property (nonatomic, copy) NSString *toLongitude;

@property (nonatomic, assign) NSInteger tripType;






@end
