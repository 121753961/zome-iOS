//
//  ZMNavigationController.m
//  zome-iOS
//
//  Created by CFW on 2017/11/28.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMNavigationController.h"

@interface ZMNavigationController ()

@end

@implementation ZMNavigationController

/**
 * 当第一次使用这个类的时候会调用一次
 */
+(void)initialize{
    //     当导航栏用在NavigationController中, appearance设置才会生效
    UINavigationBar *bar = [UINavigationBar appearance];
    UIImage *bgImg = [self createImageWithColor:[UIColor navigationbarColor] size:CGSizeMake(1, 1)];
    [bar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
//    [bar setBackgroundColor:[UIColor redColor]];
//    [bar setBarTintColor:[UIColor whiteColor]];
//    bar.tintColor = [UIColor whiteColor]
    [bar setShadowImage:[[UIImage alloc] init]];
    [bar setBarStyle:UIBarStyleDefault];
    [bar setTranslucent:NO];
    
    
    // 设置item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16.0f];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
    
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
