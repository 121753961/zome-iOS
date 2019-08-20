//
//  ZMVehicleInfoViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/11/28.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMVehicleInfoViewController.h"
#import "ZMBJPickerView.h"
#import "ZMCarTool.h"
#import "ZMCarBrandModel.h"
#import "ZMCartModelModel.h"
#import "ZMCarStyleYearColorModel.h"
#import "ZMDriverCarinfoParams.h"

@interface ZMVehicleInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *makeTextField;
@property (weak, nonatomic) IBOutlet UITextField *bodyStyleTextField;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *plateNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;

// 车的品牌
@property (nonatomic, strong) NSArray *carBrandList;
@property (nonatomic, strong) NSArray *carBrandListStr;
@property (nonatomic, copy) NSString *carBrandId;

// 根据品牌ID查询所有分类信息
@property (nonatomic, strong) NSArray *carModelList;
@property (nonatomic, strong) NSArray *carModelListStr;
@property (nonatomic, copy) NSString *carModelId;

// 根据分类ID查询型号,生产年份和颜色信息
@property (nonatomic, strong) NSArray *carStyleList;
@property (nonatomic, strong) NSArray *carStyleListStr;

// 年份
@property (nonatomic, strong) NSArray *carYearList;

// 颜色
@property (nonatomic, strong) NSArray *carColorList;

@property (nonatomic, strong) ZMDriverCarinfoParams *carInfoParams;

@end

@implementation ZMVehicleInfoViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果产品需要当键盘弹起时，点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.carInfoParams = [[ZMDriverCarinfoParams alloc] init];
    
    [self getCarBrandList];
    
    if (self.driverCarInfo) {
        [self setupUI];
    }
   
    //    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    // Do any additional setup after loading the view.
}
- (IBAction)closeBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)backBtnAction:(id)sender {
    [self backAction:sender];
}

-(void)backAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setupUI{
    self.makeTextField.text = self.driverCarInfo.brand;
    self.carInfoParams.brand = self.driverCarInfo.brand;
    
    self.modelTextField.text = self.driverCarInfo.vehicleModel;
    self.carInfoParams.vehicleModel = self.driverCarInfo.vehicleModel;
    
    self.bodyStyleTextField.text = self.driverCarInfo.bodyStyle;
    self.carInfoParams.bodyStyle = self.driverCarInfo.bodyStyle;
    
    self.yearTextField.text = self.driverCarInfo.yearOfVehicle;
    self.carInfoParams.yearOfVehicle = self.driverCarInfo.yearOfVehicle;
    
    self.plateNumberTextField.text = self.driverCarInfo.plateNumber;
    self.carInfoParams.plateNumber = self.driverCarInfo.plateNumber;
    
    self.colorTextField.text = self.driverCarInfo.color;
    self.carInfoParams.color = self.driverCarInfo.color;
    
}


-(void)getCarBrandList{
    BJWeakSelf
    [ZMCarTool getCarBrandListSuccess:^(NSArray *array) {
        weakSelf.carBrandList = array;
        NSMutableArray *arr = [NSMutableArray array];
        for (ZMCarBrandModel *model in array) {
            [arr addObject:model.name];
        }
        weakSelf.carBrandListStr = arr;
        ZMCarBrandModel *deCar = [array objectAtIndex:0];
        weakSelf.carBrandId = deCar.Id;
    } failure:^(NSError *error) {
        
    }];
}


-(void)getCarModelListWithBrand:(NSString *)brandId{
    BJWeakSelf
    [ZMCarTool getCarModelListWithBrand:brandId Success:^(NSArray *array) {
        weakSelf.carModelList = array;
        NSMutableArray *arr = [NSMutableArray array];
        for (ZMCartModelModel *model in array) {
            [arr addObject:model.name];
        }
        weakSelf.carModelListStr = arr;
        ZMCartModelModel *deCarModel = [array objectAtIndex:0];
        weakSelf.carModelId = deCarModel.Id;
    } failure:^(NSError *error) {
        
    }];
}

-(void)getCarStyleYearColorWithModel:(NSString *)modelid{
    BJWeakSelf
    [ZMCarTool getCarStyleYearColorModel:modelid Success:^(NSArray *array) {
        weakSelf.carStyleList = array;
        NSMutableArray *arr = [NSMutableArray array];
        for (ZMCarStyleYearColorModel *model in array) {
            [arr addObject:model.name];
        }
        weakSelf.carStyleListStr = arr;
    } failure:^(NSError *error) {
        
    }];
}





- (IBAction)verifyBtnAction:(id)sender {
    self.carInfoParams.isDefault = @"Y";
    self.carInfoParams.yearOfVehicle = self.yearTextField.text;
    self.carInfoParams.plateNumber = self.plateNumberTextField.text;
    [ZMProgressHUD show];
    if([self verificationParam:self.carInfoParams]){
        NSDictionary *paramsDic = [self.carInfoParams mj_keyValues];
        [ZMCarTool postDriverCarInfo:paramsDic success:^(ZMCommonResult *result) {
            [ZMProgressHUD dismiss];
            if (result.status == 0) {
                [ZMProgressHUD showSuccessWithStatus:result.message];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            [ZMProgressHUD dismiss];
        }];
    }
    
}




#pragma  mark  Make
- (IBAction)selectMakeAction:(id)sender {
    if (self.carBrandListStr.count == 0) {
        return;
    }
    BJWeakSelf
    ZMBJPickerView *picker = [[ZMBJPickerView alloc] initWithStyle:0 withCancelBlock:^{
        
    } DoneBlock:^(NSString *result, NSInteger row) {
        weakSelf.carInfoParams.brand = result;
        weakSelf.makeTextField.text = result;
        ZMCarBrandModel *car = [weakSelf.carBrandList objectAtIndex:row];
        weakSelf.carBrandId = car.Id;
        [weakSelf getCarModelListWithBrand:car.Id];
        ZMLog(@"%@",weakSelf.carInfoParams);
    }];
    picker.array = self.carBrandListStr;
    picker.title = @"";
    [picker show];
}


#pragma  mark  Model
- (IBAction)selectModelAction:(id)sender {
    if (self.carModelListStr.count == 0) {
        return;
    }
    
    BJWeakSelf
    ZMBJPickerView *picker = [[ZMBJPickerView alloc] initWithStyle:0 withCancelBlock:^{
        
    } DoneBlock:^(NSString *result, NSInteger row) {
        weakSelf.carInfoParams.vehicleModel = result;
        weakSelf.modelTextField.text = result;
        ZMCartModelModel *carModel = [weakSelf.carModelList objectAtIndex:row];
        weakSelf.carModelId = carModel.Id;
        [weakSelf getCarStyleYearColorWithModel:carModel.Id];
        ZMLog(@"%@",weakSelf.carInfoParams);
    }];
    picker.array = self.carModelListStr;
    picker.title = @"";
    [picker show];
}

#pragma  mark  BodyStyle
- (IBAction)selectBodyStyle:(id)sender {
    if (self.carStyleListStr.count == 0) {
        return;
    }
    
    BJWeakSelf
    ZMBJPickerView *picker = [[ZMBJPickerView alloc] initWithStyle:0 withCancelBlock:^{
        
    } DoneBlock:^(NSString *result, NSInteger row) {
        weakSelf.carInfoParams.bodyStyle = result;
        weakSelf.bodyStyleTextField.text = result;
        
        ZMCarStyleYearColorModel *carStyle = [weakSelf.carStyleList objectAtIndex:row];
        weakSelf.carColorList = carStyle.colorArray;
        ZMLog(@"%@",weakSelf.carInfoParams);
    }];
    picker.array = self.carStyleListStr;
    picker.title = @"";
    [picker show];
}



- (IBAction)selectColorAction:(id)sender {
//    ZMBJPickerView *picker = [[ZMBJPickerView alloc] initWithStyle:1 withCancelBlock:^{
//        ZMLog(@"------ CancelBlock ----");
//    } DoneBlock:^(NSString *result, NSInteger row) {
//
//    }];
//    picker.array = @[@"iPhone4",@"iPhone4S",@"iPhone5",@"iPhone5S",@"iPhone5C",@"iPhone6",@"iPhone6Plus",@"iPhone6S",@"iPhone6SPlus"];
//    picker.title = @"pick number";
//    [picker show];
//
//    if (self.carStyleListStr.count == 0) {
//        return;
//    }
//
    BJWeakSelf
    ZMBJPickerView *picker = [[ZMBJPickerView alloc] initWithStyle:0 withCancelBlock:^{
        
    } DoneBlock:^(NSString *result, NSInteger row) {
        weakSelf.colorTextField.text = result;
        weakSelf.carInfoParams.color = result;
    }];
    picker.array = self.carColorList;
    picker.title = @"";
    [picker show];
}


-(BOOL)verificationParam:(ZMDriverCarinfoParams *)paramModel{
    if(IsStrEmpty(paramModel.brand)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"BrandCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.vehicleModel)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"VehicleModelCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.bodyStyle)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"BodyStyleCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.yearOfVehicle)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"YearOfVehicleCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.plateNumber)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"PlateNumberCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.color)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"ColorCan'tBeEmpty", nil)];
        return NO;
    }
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
