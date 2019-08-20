//
//  ZMUploadImage.m
//  zome-iOS
//
//  Created by CFW on 2017/11/29.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMUploadImage.h"
#import "ZMUploadParam.h"
#import "NSDate+ZM.h"



static ZMUploadImage *zmUploadImage = nil;

@implementation ZMUploadImage

+ (ZMUploadImage *)shareUploadImage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zmUploadImage = [[ZMUploadImage alloc] init];
    });
    return zmUploadImage;
}

-(void)showActionSheetInFatherViewController:(UIViewController *)fatherVC delegate:(id<ZMUploadImageDelegate>)aDelegate{
    zmUploadImage.uploadImageDelegate = aDelegate;
    _fatherViewController = fatherVC;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"相机", nil];
    [sheet showInView:fatherVC.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self fromPhotos];
    }else if (buttonIndex == 1) {
        [self createPhotoView];
    }
}

#pragma mark - 头像(相机和从相册中选择)
- (void)createPhotoView {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
        imagePC.sourceType                = UIImagePickerControllerSourceTypeCamera;
        imagePC.delegate                  = self;
        imagePC.allowsEditing             = YES;
        [_fatherViewController presentViewController:imagePC
                                            animated:YES
                                          completion:^{
                                          }];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"该设备没有照相机"
                                                        delegate:nil
                                               cancelButtonTitle:@"Done"
                                               otherButtonTitles:nil];
        [alert show];
    }
}

//图片库方法(从手机的图片库中查找图片)
- (void)fromPhotos {
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    imagePC.sourceType                = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePC.delegate                  = self;
    imagePC.allowsEditing             = YES;
    [_fatherViewController presentViewController:imagePC
                                        animated:YES
                                      completion:^{
                                      }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /**
     *  上传用户头像
     */
    if (self.uploadImageDelegate && [self.uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithImage:)]) {
        [self.uploadImageDelegate uploadImageToServerWithImage:image];
    }
    
    ZMUploadParam *param = [[ZMUploadParam alloc] init];
    param.filePath = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    param.data = imageData;
    if ([_uploadImageDelegate respondsToSelector:@selector(uploadImageToServerWithUploadParam:)]) {
        [self.uploadImageDelegate uploadImageToServerWithUploadParam:param];
    }
}



@end
