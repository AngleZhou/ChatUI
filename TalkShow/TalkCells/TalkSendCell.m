//
//  TalkSendCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/19.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TalkSendCell.h"


@implementation TalkSendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        TPMessageBubble *msgBubble = [[TPMessageBubble alloc] init];
        
        ______WS();
        [self.vContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf.vBubble).with.offset(kTSBubbleTextYMargin);
            make.bottom.equalTo(wSelf.vBubble).with.offset(-kTSBubbleTextYMargin);
            make.trailing.equalTo(wSelf.vBubble).with.offset(-kTSBubbleTextXMargin*2);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        self.msgBubbleImage = [msgBubble tpMsgSendBubble];
        self.vBubble.image = self.msgBubbleImage.image;
        [self.vBubble mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(wSelf).with.offset(-kTSSideX);
            make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
            
            make.leading.equalTo(wSelf.vContent).with.offset(-kTSBubbleTextXMargin);
        }];
        
        [self.lblVoiceLength mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(wSelf.vBubble.mas_leading).with.offset(-kTSBubbleTextXMargin/2);
            make.centerY.equalTo(wSelf.vBubble).with.offset(4);
        }];
        
    }
    
    return self;
}

- (void)setFileUrl:(NSURL *)fileUrl {
    [super setFileUrl:fileUrl];
    
    UIImage *flippedImage = [UIImage tp_horizontallyFlippedFromImage:self.vSound.image];
    self.vSound.image = flippedImage;
    ______WS();
    [self.vSound mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(wSelf.vContent);
    }];
}
@end
