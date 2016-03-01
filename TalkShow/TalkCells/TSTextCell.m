//
//  TSTextCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/1.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSTextCell.h"

@interface TSTextCell ()
@property (nonatomic, strong) UILabel *lblText;
@end


@implementation TSTextCell

- (instancetype)initWithType:(TalkCellType)type talkCellContentType:(NSString *)talkCellContentType {
    self = [super initWithType:type reuseIdentifier:TalkCellContentTypeText];
    if (self) {
        self.lblText = [[UILabel alloc] init];
        self.lblText.text = self.text;
        self.lblText.numberOfLines = 0;
        self.lblText.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.lblText];
    }
    return self;
}


- (void)setText:(NSString *)text {
    if (text.length == 0) {
        return;
    }
    _text = text;
    
    self.lblText.text = text;
    
    CGSize size = [text textSizeWithFont:self.lblText.font constrainedToSize:CGSizeMake(TalkCellMaxWidth, 999) lineBreakMode:NSLineBreakByWordWrapping];
    ______WS();
    [self.lblText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf).with.offset(kTSBubbleTextXMargin*2);
        make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
        make.size.mas_equalTo(size);
    }];
    [self.vBubble mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height + kTSBubbleTextYMargin);
        make.width.mas_equalTo(size.width + kTSBubbleTextXMargin);
    }];
    [self layoutSubviews];
    [self layoutIfNeeded];
    self.height = size.height + kTSBubbleTextYMargin*4;
}
@end
