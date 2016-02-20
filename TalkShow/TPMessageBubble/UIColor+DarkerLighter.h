//
//  UIColor+DarkerLighter.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/19.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DarkerLighter)
+ (UIColor *)lighterColorForColor:(UIColor *)c;
+ (UIColor *)darkerColorForColor:(UIColor *)c;
@end
