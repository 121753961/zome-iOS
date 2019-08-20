//
//  ZMMapsDropdownView.h
//  zome-iOS
//
//  Created by CFW on 2017/12/12.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMMapsDropdownView;

@protocol ZMMapsDropdownViewDelegate <NSObject>
@optional
-(void)mapsDropdownView:(ZMMapsDropdownView *)vc pickLocationAction:(UIButton *)btn;

-(void)mapsDropdownView:(ZMMapsDropdownView *)vc pickEnterLocationAction:(UIButton *)btn;

-(void)mapsDropdownViewHomeSelectAddr:(ZMMapsDropdownView *)vc;


-(void)mapsDropdownViewWorkSelectAddr:(ZMMapsDropdownView *)vc;

@end

@interface ZMMapsDropdownView : UIView

-(instancetype)myMapDropdownView;

@property (weak, nonatomic) IBOutlet UIView *homeAddView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeAddViewH;
@property (weak, nonatomic) IBOutlet UIView *workAddView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workAddViewH;
@property (weak, nonatomic) IBOutlet UILabel *homeAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *workAddrLabel;

@property (nonatomic, weak) id<ZMMapsDropdownViewDelegate> delegate;

@end
