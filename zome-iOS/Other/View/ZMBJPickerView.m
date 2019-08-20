//
//  ZMBJPickerView.m
//  zome-iOS
//
//  Created by CFW on 2017/12/18.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMBJPickerView.h"
#import "ZMBJPickerViewCellType_1.h"
#import "ZMBJPickerViewCellType.h"

#define YLSRect(x, y, w, h)  CGRectMake([UIScreen mainScreen].bounds.size.width * x, [UIScreen mainScreen].bounds.size.height * y, [UIScreen mainScreen].bounds.size.width * w,  [UIScreen mainScreen].bounds.size.height * h)

#define YLSFont(f) [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width * f]

#define YLSColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define YLSMainBackColor [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]

#define BlueColor [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]

#define ClearColor [UIColor clearColor]

@interface ZMBJPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    CancelHandler _cancelBlaok;
    DoneHandler _doneBlaok;
}
/** view */
@property (nonatomic,strong) UIView *topView;
/** button */
@property (nonatomic,strong) UIButton *doneBtn;
/** button */
@property (nonatomic,strong) UIButton *cancelBtn;
/** pickerView */
@property (nonatomic,strong) UIPickerView *pickerView;
/** srting */
@property (nonatomic,strong) NSString *result;

@property (nonatomic,assign) NSInteger resultRow;

@property (nonatomic, assign) NSInteger style;

@end

@implementation ZMBJPickerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:YLSRect(0, 0, 1, 917/667)];
    
    if (self)
    {
        self.style = 0;
        self.backgroundColor = YLSColorAlpha(0, 0, 0, 0.4);
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedSelf:)];
        tapGes.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGes];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topView = [[UIView alloc]initWithFrame:YLSRect(0, 667/667, 1, 250/667)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    //为view上面的两个角做成圆角。不喜欢的可以注掉
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.topView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topView.layer.mask = maskLayer;
    
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.doneBtn setFrame:YLSRect(320/375, 5/667, 50/375, 40/667)];
    [self.doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.doneBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cancelBtn setFrame:YLSRect(5/375, 5/667, 60/375, 40/667)];
    [self.cancelBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.cancelBtn];
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:YLSRect(100/375, 0, 175/375, 50/667)];
    titlelb.backgroundColor = ClearColor;
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.text = self.title;
    titlelb.font = YLSFont(20/375);
    [self.topView addSubview:titlelb];
    
    self.pickerView = [[UIPickerView alloc]init];
    [self.pickerView setFrame:YLSRect(0, 50/667, 1, 200/667)];
//    [self.pickerView setBackgroundColor:YLSMainBackColor];
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.topView addSubview:self.pickerView];
    
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(30, self.pickerView.frame.origin.y, 1, self.pickerView.frame.size.height);
    line.backgroundColor = YLSMainBackColor;
    [self.topView addSubview:line];
    
    UIView *icon = [[UIView alloc] init];
    icon.backgroundColor = [UIColor colorWithHex:0x228EE2];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 8.f;
    [self.topView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pickerView.mas_centerY);
        make.width.height.equalTo(@(16));
        make.left.equalTo(self.pickerView.mas_left).offset(22);
    }];
    
    
}

- (void)tapedSelf:(UITapGestureRecognizer *)tap {
    // 点击空白背景移除self
     [self quit];
}

//快速创建
+(instancetype)pickerView;
{
    return [[self alloc]init];
}

-(instancetype)initWithStyle:(NSInteger)style withCancelBlock:(CancelHandler)block{
    self = [super init];
    if (self) {
        _style = style;
        _cancelBlaok = block;
    }
    return self;
}

-(instancetype)initWithCancelBlock:(CancelHandler)block{
    self = [super init];
    if (self) {
        _cancelBlaok = block;
    }
    return self;
}

-(instancetype)initWithStyle:(NSInteger)style withCancelBlock:(CancelHandler)block DoneBlock:(DoneHandler)doneblock{
    self = [super init];
    if (self) {
        _style = style;
        _cancelBlaok = block;
        _doneBlaok = doneblock;
    }
    return self;
}

//弹出
- (void)show
{
    [self showInView:[UIApplication sharedApplication].keyWindow];
}

//添加弹出移除的动画效果
- (void)showInView:(UIView *)view
{
    // 浮现
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = self.center;
        point.y -= 250;
        self.center = point;
    } completion:^(BOOL finished) {
        
    }];
    [view addSubview:self];
}

-(void)quit
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        CGPoint point = self.center;
        point.y += 250;
        self.center = point;
    } completion:^(BOOL finished) {
        _cancelBlaok();
        [self removeFromSuperview];
    }];
}

-(void)done{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        CGPoint point = self.center;
        point.y += 250;
        self.center = point;
    } completion:^(BOOL finished) {
        if (!self.result) {
            self.result = self.array[0];
        }
        _doneBlaok(self.result,self.resultRow);
        [self removeFromSuperview];
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.array count];
}

#pragma mark - 代理
// 返回第component列第row行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.array[row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor clearColor];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor clearColor];
    if (self.style == 0) {
        ZMBJPickerViewCellType *cell = [[ZMBJPickerViewCellType alloc] myInit];
        cell.titleLabel.text = self.array[row];
        return cell;
    }else if (self.style == 1){
        ZMBJPickerViewCellType_1 *cell = [[ZMBJPickerViewCellType_1 alloc] myInit];
        return cell;
    }else{
        return [[UIView alloc] init];
    }
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.result = self.array[row];
    self.resultRow = row;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
