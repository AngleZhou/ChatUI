//
//  TSTools.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/26.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSTools.h"

@implementation TSTools

+ (UIImage *)imageFromIconFont:(NSString *)iconFontName {
    CGRect rect = CGRectMake(0, 0, 114, 114);
    UILabel *label = [[UILabel alloc] init];//[TSTools iconfontLabel:iconFontName size:32];
    label.textColor = [UIColor grayColor];
    label.text = @"hello";
    label.backgroundColor = kTSInputPluginViewBGColor;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = kTSInputPluginViewBGColor;
    [view addSubview:label];
    ______WX(view, wView);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wView);
        make.centerY.equalTo(wView);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [view layoutSubviews];
    
    
    UIGraphicsBeginImageContext(CGSizeMake(114, 114));
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UILabel*)iconfontLabel:(NSString *)name size:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    label.font = iconFont(size);
    label.text = name;
    return label;
}
@end
