//
//  ViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/11/26.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ViewController.h"
#import "ZMLoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZMLog(@"jjjfjksdf");
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMLoginViewController *loginView = [styoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:loginView animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMLoginReg" bundle:nil];
    ZMLoginViewController *loginView = [styoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:loginView animated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
