//
//  ZMOrderTripReqParams.h
//  zome-iOS
//
//  Created by CFW on 2017/12/19.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZMOrderGotripDetail;

@interface ZMOrderTripReqParams : NSObject

@property(nonatomic, strong) ZMOrderGotripDetail *goTripDetailVO;

@property(nonatomic, copy) NSString *hasReturn;

@property (nonatomic, strong) ZMOrderGotripDetail *returnTripDetailVO;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userType;


@end
