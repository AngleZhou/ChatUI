//
//  TSVoiceCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/1.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSVoiceCell.h"
#import <AVFoundation/AVFoundation.h>

#define MaxAudioCellWidth 150
#define MinAudioCellWidth 40
#define MinCellHeight 34

@interface TSVoiceCell () <AVAudioPlayerDelegate>
@property (nonatomic, strong) UILabel        *lblVoiceLength;
@property (nonatomic, strong) UIImageView    *vSound;
@property (nonatomic        ) NSTimeInterval audioLength;
@property (nonatomic, strong) AVAudioPlayer  *player;
@end

@implementation TSVoiceCell

- (instancetype)initWithType:(TalkCellType)type talkCellContentType:(NSString *)talkCellContentType {
    self = [super initWithType:type talkCellContentType:TalkCellContentTypeAudio];
    if (self) {
        ______WS();
        self.lblVoiceLength = [[UILabel alloc] init];
        self.lblVoiceLength.font = kTSMainFont;
        [self addSubview:self.lblVoiceLength];
        
        self.vSound = [[UIImageView alloc] init];
        [self.vBubble addSubview:self.vSound];
        
        switch (self.cellType) {
            case TalkCellTypeReceived: {
                [self.lblVoiceLength mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(wSelf.vBubble.mas_trailing).with.offset(kTSBubbleTextXMargin/2);
                    make.centerY.equalTo(wSelf.vBubble).with.offset(4);
                }];
                [self.vSound mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(wSelf.vBubble).with.offset(kTSBubbleTextXMargin);
                    make.centerY.equalTo(wSelf.vBubble);
                    make.size.mas_equalTo(CGSizeMake(18,18));
                }];
                break;
            }
            case TalkCellTypeSend: {
                [self.lblVoiceLength mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.equalTo(wSelf.vBubble.mas_leading).with.offset(-kTSBubbleTextXMargin/2);
                    make.centerY.equalTo(wSelf.vBubble).with.offset(4);
                }];
                [self.vSound mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.equalTo(wSelf.vBubble).with.offset(-kTSBubbleTextXMargin);
                    make.centerY.equalTo(wSelf.vBubble);
                    make.size.mas_equalTo(CGSizeMake(18,18));
                }];
                break;
            }
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)];
        self.vBubble.userInteractionEnabled = YES;
        [self.vBubble addGestureRecognizer:tap];
    }
    return self;
}

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;
    
    UIImage *soundImage = [UIImage imageNamed:@"from_voice_play"];
    if (self.cellType == TalkCellTypeSend) {
        UIImage *flippedImage = [UIImage tp_horizontallyFlippedFromImage:soundImage];
        self.vSound.image = flippedImage;
    }
    else {
        self.vSound.image = soundImage;
    }
    
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:self.fileUrl options:nil];
    CMTime audioDuration = audioAsset.duration;
    int audioDurationSeconds = (int)ceil(CMTimeGetSeconds(audioDuration));
    self.audioLength = audioDurationSeconds;
    NSString *voiceLength = [NSString stringWithFormat:@"%d\"", audioDurationSeconds];
    NSInteger contentWidth = 0;
    if (audioDurationSeconds == 1) {
        contentWidth = MinAudioCellWidth;
    }
    else {
        contentWidth = MinAudioCellWidth + (MaxAudioCellWidth - MinAudioCellWidth) * audioDurationSeconds / 60;
    }
    [self.vBubble mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(contentWidth, 18+kTSBubbleTextYMargin*2));
    }];
    
    
    self.lblVoiceLength.text = voiceLength;
    CGSize size = [voiceLength textSizeWithFont:self.lblVoiceLength.font constrainedToSize:CGSizeMake(kTSTalkCellMaxWidth, 999) lineBreakMode:NSLineBreakByWordWrapping];
    [self.lblVoiceLength mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    
    
    [self layoutSubviews];
    self.height = 18+kTSBubbleTextYMargin*4;
}



- (void)playAudio {
    self.vBubble.image = self.msgBubbleImage.highlightedImage;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.fileUrl error:nil];
    self.player.delegate = self;
    [self.player play];
    [self playAudioAnimation];
}

- (void)playAudioAnimation {
    ______WS();
    
    [UIView animateWithDuration:1 animations:^{
        wSelf.vBubble.image = wSelf.msgBubbleImage.highlightedImage;
    } completion:^(BOOL finished) {
        wSelf.vBubble.image = wSelf.msgBubbleImage.image;
        wSelf.vBubble.animationDuration = 1;
        wSelf.vBubble.animationRepeatCount = 1;
        [wSelf.vBubble startAnimating];
        
        wSelf.vSound.animationImages = @[[UIImage imageNamed:@"from_voice_play1"],
                                         [UIImage imageNamed:@"from_voice_play2"],
                                         [UIImage imageNamed:@"from_voice_play3"]];
        wSelf.vSound.animationDuration = 1;
        wSelf.vSound.animationRepeatCount = wSelf.audioLength;
        [wSelf.vSound startAnimating];
    }];
    
    
    
}

@end
