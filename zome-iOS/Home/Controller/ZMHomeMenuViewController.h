//
//  ZMHomeMenuViewController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/14.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMHomeMenuViewController : UIViewController

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navigationController;

- (void)showFromLeft;

@end
