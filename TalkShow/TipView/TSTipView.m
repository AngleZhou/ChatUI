//
//  TSTipView.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/21.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSTipView.h"

@interface TSTipView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *lblTip;
@end

@implementation TSTipView

- (instancetype)init {
    CGRect rect = CGRectMake(0, 0, kTSScreenWidth/3, kTSScreenWidth/3);
    return [self initWithFrame:rect];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        CGFloat width = (frame.size.width - 30*2);
        CGRect rect = CGRectMake(30, 20, width, width);
        self.imageView = [[UIImageView alloc] initWithFrame:rect];
        [self addSubview:self.imageView];
        self.lblTip = [[UILabel alloc] init];
        self.lblTip.font = kTSFontRemark;
        self.lblTip.textAlignment = NSTextAlignmentCenter;
        self.lblTip.textColor = [UIColor whiteColor];
        [self addSubview:self.lblTip];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setTip:(NSString *)tip {
    _tip = tip;
    self.lblTip.text = tip;
    CGFloat maxWidth = self.width - 8*2;
    CGSize size = [tip textSizeWithFont:self.lblTip.font constrainedToSize:CGSizeMake(maxWidth, 99) lineBreakMode:NSLineBreakByWordWrapping];
    ______WS();
    [self.lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wSelf);
        make.bottom.equalTo(wSelf).with.offset(-8);
        make.size.mas_equalTo(size);
    }];
}

- (void)showInCenter {
    UIView *vRoot = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [vRoot addSubview:self];
    self.layer.zPosition = 2;
    ______WX(vRoot, wvRoot);
    ______WS();
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wvRoot);
        make.centerY.equalTo(wvRoot);
        make.size.mas_equalTo(CGSizeMake(wSelf.width, wSelf.width));
    }];
}

@end
