//
//  ZMCommonResult.h
//  zome-iOS
//
//  Created by CFW on 2017/12/4.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMCommonResult : NSObject

@property(nonatomic, copy) NSString *message;

@property(nonatomic, assign) NSInteger status;

@property(nonatomic, assign) id data;

@end
