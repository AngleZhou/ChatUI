//
//  TSLocationCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/4/5.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSLocationCell.h"

@interface TSLocationCell ()
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblSubTitle;
@property (nonatomic, strong) UILabel *lblSelected;
@end

@implementation TSLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bChecked = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        ______WS();
        self.lblSelected = [TSTools iconfontLabel:@"\U0000e600" size:8];
        self.lblSelected.textColor = kTSTintColor;
        [self addSubview:self.lblSelected];
        self.lblSelected.hidden = YES;
        [self.lblSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(wSelf).with.offset(-kTSSideX);
            make.centerY.equalTo(wSelf);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        
        self.lblTitle = [[UILabel alloc] init];
        self.lblTitle.font = kTSFontMain;
        self.lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.lblTitle];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(wSelf).with.offset(kTSSideX);
            make.trailing.equalTo(wSelf.lblSelected.mas_leading).with.offset(-kTSSideX);
        }];

        self.lblSubTitle = [[UILabel alloc] init];
        self.lblSubTitle.font = kTSFontTip;
        self.lblSubTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.lblSubTitle];
        [self.lblSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(wSelf).with.offset(kTSSideX);
            make.trailing.equalTo(wSelf.lblSelected.mas_leading).with.offset(-kTSSideX);
            make.top.equalTo(wSelf.lblTitle.mas_bottom).with.offset(8);
        }];
        
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    if (title.length == 0) {
        return;
    }
    _title = title;
    self.lblTitle.text = title;
    
    ______WS();
    CGSize size = [title textSizeWithFont:self.lblTitle.font constrainedToSize:CGSizeMake(kTSScreenWidth - kTSSideX*3 - self.lblSelected.width, 44) lineBreakMode:self.lblTitle.lineBreakMode];
    if (self.subTitle.length > 0) {
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf).with.offset(8);
            make.size.mas_equalTo(size);
        }];
    }
    else {
        [self.lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf);
            make.size.mas_equalTo(size);
        }];
    }
}


- (void)setSubTitle:(NSString *)subTitle {
    if (subTitle.length == 0) {
        return;
    }
    _subTitle = subTitle;
    self.lblSubTitle.text = subTitle;
    
    CGSize size = [subTitle textSizeWithFont:self.lblSubTitle.font constrainedToSize:CGSizeMake(kTSScreenWidth - kTSSideX*3 - self.lblSelected.width, 44) lineBreakMode:self.lblSubTitle.lineBreakMode];
    [self.lblSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}

- (void)setBChecked:(BOOL)bChecked {
    _bChecked = bChecked;
    self.lblSelected.hidden = !_bChecked;
}


@end
