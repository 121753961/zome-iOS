//
//  ZMBJPickerView.h
//  zome-iOS
//
//  Created by CFW on 2017/12/18.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelHandler)();

typedef void(^DoneHandler)(NSString *result, NSInteger row);

@interface ZMBJPickerView : UIView

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *title;

//快速创建
+(instancetype)pickerView;

-(instancetype)initWithCancelBlock:(CancelHandler)block;

-(instancetype)initWithStyle:(NSInteger)style withCancelBlock:(CancelHandler)block;

-(instancetype)initWithStyle:(NSInteger)style withCancelBlock:(CancelHandler)block DoneBlock:(DoneHandler)doneblock;

//弹出
-(void)show;


@end
