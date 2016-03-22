//
//  TSTextView.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/17.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSToolbarTextView.h"
#import "TSSave.h"
#import "TSTipView.h"
#import <AVFoundation/AVFoundation.h>
#import "TSAuthentication.h"


#define TouchDownColor [UIColor grayColor]
#define TouchUpColor [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.1]

@interface TSToolbarTextView () <AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) TSTipView *vTip;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic) BOOL touchUp;
@property (nonatomic, strong) NSTimer *timer;
@end



@implementation TSToolbarTextView

static long audioCount = 0;

- (void)initTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.1 target:self selector:@selector(updateVolume) userInfo:nil repeats:YES];
}

- (void)updateVolume {
    [self.recorder updateMeters];
    float apow = [self.recorder peakPowerForChannel:2];
    NSLog(@"%.3f", apow);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tsState == TSTextViewStateButton) {
        [self highlightedState];
        [self initAudio];
        if ([self.recorder record]) {
            if (!self.vTip) {
                self.vTip = [TSTipView sharedInstance];
                self.vTip.tip = @"手指上滑，取消发送";
                self.vTip.image = [UIImage imageNamed:@"voice_volume0"];
                [self.vTip showInCenter];
            }
            
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tsState == TSTextViewStateButton) {
        
        [self.recorder stop];
        [self.timer invalidate];
        self.timer = nil;
        //当时间短于1秒时, 删除文件不保存
        AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:self.fileURL options:nil];
        CMTime audioDuration = audioAsset.duration;
        if ((1 - CMTimeGetSeconds(audioDuration)) > 0) {
            //显示提示
            self.vTip.image = [UIImage imageNamed:@"audio_press_short"];
            self.vTip.tip = @"说话时间太短";
            ______WS();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wSelf.vTip removeFromSuperview];
                wSelf.vTip = nil;
                [wSelf normalButtonState];
            });
            return;
        }
        
        [self.vTip removeFromSuperview];
        self.vTip = nil;
        [self normalButtonState];
        
        [self.delegatets TSTextViewAddAudio:[TSSave audioFileUrlWithFileName:[NSString stringWithFormat:@"audio%ld.m4a", (long)audioCount]]];
    }
}

- (void)normalButtonState {//button状态，可以按
    self.backgroundColor = TouchUpColor;
    self.text = @"按住 说话";
    self.userInteractionEnabled = YES;
}
- (void)highlightedState {//按住的状态
    self.backgroundColor = TouchDownColor;
    self.text = @"松开 结束";
    self.userInteractionEnabled = NO;
}


- (void)initAudio {
    audioCount++;
    self.fileURL = [TSSave audioFileUrlWithFileName:[NSString stringWithFormat:@"audio%ld.m4a", (long)audioCount]];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([TSAuthentication canRecord]) {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        
        //define the recorder setting
        NSMutableDictionary *recordSetting = [@{AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                                AVSampleRateKey : @(44100.0),
                                                AVNumberOfChannelsKey : @2} mutableCopy];
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.fileURL settings:recordSetting error:nil];
        self.recorder.delegate = self;
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];

    }
}





@end
