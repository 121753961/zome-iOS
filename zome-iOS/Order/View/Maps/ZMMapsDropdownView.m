//
//  ZMMapsDropdownView.m
//  zome-iOS
//
//  Created by CFW on 2017/12/12.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMMapsDropdownView.h"

@implementation ZMMapsDropdownView

-(instancetype)myMapDropdownView{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ZMMapsDropdownView class]) owner:nil options:nil]lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)pickLocationAction:(UIButton *)sender {
    self.hidden = YES;
    if ([_delegate respondsToSelector:@selector(mapsDropdownView:pickLocationAction:)]) {
        [_delegate mapsDropdownView:self pickLocationAction:sender];
    }
}

- (IBAction)pickEnterLocationAction:(UIButton *)sender {
    self.hidden = YES;
    if ([_delegate respondsToSelector:@selector(mapsDropdownView:pickEnterLocationAction:)]) {
        [_delegate mapsDropdownView:self pickEnterLocationAction:sender];
    }
}

- (IBAction)homeAddrAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(mapsDropdownViewHomeSelectAddr:)]) {
        [_delegate mapsDropdownViewHomeSelectAddr:self];
    }
}

- (IBAction)workAddrAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(mapsDropdownViewWorkSelectAddr:)]) {
        [_delegate mapsDropdownViewWorkSelectAddr:self];
    }
}


@end
