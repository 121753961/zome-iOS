//
//  ZMMapNavView.m
//  zome-iOS
//
//  Created by CFW on 2017/12/8.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMMapNavView.h"

@implementation ZMMapNavView

-(instancetype)myMapNavView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZMMapNavView class]) owner:nil options:nil]lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
