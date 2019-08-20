//
//  ZMEditCardController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/16.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMEditCardController.h"
#import <Stripe/Stripe.h>
#import "ZMPushTool.h"
#import "ZMStrpePayTool.h"


@interface ZMEditCardController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLine;

@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLine;

@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property (weak, nonatomic) IBOutlet UILabel *cvvLine;

@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *zipCodeLine;

@property (weak, nonatomic) IBOutlet UILabel *viewTitle;


@end

@implementation ZMEditCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor navigationbarColor];
    
    self.viewTitle.text = self.titleStr;
    
    // 如果产品需要当键盘弹起时，点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    [self setUI];
    
    
//    STPCardParams *cardParams = [[STPCardParams alloc]init];
//    cardParams.number = @"4242424242424242";
//    cardParams.expMonth = 12;
//    cardParams.expYear = 18;
//    cardParams.cvc = @"424";
//    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken * _Nullable token, NSError * _Nullable error) {
//        if (error) {
//            [SVProgressHUD dismiss];
//            
//            NSLog(@"%@",[error description]);
//        } else {
//            NSLog(@"添加成功 tokenId:%@ cardId:%@",token.tokenId,token.card.cardId
//                  );
//        }
//    }];
    
    
}

- (IBAction)saveBtnAction:(id)sender {
    if (self.cardModel) {
        // 编辑
        [self postEditCard];
    }else{
        // Stripe 添加卡
        [self STPCardCreateCard];
    }
}

-(void)STPCardCreateCard{
    if (IsStrEmpty(self.cardNumberTextField.text)) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"CardNumberCan'tBeEmpty", nil)];
        return;
    }
    
    if (IsStrEmpty(self.dateTextField.text)) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"DateCan'tBeEmpty", nil)];
        return;
    }
    
    if (IsStrEmpty(self.cvvTextField.text)) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"CVVFormatErrorr", nil)];
        return;
    }
    
    if (self.cvvTextField.text.length > 3) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"CVVFormatErrorr", nil)];
        return;
    }
    
    if (IsStrEmpty(self.zipCodeTextField.text)) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"ZipCodeCan'tBeEmpty", nil)];
        return;
    }
    
    STPCardParams *cardParams = [[STPCardParams alloc]init];
    cardParams.number = self.cardNumberTextField.text;
    NSString *dateStr = self.dateTextField.text;
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"/"];
    if (dateArray.count == 2) {
        cardParams.expMonth = [[dateArray objectAtIndex:0] integerValue];
        cardParams.expYear = [[dateArray objectAtIndex:1] integerValue];
    }else{
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"DateFormatErrorr", nil)];
        return;
    }
    
    if (cardParams.expMonth > 12) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"DateFormatErrorr", nil)];
        return;
    }
    
    cardParams.cvc = self.cvvTextField.text;
    cardParams.address.postalCode = self.zipCodeTextField.text;
    [ZMProgressHUD show];
    BJWeakSelf
    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken * _Nullable token, NSError * _Nullable error) {
        if (error) {
            [ZMProgressHUD dismiss];
            NSLog(@"%@",[error description]);
            [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"AddFailure", nil)];
        } else {
            NSLog(@"添加成功 token:%@",token);
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSString *userid = [[ZMAppInfomationSingleton sharedInstance] getUserId];
            params[@"userId"] = userid;
            params[@"token"] = token.tokenId;
            [weakSelf postStripeCardAdd:params];
        }
    }];
}

-(void)postStripeCardAdd:(NSDictionary *)params{
    [ZMHttpTool postWithPath:kApi_stripeCardAdd params:params success:^(NSDictionary *result) {
        ZMLog(@"%@",result);
        ZMCommonResult *resultModel = [ZMCommonResult mj_objectWithKeyValues:result];
        if(resultModel.status == 0){
            [ZMProgressHUD dismiss];
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
            [ZMPushTool pushPayMentListViewWithTarget:self.navigationController];
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        ZMLog(@"%@",error);
    }];
}

-(void)postEditCard{
    if (IsStrEmpty(self.cardNumberTextField.text)) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"CardNumberCan'tBeEmpty", nil)];
        return;
    }
    
    if (IsStrEmpty(self.dateTextField.text)) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"DateCan'tBeEmpty", nil)];
        return;
    }
    
    if (IsStrEmpty(self.cvvTextField.text)) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"CVVFormatErrorr", nil)];
        return;
    }
    
    if (self.cvvTextField.text.length > 3) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"CVVFormatErrorr", nil)];
        return;
    }
    
    if (IsStrEmpty(self.zipCodeTextField.text)) {
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"ZipCodeCan'tBeEmpty", nil)];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cardId"] = self.cardModel.Id;
    NSString *dateStr = self.dateTextField.text;
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"/"];
    if (dateArray.count == 2) {
        params[@"expMonth"] = [dateArray objectAtIndex:0];
        params[@"expYear"] = [dateArray objectAtIndex:1];
    }else{
        [ZMProgressHUD showErrorWithStatus:NSLocalizedString(@"DateFormatErrorr", nil)];
        return;
    }
    params[@"userId"] = [[ZMAppInfomationSingleton sharedInstance] getUserId];
    params[@"zip"] = self.zipCodeTextField.text;
    ZMLog(@"%@",params);
    [ZMStrpePayTool upDateCardWithParams:params Success:^(BOOL isSuccess) {
        [ZMPushTool pushPayMentListViewWithTarget:self.navigationController];
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger tag = textField.tag;
    switch (tag) {
        case 1:{
            if ([string isEqualToString:@""]) {
                return YES;
            }
            return self.cardNumberTextField.text.length < 16 ? YES : NO;
        }
        case 2:{
            if ([string isEqualToString:@""]) {
                return YES;
            }
            if (self.dateTextField.text.length == 2 && ![string isEqualToString:@""] && [self.dateTextField.text rangeOfString:@"/"].location == NSNotFound ) {
                NSString *dateStr = self.dateTextField.text;
                self.dateTextField.text = [NSString stringWithFormat:@"%@/",dateStr];
            }
            return self.dateTextField.text.length < 5 ? YES : NO;
        }
            break;
        case 3:{
            if ([string isEqualToString:@""]) {
                return YES;
            }
            BOOL is = self.cvvTextField.text.length < 3 ? YES : NO;
            return is;
        }
            break;
            
        default:
            return YES;
            break;
    }
}

-(void)lineColor:(UITextField *)textField color:(UIColor *)color{
    NSInteger tag = textField.tag;
    switch (tag) {
        case 1:
            self.cardNumberLine.backgroundColor = color;
            break;
        case 2:
            self.dateLine.backgroundColor = color;
            break;
        case 3:
            self.cvvLine.backgroundColor = color;
            break;
        case 4:
            self.zipCodeLine.backgroundColor = color;
            break;
            
        default:
            break;
    }
}



-(void)removeResignFirstResponder{
    [self.cardNumberTextField resignFirstResponder];
    [self.dateTextField resignFirstResponder];
    [self.cvvTextField resignFirstResponder];
    [self.zipCodeTextField resignFirstResponder];
}

-(void)setUI{
    if (self.cardModel) {
        _cardNumberTextField.text = [NSString stringWithFormat:@"**** **** **** %@",self.cardModel.lastFour];
        _cardNumberTextField.enabled = NO;
        NSString *dateStr = [NSString stringWithFormat:@"%@/%@",self.cardModel.expMonth,self.cardModel.expYear];
        _dateTextField.text = dateStr;
        _zipCodeTextField.text = self.cardModel.zip;
    }
    _cardNumberTextField.delegate = self;
    
    _dateTextField.delegate = self;
    
    _cvvTextField.delegate = self;
    
    _zipCodeTextField.delegate = self;
    
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
