//
//  ZMMyTripViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/17.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMMyTripViewController.h"
#import "ZMHomeMenuViewController.h"
#import "ZMMyTripCell_Type_1.h"
#import "ZMMyTripCell_Type_2.h"
#import "ZMMyTripCell_Type_3.h"

@interface ZMMyTripViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) ZMHomeMenuViewController *menu;

@end

@implementation ZMMyTripViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor navigationbarColor];
    // Do any additional setup after loading the view.
}

- (IBAction)navRigthAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            ZMMyTripCell_Type_1 *cell = [ZMMyTripCell_Type_1 cellWithTableView:tableView];
            return cell;
        }
        break;
            
        case 1:{
            ZMMyTripCell_Type_2 *cell = [ZMMyTripCell_Type_2 cellWithTableView:tableView];
            return cell;
        }
         break;
            
        case 2:{
            ZMMyTripCell_Type_3 *cell = [ZMMyTripCell_Type_3 cellWithTableView:tableView];
            return cell;
        }
            break;
            
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            return tableView.frame.size.width * (200.f/375.f);
        }
            break;
            
        case 1:{
            return tableView.frame.size.width * (135/375.f);
        }
            break;
            
        case 2:{
            return tableView.frame.size.width * (135/375.f);
        }
            break;
            
        default:
            return 10;
            break;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
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
