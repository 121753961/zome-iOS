//
//  ZMPaymentCardModel.h
//  zome-iOS
//
//  Created by CFW on 2017/12/22.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMPaymentCardModel : NSObject

@property (nonatomic, copy) NSString *createdBy;

@property (nonatomic, copy) NSString *updatedBy;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, assign) BOOL isDeleted;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *brand;

@property (nonatomic, copy) NSString *lastFour;

@property (nonatomic, copy) NSString *expMonth;

@property (nonatomic, copy) NSString *expYear;

@property (nonatomic, copy) NSString *funding;

@property (nonatomic, copy) NSString *defaultCard;

@property (nonatomic, assign) BOOL isDefaultCard;

@property (nonatomic, copy) NSString *zip;

@property (nonatomic, copy) NSString *city;


@end
