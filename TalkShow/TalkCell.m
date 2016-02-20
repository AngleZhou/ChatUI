//
//  TalkCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/16.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TalkCell.h"

#import "NSString+Size.h"
#import <AVFoundation/AVFoundation.h>


#define MaxCellWidth kTSScreenWidth*2/3
#define MaxAudioCellWidth 150
#define MinAudioCellWidth 40
#define MinCellHeight 24

@interface TalkCell () <AVAudioPlayerDelegate>


@property (nonatomic, strong) UIView *vAccessory;


@property (nonatomic, strong) UILabel *lblText;


@property (nonatomic) NSTimeInterval audioLength;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation TalkCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.vBubble = [[UIImageView alloc] init];
        [self addSubview:self.vBubble];

        self.vContent = [[UIView alloc] init];
        [self addSubview:self.vContent];
        
        self.lblVoiceLength = [[UILabel alloc] init];
        [self addSubview:self.lblVoiceLength];
        
        
        self.lblText = [[UILabel alloc] init];
        [self.vContent addSubview:self.lblText];
        self.lblText.text = self.text;
        self.lblText.numberOfLines = 0;
        self.lblText.lineBreakMode = NSLineBreakByWordWrapping;
        [self.vContent addSubview:self.lblText];
        
        self.vSound = [[UIImageView alloc] init];
        [self.vContent addSubview:self.vSound];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)];
        self.vContent.userInteractionEnabled = YES;
        [self.vContent addGestureRecognizer:tap];
//        self.vSound.userInteractionEnabled = YES;
//        [self.vSound addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    if (text.length == 0) {
        return;
    }
    _text = text;
    
    self.lblText.text = text;
    
    CGSize size = [text textSizeWithFont:self.lblText.font constrainedToSize:CGSizeMake(MaxCellWidth, 999) lineBreakMode:NSLineBreakByWordWrapping];
    ______WS();
    [self.lblText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.vContent);
        make.top.equalTo(wSelf.vContent);
        make.size.mas_equalTo(size);
    }];
    [self.vContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
        make.width.mas_equalTo(size.width);
    }];
    [self layoutSubviews];
    [self layoutIfNeeded];
    self.height = size.height + kTSBubbleTextYMargin*4;
}

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;

    ______WS();
    
    UIImage *soundImage = [UIImage imageNamed:@"from_voice_play"];
    self.vSound.image = soundImage;
    [self.vSound mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wSelf.vContent);
        make.size.mas_equalTo(CGSizeMake(18,18));
    }];
    
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
    [self.vContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(contentWidth, MinCellHeight));
    }];
    self.height = MinCellHeight + kTSBubbleTextYMargin*4;
    
    self.lblVoiceLength.text = voiceLength ;
    CGSize size = [voiceLength textSizeWithFont:self.lblText.font constrainedToSize:CGSizeMake(MaxCellWidth, 999) lineBreakMode:NSLineBreakByWordWrapping];
    [self.lblVoiceLength mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    
    self.height = MinCellHeight + kTSBubbleTextYMargin*4;
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
