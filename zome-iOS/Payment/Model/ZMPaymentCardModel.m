//
//  ZMPaymentCardModel.m
//  zome-iOS
//
//  Created by CFW on 2017/12/22.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMPaymentCardModel.h"

@implementation ZMPaymentCardModel

// 关键字应应射
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id"
             };
}

-(void)setExpMonth:(NSString *)expMonth{
    NSInteger m = [expMonth integerValue];
    if (m < 10) {
        _expMonth = [NSString stringWithFormat:@"0%@",expMonth];
    }else{
        _expMonth = expMonth;
    }
}

-(void)setDefaultCard:(NSString *)defaultCard{
    _defaultCard = defaultCard;
    if ([defaultCard isEqualToString:@"Y"]) {
        _isDefaultCard = YES;
    }else{
        _isDefaultCard = NO;
    }
}

@end
