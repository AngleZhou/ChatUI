//
//  TSCamera.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/1.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSImagePicker.h"

@interface TSImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation TSImagePicker

+ (instancetype)sharedInstance {
    static TSImagePicker *picker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[self alloc] init];
    });
    
    return picker;
}

- (void)showImagePicker {
    UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
    imgPickerController.delegate = self;
    if (self.sourceType == TSImagePickerTypeCamera) {
        imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if (self.sourceType == TSImagePickerTypeAlbum) {
        imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imgPickerController.allowsEditing = YES;
    
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:imgPickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (self.handlerBlock) {
        self.handlerBlock(image);
    }
}
@end
