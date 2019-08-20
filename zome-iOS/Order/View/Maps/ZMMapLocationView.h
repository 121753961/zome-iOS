//
//  ZMMapLocationView.h
//  zome-iOS
//
//  Created by CFW on 2017/12/8.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMMapLocationView;

@protocol ZMMapLocationViewDelegate <NSObject>
@optional
-(void)mapLocationView:(ZMMapLocationView *)vc startBtnAction:(UIButton *)btn;

-(void)mapLocationView:(ZMMapLocationView *)vc endBtnAction:(UIButton *)btn;

@end

@interface ZMMapLocationView : UIView

-(instancetype)myMapLocationView;
@property (weak, nonatomic) IBOutlet UIImageView *pickupImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickupImgW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickupImgH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickupImgML;
@property (weak, nonatomic) IBOutlet UILabel *startLocationLabel;
@property (weak, nonatomic) IBOutlet UITextField *currLocationTextField;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *dstionImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dstinImgML;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dstionImgW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dstionImgH;

@property (nonatomic, weak) id<ZMMapLocationViewDelegate> delegate;


@end
