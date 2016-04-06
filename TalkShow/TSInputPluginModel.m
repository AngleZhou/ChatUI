//
//  TSInputPluginModel.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/26.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSInputPluginModel.h"
#import "TSImagePicker.h"
#import "TSSave.h"
#import "TSLocationVC.h"

@implementation TSInputPluginItem

@end

@implementation TSInputPluginModel

+ (NSArray *)initInputPlugins {
    NSMutableArray *plugins = [[NSMutableArray alloc] init];
    TSImagePicker *imagePicker = [TSImagePicker sharedInstance];
    
    //照片
    TSInputPluginItem *album = [[TSInputPluginItem alloc] init];
    album.name = @"照片";
    album.image = [UIImage imageNamed:@"actionbar_picture_icon"];
    album.action = ^{
        imagePicker.sourceType = TSImagePickerTypeAlbum;
        [imagePicker showImagePicker];
        
    };
    [plugins addObject:album];
    
    //拍照
    TSInputPluginItem *photo = [[TSInputPluginItem alloc] init];
    photo.name = @"拍摄";
    photo.imageName = @"\U0000e60a";
    photo.image = [UIImage imageNamed:@"actionbar_camera_icon"];
    photo.action = ^{
        imagePicker.sourceType = TSImagePickerTypeCamera;
        [imagePicker showImagePicker];
    };
    [plugins addObject:photo];
    
    //位置
    TSLocationVC *lvc = [[TSLocationVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
    TSInputPluginItem *location = [[TSInputPluginItem alloc] init];
    location.name = @"位置";
    location.image = [UIImage imageNamed:@"actionbar_location_icon"];
    location.action = ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    };
    [plugins addObject:location];
    
    return [plugins copy];
}
@end
