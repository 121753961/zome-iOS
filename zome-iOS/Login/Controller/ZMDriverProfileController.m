//
//  ZMDriverProfileController.m
//  zome-iOS
//
//  Created by CFW on 2017/11/28.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMDriverProfileController.h"
#import "ZMSignUpSSNViewController.h"
#import "ZMDriverProfileParams.h"
#import "ZJUsefulPickerView.h"
#import "NSDate+ZM.h"
#import "ZMBJPickerView.h"
#import "ZMCarTool.h"


@interface ZMDriverProfileController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLine;

@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLine;

@property (weak, nonatomic) IBOutlet UITextField *middleNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *middleNameLine;

@property (weak, nonatomic) IBOutlet UITextField *birthTextField;
@property (weak, nonatomic) IBOutlet UILabel *birthLine;

@property (weak, nonatomic) IBOutlet UITextField *driverTextField;
@property (weak, nonatomic) IBOutlet UILabel *driverLine;

@property (weak, nonatomic) IBOutlet UITextField *licenseTextField;
@property (weak, nonatomic) IBOutlet UILabel *licenseLine;

@property (nonatomic, strong) ZMDriverProfileParams *driverProfileParams;

@property (nonatomic, strong) NSArray *stateArray;




@end

@implementation ZMDriverProfileController

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
    self.driverProfileParams = [[ZMDriverProfileParams alloc] init];
    
    // 如果产品需要当键盘弹起时，点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self setupUI];
    
    [self getJsonfile];
    
    [self getDriverProfile];
}

- (IBAction)selectDateAction:(id)sender {
    [ZJUsefulPickerView showDatePickerWithToolBarText:@"" withStyle:nil withCancelHandler:^{
        NSLog(@"quxiaole -----");
        
    } withDoneHandler:^(NSDate *selectedDate) {
        NSLog(@"%@---", selectedDate);
        NSString *dateStr = [NSDate stringWithYMD:selectedDate];
        self.birthTextField.text = dateStr;
//        self.birthTextField.text = [selectedDate stringWithISOFormat];
    }];
}

- (IBAction)selectlicenseAction:(id)sender {
    BJWeakSelf
    ZMBJPickerView *pickerView = [[ZMBJPickerView alloc] initWithStyle:0 withCancelBlock:^{
        
    } DoneBlock:^(NSString *result, NSInteger row) {
        weakSelf.licenseTextField.text = result;
    }];
    pickerView.array = self.stateArray;
    [pickerView show];
}


- (IBAction)backAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)closeAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)buttomBtnAction:(id)sender {
    self.driverProfileParams.lastName = self.lastNameTextField.text;
    self.driverProfileParams.firstName = self.firstNameTextField.text;
    self.driverProfileParams.middleName = self.middleNameTextField.text;
    self.driverProfileParams.dateOfBirth = self.birthTextField.text;
    self.driverProfileParams.driverLicense = self.driverTextField.text;
    self.driverProfileParams.licenseState = self.licenseTextField.text;
    
    if([self verificationParam:self.driverProfileParams]){
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
        ZMSignUpSSNViewController *signSSNVC = [styoryBoard instantiateViewControllerWithIdentifier:@"SignUpSSNVC"];
        signSSNVC.driverProfileParams = self.driverProfileParams;
        [self.navigationController pushViewController:signSSNVC animated:YES];
    }
}


-(BOOL)verificationParam:(ZMDriverProfileParams *)paramModel{
    if(IsStrEmpty(paramModel.firstName)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"FirstNameCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.lastName)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"LastNameCan'tBeEmpty", nil)];
        return NO;
    }
    
//    if(IsStrEmpty(paramModel.middleName)){
//        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"MiddleNameCan'tBeEmpty", nil)];
//        return NO;
//    }
    
    if(IsStrEmpty(paramModel.dateOfBirth)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"DateOfBirthCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.driverLicense)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"DriverLicenseCan'tBeEmpty", nil)];
        return NO;
    }
    
    if(IsStrEmpty(paramModel.licenseState)){
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"LicenseStateCan'tBeEmpty", nil)];
        return NO;
    }
    return YES;
}

#pragma mark  textFieldDelegate
//返回一个BOOL值，指明是否允许在按下回车键时结束编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //如果允许要调用resignFirstResponder 方法，这回导致结束编辑，而键盘会被收起
    [self removeResignFirstResponder];
    return YES;
}
/**
 * @brief  文本输入框已经开始编辑代理方法
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self lineColor:textField color:[UIColor inputLineSelectdColor]];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self lineColor:textField color:[UIColor inputLineColor]];
}

-(void)lineColor:(UITextField *)textField color:(UIColor *)color{
    NSInteger tag = textField.tag;
    switch (tag) {
        case 1:
            self.firstNameLine.backgroundColor = color;
            break;
        case 2:
            self.lastNameLine.backgroundColor = color;
            break;
        case 3:
            self.middleNameLine.backgroundColor = color;
            break;
        case 4:
            self.birthLine.backgroundColor = color;
            break;
        case 5:
            self.driverLine.backgroundColor = color;
            break;
        case 6:
            self.licenseLine.backgroundColor = color;
            break;
            
        default:
            break;
    }
}



-(void)removeResignFirstResponder{
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    [self.middleNameTextField resignFirstResponder];
    [self.birthTextField resignFirstResponder];
    [self.driverTextField resignFirstResponder];
    [self.licenseTextField resignFirstResponder];
}

-(void)setupUI{
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.middleNameTextField.delegate = self;
    self.birthTextField.delegate = self;
    self.driverTextField.delegate = self;
    self.licenseTextField.delegate = self;
    
    if (self.driverProfile) {
        self.firstNameTextField.text = self.driverProfile.firstName;
        self.lastNameTextField.text = self.driverProfile.lastName;
        self.middleNameTextField.text = self.driverProfile.middleName;
        self.driverTextField.text = self.driverProfile.driverLicense;
        self.licenseTextField.text = self.driverProfile.licenseState;
        self.birthTextField.text = self.driverProfile.dateOfBirth;
        self.driverProfileParams.ssn = self.self.driverProfile.ssn;
    }
}


-(void)getJsonfile{
    // 读取Json
    NSString *path = [[NSBundle mainBundle] pathForResource:@"states_hash" ofType:@"json"];

    // Json数据
    NSData *fileData = [NSData dataWithContentsOfFile:path];

    // JsonObject
    NSError *error;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:fileData
                                                    options:NSJSONReadingAllowFragments
                                                        error:&error];
    NSArray *array = [jsonObject allKeys];
    self.stateArray = array;
    
}

-(void)getDriverProfile{
    BJWeakSelf
    [ZMCarTool getDriverProfileSuccess:^(ZMCommonResult *result) {
        if ([result.data isKindOfClass:[NSDictionary class]]) {
            weakSelf.driverProfile = [ZMDriveProfileModel mj_objectWithKeyValues:result.data];
            [self setupUI];
        }
    } failure:^(NSError *error) {
        
    }];
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
