//
//  TSVoiceCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/19.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSVoiceCell.h"
#import "TPMessageBubble.h"
#import <AVFoundation/AVFoundation.h>


@interface TSVoiceCell () <AVAudioPlayerDelegate>
@property (nonatomic, strong) UILabel *lblVoiceLength;
@property (nonatomic, strong) UIImageView *vBubble;
@property (nonatomic, strong) TPMessageBubbleImage *msgBubbleImage;

@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation TSVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lblVoiceLength = [[UILabel alloc] init];
        [self addSubview:self.lblVoiceLength];
        self.vBubble = [[UIImageView alloc] init];
        [self addSubview:self.vBubble];
        
        ______WS();
        
        TPMessageBubble *msgBubble = [[TPMessageBubble alloc] init];
        if ([reuseIdentifier isEqualToString:SENDCELL]) {
            self.msgBubbleImage = [msgBubble tpMsgSendBubble];
            self.vBubble.image = self.msgBubbleImage.image;
            [self.vBubble mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(wSelf).with.offset(-kTSSideX);
                make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
            }];
        }
        
        if ([reuseIdentifier isEqualToString:RECEIVECELL]) {
            self.msgBubbleImage = [msgBubble tpMsgReceivedBubble];
            self.vBubble.image = self.msgBubbleImage.image;
            [self.vBubble mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(wSelf).with.offset(kTSSideX);
                make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
            }];
        }
    }
    
    return self;
}

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:self.fileUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    self.lblVoiceLength.text = [NSString stringWithFormat:@"%d\"", (int)ceil(audioDurationSeconds)];
}

- (void)playSound {
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.fileUrl error:nil];
    self.player.delegate = self;
    [self.player play];
}
@end
