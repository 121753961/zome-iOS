//
//  ZMPayMentListController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/16.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMPayMentListController.h"
#import "ZMHomeMenuViewController.h"
#import "ZMPaymentListCell.h"
#import "ZMPaymentListHeaderCell.h"
#import "ZMPaymentDetailsController.h"
#import "ZMAddPaymentController.h"
#import "ZMPaymentListPayCell.h"
#import "ZMBJPickerView.h"
#import "ZMStrpePayTool.h"
#import "ZMPaymentCardModel.h"

@interface ZMPayMentListController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) ZMHomeMenuViewController *menu;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) ZMPaymentCardModel *defaultCard;


@end

@implementation ZMPayMentListController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ZMProgressHUD show];
    
    self.view.backgroundColor = [UIColor navigationbarColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.listArray = [NSMutableArray array];
}

-(void)loadData{
    BJWeakSelf
    [ZMStrpePayTool getStripeCardListSuccess:^(NSArray *array) {
        [ZMProgressHUD dismiss];
        [weakSelf.listArray removeAllObjects];
        for (ZMPaymentCardModel *card in array) {
            if (card.isDefaultCard) {
                weakSelf.defaultCard = card;
            }else{
                [weakSelf.listArray addObject:card];
            }
        }
        [weakSelf.myTableView reloadData];
    } failure:^(NSError *error) {
        [ZMProgressHUD dismiss];
    }];
}

- (IBAction)openEvent:(id)sender {
    if (!self.menu) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"ZMHome" bundle:[NSBundle mainBundle]];
        self.menu = [story instantiateViewControllerWithIdentifier:@"HomeMenuVC"];
        
        CGRect frame = self.menu.view.frame;
        frame.origin.x = - CGRectGetWidth(self.view.frame);
        self.menu.view.frame = frame;
        self.menu.navigationController = self.navigationController;
        [[UIApplication sharedApplication].keyWindow addSubview:self.menu.view];
    }
    [self.menu showFromLeft];
}

- (IBAction)closeBtnAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)addPaymentAction:(id)sender {
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMPayment" bundle:nil];
    ZMAddPaymentController *addPaymentVC = [styoryBoard instantiateViewControllerWithIdentifier:@"AddPayment"];
    [self.navigationController pushViewController:addPaymentVC animated:YES];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.defaultCard ? 1 : 0;
    }else{
        return self.listArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        ZMPaymentListCell *cell = [ZMPaymentListCell cellWithTableView:tableView];
        ZMPaymentCardModel *card = [self.listArray objectAtIndex:indexPath.row];
        cell.cardModel = card;
        return cell;
    }else{
        ZMPaymentListCell *cell = [ZMPaymentListCell cellWithTableView:tableView];
        cell.cardModel = self.defaultCard;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZMPaymentListHeaderCell *cell = [ZMPaymentListHeaderCell cellWithTableView:tableView];
    if (section == 0) {
        cell.titleLabel.text = @"Default Payment Method";
    }else{
        cell.titleLabel.text = @"Payment Methods";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self showSelectDefaultPayment];
    }else{
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMPayment" bundle:nil];
        ZMPaymentDetailsController *paymentDetailsVC = [styoryBoard instantiateViewControllerWithIdentifier:@"PaymentDetails"];
        ZMPaymentCardModel *cardModel = [self.listArray objectAtIndex:indexPath.row];
        paymentDetailsVC.cardModel = cardModel;
        [self.navigationController pushViewController:paymentDetailsVC animated:YES];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZMLog(@"%ld----Del",indexPath.row);
        ZMPaymentCardModel *cardModel = [self.listArray objectAtIndex:indexPath.row];
        
        if (cardModel) {
            [self delUserCard:cardModel.Id];
        }
    }
}

-(void)showSelectDefaultPayment{
    if (self.listArray.count == 0) {
        return;
    }
    BJWeakSelf
    ZMBJPickerView *picker = [[ZMBJPickerView alloc] initWithStyle:0 withCancelBlock:^{
        
    } DoneBlock:^(NSString *result, NSInteger row) {
        ZMLog(@"%@",result);
        ZMPaymentCardModel *cardModel = [weakSelf.listArray objectAtIndex:row];
        if (cardModel) {
            [weakSelf setUserDefaultCard:cardModel.Id];
        }
    }];
    NSMutableArray *cardArr = [NSMutableArray array];
    for (ZMPaymentCardModel *card in self.listArray) {
        NSString *cardName = [NSString stringWithFormat:@"%@ - %@",card.brand,card.lastFour];
        [cardArr addObject:cardName];
    }
    picker.array = cardArr;
    picker.title = @"";
    [picker show];
}

-(void)setUserDefaultCard:(NSString *)cardId{
    [ZMProgressHUD show];
    BJWeakSelf
    [ZMStrpePayTool setStripeDefaultCard:cardId Success:^(ZMCommonResult *resultModel) {
        [ZMProgressHUD dismiss];
        if (resultModel.status == 0) {
            [ZMProgressHUD showSuccessWithStatus:resultModel.message];
            [weakSelf loadData];
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD dismiss];
    }];
}

-(void)delUserCard:(NSString *)cardId{
    [ZMProgressHUD show];
    BJWeakSelf
    [ZMStrpePayTool setStripeDelCard:cardId Success:^(ZMCommonResult *resultModel) {
        [ZMProgressHUD dismiss];
        if (resultModel.status == 0) {
            [ZMProgressHUD showSuccessWithStatus:resultModel.message];
            [weakSelf loadData];
        }else{
            [ZMProgressHUD showErrorWithStatus:resultModel.message];
        }
    } failure:^(NSError *error) {
        [ZMProgressHUD dismiss];
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
