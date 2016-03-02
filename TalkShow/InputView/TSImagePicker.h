//
//  TSCamera.h
//  TalkShow
//
//  Created by ZhouQian on 16/3/1.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TSImagePickerType) {
    TSImagePickerTypeCamera,
    TSImagePickerTypeAlbum
};
@class TSImagePicker;

@protocol TSImagePickerDelegate <NSObject>

- (void)TSImagePicker:(TSImagePicker*)imagePicker didFinishedPickingImage:(UIImage *)image;

@end


typedef void(^HandlerBlock)(UIImage *image);

@interface TSImagePicker : NSObject
@property (nonatomic) TSImagePickerType sourceType;
@property (nonatomic, copy) HandlerBlock handlerBlock;

@property (nonatomic, weak) id<TSImagePickerDelegate>delegate;

+ (instancetype)sharedInstance;
- (void)showImagePicker;
@end
