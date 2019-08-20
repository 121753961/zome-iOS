//
//  ZMMapsPredictionCell.h
//  zome-iOS
//
//  Created by CFW on 2018/1/1.
//  Copyright © 2018年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMMapsPredictionCell : UITableViewCell

+(NSString *)ID;

+(id)myInit;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTileLabel;



@end
