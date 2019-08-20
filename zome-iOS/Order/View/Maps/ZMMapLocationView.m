//
//  ZMMapLocationView.m
//  zome-iOS
//
//  Created by CFW on 2017/12/8.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMMapLocationView.h"

@interface ZMMapLocationView()


@end


@implementation ZMMapLocationView

-(instancetype)myMapLocationView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ZMMapLocationView class]) owner:nil options:nil]lastObject];
}

- (IBAction)locationAction:(UIButton *)sender {
//    [UIView animateWithDuration:0.3f animations:^{
//        self.pickupImgW.constant = 20;
//        self.pickupImgH.constant = 20;
//        self.pickupImgML.constant = 9;
//        [self.pickupImg layoutIfNeeded];
//    }];
    
    if ([_delegate respondsToSelector:@selector(mapLocationView:startBtnAction:)]) {
        [_delegate mapLocationView:self startBtnAction:sender];
    }
}

- (IBAction)endBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(mapLocationView:endBtnAction:)]) {
        [_delegate mapLocationView:self endBtnAction:sender];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
