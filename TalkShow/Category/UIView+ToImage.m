//
//  UIView+ToImage.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/4.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "UIView+ToImage.h"

@implementation UIView (ToImage)

- (UIImage *)toImage {
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
