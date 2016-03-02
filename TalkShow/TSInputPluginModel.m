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
    
    

    return [plugins copy];
}
@end
