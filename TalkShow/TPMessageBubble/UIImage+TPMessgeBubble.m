//
//  UIImage+TPMessgeBubble.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/18.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "UIImage+TPMessgeBubble.h"

@implementation UIImage (TPMessgeBubble)

+ (UIImage *)tp_horizontallyFlippedFromImage:(UIImage *)image {
    return [UIImage imageWithCGImage:image.CGImage
                               scale:image.scale
                         orientation:UIImageOrientationUpMirrored];
}

+ (UIImage *)tp_stretchableImage:(UIImage *)image WithCapInsets:(UIEdgeInsets)capInsets
{
    return [image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)tp_maskedImage:(UIImage *)image WithColor:(UIColor *)maskColor
{
    NSParameterAssert(maskColor != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, image.scale);
    
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
        
        CGContextClipToMask(context, imageRect, image.CGImage);
        CGContextSetFillColorWithColor(context, maskColor.CGColor);
        CGContextFillRect(context, imageRect);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
