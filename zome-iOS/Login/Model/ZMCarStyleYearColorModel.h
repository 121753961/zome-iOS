//
//  ZMCarStyleYearColorModel.h
//  zome-iOS
//
//  Created by CFW on 2017/12/23.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMCarStyleYearColorModel : NSObject

@property (nonatomic,copy) NSString *modelId;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *color;
@property (nonatomic,strong) NSArray *colorArray;

@property (nonatomic,copy) NSString *year;
@property (nonatomic,strong) NSArray *yearArray;


@end
