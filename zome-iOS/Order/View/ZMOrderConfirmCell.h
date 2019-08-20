//
//  ZMOrderConfirmCell.h
//  zome-iOS
//
//  Created by CFW on 2017/12/10.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZMOrderGotripDetail,ZMOrderConfirmCell;

@protocol ZMOrderConfirmCellDelegate <NSObject>

@required

/**  */
-(void)orderConfirmCell:(ZMOrderConfirmCell *)cell modifySeat:(ZMOrderGotripDetail *)model;


-(void)orderConfirmCell:(ZMOrderConfirmCell *)cell modifyAddess:(ZMOrderGotripDetail *)model;


-(void)orderConfirmCell:(ZMOrderConfirmCell *)cell modifyTime:(ZMOrderGotripDetail *)model;


@end


@interface ZMOrderConfirmCell : UITableViewCell

+(NSString *)ID;

+(id)myInit;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,assign) NSInteger cellType;

@property (nonatomic, strong) ZMOrderGotripDetail *tripDetailModel;

@property (weak, nonatomic) IBOutlet UILabel *seatLabel;

@property (weak, nonatomic) IBOutlet UILabel *fromAddLabel;

@property (weak, nonatomic) IBOutlet UILabel *toAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeMLabel;

@property (nonatomic, weak) id<ZMOrderConfirmCellDelegate> delegate;

@property (nonatomic, assign) BOOL hasReturn;

@end
