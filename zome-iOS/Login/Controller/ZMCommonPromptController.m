//
//  ZMCommonPromptController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/3.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMCommonPromptController.h"
#import "ZMPushTool.h"

@interface ZMCommonPromptController ()
@property (weak, nonatomic) IBOutlet UILabel *decLabel;

@end

@implementation ZMCommonPromptController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    NSString *labelStr = self.decLabel.text;
    NSString *desStr = [NSString stringWithFormat:@"%@ %@",self.email,labelStr];
    self.decLabel.text = desStr;

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [ZMPushTool pushCodeLoginViewWithTarget:self.navigationController];
    });

}

-(void)backAction:(UIButton *)btn{
    [ZMPushTool pushCodeLoginViewWithTarget:self.navigationController];
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
