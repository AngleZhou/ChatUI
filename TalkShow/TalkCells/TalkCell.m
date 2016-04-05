//
//  TalkCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/16.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TalkCell.h"
#import "NSString+Size.h"

@interface TalkCell () 

@end

@implementation TalkCell

- (instancetype)initWithType:(TalkCellType)type talkCellContentType:(NSString *)talkCellContentType {
    self = [super initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:talkCellContentType];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellType = type;
        self.contentType = talkCellContentType;
        
        self.vBubble = [[UIImageView alloc] init];
        [self addSubview:self.vBubble];
        
        self.vHead = [[UIImageView alloc] init];
        [self addSubview:self.vHead];
        self.vHead.image = [UIImage imageNamed:@"head_default"];
        
        ______WS();
        TPMessageBubble *msgBubble = [[TPMessageBubble alloc] init];
        switch (type) {
            case TalkCellTypeReceived://左边
            {
                [self.vHead mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
                    make.leading.equalTo(wSelf).with.offset(kTSSideX);
                    make.size.mas_equalTo(CGSizeMake(44, 44));
                }];
                
                self.msgBubbleImage = [msgBubble tpMsgReceivedBubble];
                self.vBubble.image = self.msgBubbleImage.image;
                [self.vBubble mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
                    make.leading.equalTo(wSelf.vHead.mas_trailing).with.offset(8);
                    make.size.mas_equalTo(CGSizeMake(44, 44));
                }];
                
            }
                break;
            case TalkCellTypeSend://右边
            {
                [self.vHead mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
                    make.trailing.equalTo(wSelf).with.offset(-kTSSideX);
                    make.size.mas_equalTo(CGSizeMake(44, 44));
                }];
                self.msgBubbleImage = [msgBubble tpMsgSendBubble];
                self.vBubble.image = self.msgBubbleImage.image;
                [self.vBubble mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
                    make.trailing.equalTo(wSelf.vHead.mas_leading).with.offset(-8);
                    make.size.mas_equalTo(CGSizeMake(44, 44));
                }];
            }
                break;
        }
    }
    return self;
}




@end
