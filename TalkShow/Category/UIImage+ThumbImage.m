//
//  UIImage+ThumbImage.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/2.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "UIImage+ThumbImage.h"

@implementation UIImage (ThumbImage)

- (UIImage *)getThumbImage {
    CGFloat maxWidth = kTSScreenWidth/2 - kTSBubbleTextXMargin - kTSAvataWidth;
    if (self.size.height < maxWidth && self.size.width < maxWidth) {
        return self;
    }
    
    
    
    CGFloat height = 0;
    CGFloat width = 0;
    if (self.size.height > maxWidth && self.size.width < maxWidth) {
         height = maxWidth;
         width = maxWidth * self.size.width / self.size.height;
    }
    else {
        width = maxWidth;
        height = maxWidth * self.size.height / self.size.width;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
