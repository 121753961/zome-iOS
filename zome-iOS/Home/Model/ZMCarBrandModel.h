//
//  ZMCarBrandModel.h
//  zome-iOS
//
//  Created by CFW on 2017/12/23.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMCarBrandModel : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, strong) NSArray *carModelList;

@end
