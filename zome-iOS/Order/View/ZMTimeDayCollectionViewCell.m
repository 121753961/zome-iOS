//
//  ZMTimeDayCollectionViewCell.m
//  zome-iOS
//
//  Created by CFW on 2017/12/9.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMTimeDayCollectionViewCell.h"

@interface ZMTimeDayCollectionViewCell ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ZMTimeDayCollectionViewCell

+(NSString *)ID{
    return NSStringFromClass([self class]);
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    return self;
}

-(void)setDate:(NSDate *)date{
    _date = date;
    
    [self.dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [self.dateFormatter stringFromDate:date];
    _dayLabel.text = dayFormattedString;
    
    [self.dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [self.dateFormatter stringFromDate:date];
    _dayInWeekLabel.text = dayInWeekFormattedString;
    
    [self.dateFormatter setDateFormat:@"MMMM"];
    NSString *monthFormattedString = [[self.dateFormatter stringFromDate:date] uppercaseString];
    _monthLabel.text = monthFormattedString;
}

- (NSDateFormatter *)dateFormatter
{
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
