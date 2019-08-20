//
//  ZMOrderConfirmCell.m
//  zome-iOS
//
//  Created by CFW on 2017/12/10.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMOrderConfirmCell.h"
#import "ZMOrderGotripDetail.h"

@interface ZMOrderConfirmCell ()
@property (weak, nonatomic) IBOutlet UIImageView *time_right_icon;
@property (weak, nonatomic) IBOutlet UIImageView *seat_right_icon;


@end

@implementation ZMOrderConfirmCell

+(NSString *)ID{
    return NSStringFromClass([self class]);
}

+(id)myInit{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ZMOrderConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:[self ID]];
    if (cell == nil) {
        cell = [ZMOrderConfirmCell myInit];
    }
    return cell;
}

-(void)setCellType:(NSInteger)cellType{
    _cellType = cellType;
    
    if (cellType == 1) {
        
    }else if (cellType == 2){
        _time_right_icon.hidden = YES;
        _seat_right_icon.hidden = YES;
    }
}

-(void)setTripDetailModel:(ZMOrderGotripDetail *)tripDetailModel{
    _fromAddLabel.text = tripDetailModel.fromAddr;
    
    _toAddLabel.text = tripDetailModel.toAddr;
    
    _seatLabel.text = [NSString stringWithFormat:@"%ld",tripDetailModel.seats];
    
    NSString *endTime = [self getDateHHMMString:tripDetailModel.requestTimeEndOrig];
    
    NSString *startTime = [self getDateHHMMString:tripDetailModel.requestTimeStartOrig];
    _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",startTime,endTime];
    
    _timeMLabel.text = [self getDateFromString:tripDetailModel.requestTimeStartOrig];
}



-(NSString *)getDateFromString:(NSString *)string{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *data = [format dateFromString:string];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   
    [formatter setDateFormat:@"MMMM"];
    NSString *monthFormattedString = [[formatter stringFromDate:data] uppercaseString];
    
    [formatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [formatter stringFromDate:data];
    
    NSString *time = [NSString stringWithFormat:@"%@.%@",monthFormattedString,dayFormattedString];
    ZMLog(@"fjdfklsjfsd");
    return time;
}

-(NSString *)getDateHHMMString:(NSString *)string{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *data = [format dateFromString:string];
    //利用NSCalendar处理日期
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:data];
    NSString *houtStr = hour < 10 ? [NSString stringWithFormat:@"0%ld",hour] : [NSString stringWithFormat:@"%ld",hour];
    
    NSInteger minute = [calendar component:NSCalendarUnitMinute fromDate:data];
    NSString *minuteStr = minute < 10 ? [NSString stringWithFormat:@"0%ld",minute] : [NSString stringWithFormat:@"%ld",minute];
    
    
    NSString *time = [NSString stringWithFormat:@"%@:%@",houtStr,minuteStr];
    
    return time;
}


- (IBAction)timeAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(orderConfirmCell:modifyTime:)]) {
        [_delegate orderConfirmCell:self modifyTime:_tripDetailModel];
    }
}


- (IBAction)addessAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(orderConfirmCell:modifyAddess:)]) {
        [_delegate orderConfirmCell:self modifyAddess:_tripDetailModel];
    }
}


- (IBAction)seatAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(orderConfirmCell:modifySeat:)]) {
        [_delegate orderConfirmCell:self modifySeat:_tripDetailModel];
    }
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
