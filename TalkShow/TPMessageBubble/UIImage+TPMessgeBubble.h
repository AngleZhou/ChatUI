//
//  UIImage+TPMessgeBubble.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/18.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TPMessgeBubble)

+ (UIImage *)tp_horizontallyFlippedFromImage:(UIImage *)image;
+ (UIImage *)tp_stretchableImage:(UIImage *)image WithCapInsets:(UIEdgeInsets)capInsets;
+ (UIImage *)tp_maskedImage:(UIImage *)image WithColor:(UIColor *)maskColor;
@end
