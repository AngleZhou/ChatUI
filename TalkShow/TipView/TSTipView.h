//
//  TSTipView.h
//  TalkShow
//
//  Created by ZhouQian on 16/3/21.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSTipView : UIView
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) UIImage *image;

+ (instancetype)sharedInstance;
- (void)showInCenter;

@end
