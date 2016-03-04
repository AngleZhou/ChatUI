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
        
        ______WS();
        TPMessageBubble *msgBubble = [[TPMessageBubble alloc] init];
        switch (type) {
            case TalkCellTypeReceived:
            {
                self.msgBubbleImage = [msgBubble tpMsgReceivedBubble];
                self.vBubble.image = self.msgBubbleImage.image;
                [self.vBubble mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
                    make.leading.equalTo(wSelf).with.offset(kTSSideX);
                    make.size.mas_equalTo(CGSizeMake(44, 44));
//                    make.trailing.equalTo(wSelf.vContent).with.offset(kTSBubbleTextXMargin);
                    
                }];
            }
                break;
            case TalkCellTypeSend:
            {
                self.msgBubbleImage = [msgBubble tpMsgSendBubble];
                self.vBubble.image = self.msgBubbleImage.image;
                [self.vBubble mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
                    make.trailing.equalTo(wSelf).with.offset(-kTSSideX);
                    make.size.mas_equalTo(CGSizeMake(44, 44));
//                    make.leading.equalTo(wSelf.vContent).with.offset(-kTSBubbleTextXMargin);
                }];
            }
                break;
        }
    }
    return self;
}




@end
