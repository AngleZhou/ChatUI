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
    self = [super initWithType:type talkCellContentType:talkCellContentType];
    if (self) {
        self.lblText = [[UILabel alloc] init];
        self.lblText.text = self.content;
        self.lblText.font = kTSMainFont;
        self.lblText.numberOfLines = 0;
        self.lblText.lineBreakMode = NSLineBreakByWordWrapping;
        [self.vBubble addSubview:self.lblText];
        
        ______WS();
        [self.lblText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf.vBubble).with.offset(kTSBubbleTextYMargin);
            make.size.mas_equalTo(CGSizeMake(44, 44));
            switch (self.cellType) {
                case TalkCellTypeReceived: {
                    make.leading.equalTo(wSelf.vBubble).with.offset(kTSBubbleTextXMargin*2);
                    break;
                }
                case TalkCellTypeSend: {
                    make.trailing.equalTo(wSelf.vBubble).with.offset(-kTSBubbleTextXMargin*2);
                    break;
                }
            }
        }];
        
    }
    return self;
}


- (void)setContent:(NSString *)content {
    if (content.length == 0) {
        return;
    }
    _content = content;
    
    self.lblText.text = content;
    
    CGSize size = [content textSizeWithFont:self.lblText.font constrainedToSize:CGSizeMake(kTSTalkCellMaxWidth, 999) lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.lblText mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    [self.vBubble mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width+kTSBubbleTextXMargin*3, size.height+kTSBubbleTextYMargin*2));
    }];

    [self layoutSubviews];
    [self layoutIfNeeded];
    self.height = size.height + kTSBubbleTextYMargin*4;
}
@end
