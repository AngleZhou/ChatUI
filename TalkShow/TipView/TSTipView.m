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

+ (instancetype)sharedInstance {
    static TSTipView *tipView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tipView = [[TSTipView alloc] initPrivate];
    });
    return tipView;
}

- (instancetype)initPrivate {
    CGRect rect = CGRectMake(0, 0, 138, 138);
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        CGFloat width = (rect.size.width - 30*2);
        CGRect rect = CGRectMake(30, 20, width, width);
        self.imageView = [[UIImageView alloc] initWithFrame:rect];
        [self addSubview:self.imageView];
        ______WS();
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf);
            make.top.equalTo(wSelf).with.offset(30);
        }];
        self.lblTip = [[UILabel alloc] init];
        self.lblTip.font = kTSFontRemark;
        self.lblTip.textAlignment = NSTextAlignmentCenter;
        self.lblTip.textColor = [UIColor whiteColor];
        [self addSubview:self.lblTip];
        [self.lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf);
            make.bottom.equalTo(wSelf).with.offset(-8);
        }];
    }
    return self;
}

- (instancetype)init {
    return [self initPrivate];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initPrivate];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(image.size);
    }];
    self.imageView.image = image;
}

- (void)setTip:(NSString *)tip {
    _tip = tip;
    self.lblTip.text = tip;
    CGFloat maxWidth = self.width - 8*2;
    CGSize size = [tip textSizeWithFont:self.lblTip.font constrainedToSize:CGSizeMake(maxWidth, 99) lineBreakMode:NSLineBreakByWordWrapping];
    [self.lblTip mas_updateConstraints:^(MASConstraintMaker *make) {
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
