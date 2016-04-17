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
        self.lblSelected = [TSTools iconfontLabel:@"\U0000e600" size:18];
        self.lblSelected.textColor = kTSTintColor;
        [self addSubview:self.lblSelected];
        self.lblSelected.hidden = YES;
        [self.lblSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(wSelf).with.offset(-kTSSideX);
            make.centerY.equalTo(wSelf);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        self.lblTitle = [[UILabel alloc] init];
        self.lblTitle.font = kTSFontMain;
        self.lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.lblTitle];
        [self.lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(wSelf).with.offset(kTSSideX);
        }];

        self.lblSubTitle = [[UILabel alloc] init];
        self.lblSubTitle.font = kTSFontTip;
        self.lblSubTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        self.lblSubTitle.textColor = CTColorOther;
        [self addSubview:self.lblSubTitle];
        [self.lblSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(wSelf).with.offset(kTSSideX);
            make.top.equalTo(wSelf.lblTitle.mas_bottom).with.offset(5);
        }];
        
        
    }
    return self;
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle {
    if (title.length == 0) {
        return;
    }
    _title = title;
    self.lblTitle.text = title;
    _subTitle = subTitle;
    self.lblSubTitle.text = subTitle;
    
    ______WS();
    CGFloat width = kTSScreenWidth - kTSSideX*3 - self.lblSelected.width;
    CGSize size = [title textSizeWithFont:self.lblTitle.font constrainedToSize:CGSizeMake(width, 44) lineBreakMode:self.lblTitle.lineBreakMode];
    if (subTitle.length > 0) {
        CGSize sizeSub = [subTitle textSizeWithFont:self.lblSubTitle.font constrainedToSize:CGSizeMake(width, 44) lineBreakMode:self.lblSubTitle.lineBreakMode];
        [self.lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf).with.offset(5);
            make.size.mas_equalTo(size);
        }];
        [self.lblSubTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(sizeSub);
        }];
        
    }
    else {
        [self.lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wSelf);
            make.size.mas_equalTo(size);
        }];

    }
    
}



- (void)setBChecked:(BOOL)bChecked {
    _bChecked = bChecked;
    self.lblSelected.hidden = !_bChecked;
}


@end
