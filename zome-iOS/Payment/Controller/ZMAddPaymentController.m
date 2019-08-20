//
//  ZMAddPaymentController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/17.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMAddPaymentController.h"
#import "ZMEditCardController.h"

#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>
#import <Stripe/Stripe.h>

@interface ZMAddPaymentController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ZMAddPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor navigationbarColor];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)payPalAction:(id)sender {
    ZMLog(@"payPalAction");
}

- (IBAction)debitCardAction:(id)sender {
     ZMLog(@"debitCardAction");
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMPayment" bundle:nil];
    ZMEditCardController *editCardVC = [styoryBoard instantiateViewControllerWithIdentifier:@"EditCard"];
    editCardVC.titleStr = @"Add Card";
    [self.navigationController pushViewController:editCardVC animated:YES];
}

- (IBAction)applePayAction:(id)sender {
    ZMLog(@"applePayAction");
    
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        ZMLog(@"支持支付");
        // 我们后面创建出来的支付页面就是根据这个request
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        // 商品目录
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"麻辣烫" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        // @"海鲜大餐"
        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"肯德基" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        PKPaymentSummaryItem *widget3 = [PKPaymentSummaryItem summaryItemWithLabel:@"海鲜大餐" amount:[NSDecimalNumber decimalNumberWithString:@"0.02"]];
        PKPaymentSummaryItem *widget4 = [PKPaymentSummaryItem summaryItemWithLabel:@"coderqi" amount:[NSDecimalNumber decimalNumberWithString:@"0.03"] type:PKPaymentSummaryItemTypeFinal];
        request.paymentSummaryItems = @[widget1, widget2, widget3, widget4];
        // request.countryCode = @”CN”;
        // request.currencyCode = @”CNY”;//人民币
        request.countryCode = @"US";
        request.currencyCode = @"USD";
        if (@available(iOS 9.2, *)) {
            request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        } else {
            // Fallback on earlier versions
        }
        // 这里填的是就是我们创建的merchat IDs
        request.merchantIdentifier = ApplePayMerchantIdentifier;
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        //增加邮箱及地址信息
        request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
        // 根据request去创建支付页面
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        // 设置代理
        paymentPane.delegate = self;
        if (!paymentPane) {
            NSLog(@"出问题了");
        } else {
            // 模态推出页面
            [self presentViewController:paymentPane animated:YES completion:nil];
        }
        
    } else {
            NSLog(@"该设备不支持支付");
    }
}

#pragma mark —-支付状态
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus status))completion{
    //这是老版，已过时*
     NSError *error;
     ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress ,kABPersonAddressProperty);
    NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
     //这里模拟取出地址里的每一个信息。
     NSLog(@"%@",addressDictionary[@"State"]);
     NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];
     // 这里需要将Token和地址信息发送到自己的服务器上，
     // 进行订单处理，处理之后，根据自己的服务器返回的结果调用completion()代码块，
     // 根据传进去的参数界面的显示结果会不同 PKPaymentAuthorizationStatus status;
     // From your server completion(status);
     // 这是新版 //拿到token， PKPaymentToken *token = payment.token;*
     // 拿到订单地址
     NSString *city = payment.billingContact.postalAddress.city;
     NSLog(@"city:%@",city);
     // 在这里将token和地址发送到自己的服务器，
     // 有自己的服务器与银行和商家进行接口调用和支付将结果返回到这里
     // 我们根据结果生成对应的状态对象，根据状态对象显示不同的支付结构
     // 状态对象
     PKPaymentAuthorizationStatus status = PKPaymentAuthorizationStatusFailure; completion(status);
     }
#pragma mark —-支付完成
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    // 支付完成后让支付页面消失
    [controller dismissViewControllerAnimated:YES completion:nil];
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
