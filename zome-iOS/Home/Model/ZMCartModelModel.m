//
//  ZMCartModelModel.m
//  zome-iOS
//
//  Created by CFW on 2017/12/23.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMCartModelModel.h"

@implementation ZMCartModelModel

// 关键字应应射
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"Id" : @"id"
             };
}

@end
