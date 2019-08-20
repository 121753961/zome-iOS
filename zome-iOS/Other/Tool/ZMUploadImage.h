//
//  ZMUploadImage.h
//  zome-iOS
//
//  Created by CFW on 2017/11/29.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
@class ZMUploadParam;


#define ZMUPLOAD_IMAGE [ZMUploadImage shareUploadImage]
//写了一个代理方法
@protocol ZMUploadImageDelegate <NSObject>
@optional
-(void)uploadImageToServerWithImage:(UIImage *)image;

-(void)uploadImageToServerWithUploadParam:(ZMUploadParam *)imageParam;

@end

@interface ZMUploadImage : NSObject<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, weak) UIViewController *fatherViewController;
@property (nonatomic, weak) id <ZMUploadImageDelegate> uploadImageDelegate;

//单例方法
+(ZMUploadImage *)shareUploadImage;

//弹出选项的方法
- (void)showActionSheetInFatherViewController:(UIViewController *)fatherVC
                                     delegate:(id<ZMUploadImageDelegate>)aDelegate;


@end


