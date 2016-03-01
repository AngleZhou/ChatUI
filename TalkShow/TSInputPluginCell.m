//
//  TSInputPluginCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/26.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSInputPluginCell.h"


@interface TSInputPluginCell ()
@property (nonatomic, strong) UIButton *btnPlugin;
@property (nonatomic, strong) UILabel *lblName;

@end


@implementation TSInputPluginCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        ______WS();
        self.backgroundColor = kTSInputPluginViewBGColor;
        self.btnPlugin = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kTSInputPluginCellWidth, kTSInputPluginCellWidth)];
        self.btnPlugin.backgroundColor = kTSInputPluginViewBGColor;
        self.btnPlugin.layer.borderWidth = 1;
        self.btnPlugin.layer.borderColor = kTSInputPluginTextColor.CGColor;
        self.btnPlugin.layer.cornerRadius = 5;
        [self addSubview:self.btnPlugin];
        [self.btnPlugin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf);
            make.top.equalTo(wSelf);
            make.size.mas_equalTo(CGSizeMake(kTSInputPluginCellWidth, kTSInputPluginCellWidth));
        }];
        self.lblName = [[UILabel alloc] init];
        self.lblName.backgroundColor = kTSInputPluginViewBGColor;
        self.lblName.textColor = kTSInputPluginTextColor;
        self.lblName.textAlignment = NSTextAlignmentCenter;
        self.lblName.font = kTSInputPluginCellFont;
        [self addSubview:self.lblName];
        [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf.btnPlugin);
            make.top.equalTo(wSelf.btnPlugin.mas_bottom).with.offset(4);
            make.size.mas_equalTo(CGSizeMake(kTSInputPluginCellWidth, 12));
        }];
        
        self.frame = frame;
    }
    return self;
}



- (void)setItem:(TSInputPluginItem *)item {
//    UIImage *image = [TSTools imageFromIconFont:item.imageName];
    
    [self.btnPlugin setBackgroundImage:item.image forState:UIControlStateNormal];
//    self.btnPlugin.titleLabel = [TSTools iconfontLabel:item.imageName size:12];
    [[[self.btnPlugin rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        if (item.action) {
            item.action();
        }
        
    }];
    self.lblName.text = item.name;
    CGFloat maxWidth = (kTSScreenWidth - 4*kTSInputPluginCellWidth)/5 + kTSInputPluginCellWidth;
    CGSize size = [self.lblName.text textSizeWithFont:self.lblName.font constrainedToSize:CGSizeMake(maxWidth, 999) lineBreakMode:NSLineBreakByTruncatingTail];
    [self.lblName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}
@end
