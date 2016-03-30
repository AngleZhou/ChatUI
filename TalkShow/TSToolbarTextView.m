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
@property (nonatomic, strong) NSTimer *timerVolume;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerTouch;
@property (nonatomic) NSInteger count;

@property (nonatomic) CGPoint startPoint;
@end



@implementation TSToolbarTextView

static long audioCount = 0;

- (void)initTimerVolume {
    [self invalidateTimerVolume];
    self.timerVolume = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateVolume) userInfo:nil repeats:YES];
}
- (void)invalidateTimerVolume {
    [self.timerVolume invalidate];
    self.timerVolume = nil;
}

- (void)updateVolume {
    if ([self.vTip isRecordingView]) {
        [self.recorder updateMeters];
        float decibels = [self.recorder averagePowerForChannel: 0];
        
        float level;                // The linear 0.0 .. 1.0 value we need.
        float minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
        
        if (decibels < minDecibels) {
            level = 0.0f;
        }
        else if (decibels >= 0.0f) {
            level = 1.0f;
        }
        else {
            float   root            = 2.0f;
            float   minAmp          = powf(10.0f, 0.05f * minDecibels);
            float   inverseAmpRange = 1.0f / (1.0f - minAmp);
            float   amp             = powf(10.0f, 0.05f * decibels);
            float   adjAmp          = (amp - minAmp) * inverseAmpRange;
            
            level = powf(adjAmp, 1.0f / root);
        }
        float avg = level * 120;
        //    NSLog(@"平均值 %f", level * 120);
        
        if (0 < avg  && avg < 30) {
            self.vTip.image = [UIImage imageNamed:@"voice_volume1"];
        }
        else if (30 <= avg && avg < 60) {
            self.vTip.image = [UIImage imageNamed:@"voice_volume2"];
        }
        else if (60 <= avg && avg < 90) {
            self.vTip.image = [UIImage imageNamed:@"voice_volume3"];
        }
        else if (90 <= avg && avg <= 120) {
            self.vTip.image = [UIImage imageNamed:@"voice_volume4"];
        }
    }
    
}

- (void)initTimer {
    [self invalidateTimer];
    [self invalidateTimerTouch];
    
    self.count = 10;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(counting) userInfo:nil repeats:YES];
}
- (void)counting {
    if (self.count == 0) {//倒计时结束，
        [self invalidateTimerVolume];
        [self invalidateTimer];
        [self.recorder stop];
        
        [self.delegatets TSTextViewAddAudio:[TSSave audioFileUrlWithFileName:[NSString stringWithFormat:@"audio%ld.m4a", (long)audioCount]]];
        
        [self.vTip removeFromSuperview];
        self.vTip = nil;
        [self normalButtonState];
    }
    else {
        self.vTip.imageTip = [NSString stringWithFormat:@"%d", self.count];
    }
    self.count--;
}
- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}


- (void)initTimerTouch {
    [self invalidateTimerTouch];
    self.timerTouch = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(initTimer) userInfo:nil repeats:NO];
}
- (void)invalidateTimerTouch {
    [self.timerTouch invalidate];
    self.timerTouch = nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tsState == TSTextViewStateButton) {
        UIView *vMain = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
        UITouch *touch = [touches anyObject];
        self.startPoint = [touch locationInView:vMain];
        
        [self highlightedState];
        [self initAudio];
        if ([self.recorder record]) {
            [self initTimerTouch];
            [self initTimerVolume];
            if (!self.vTip) {
                self.vTip = [TSTipView sharedInstance];
                [self.vTip recordingView];
                [self.vTip showInCenter];
            }
 
        }
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tsState == TSTextViewStateButton) {
        [self invalidateTimerVolume];
        [self invalidateTimer];
        [self invalidateTimerTouch];
        
        [self.recorder stop];
        
        UIView *vMain = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
        UITouch *touch = [touches anyObject];
        CGPoint txLocation = [touch locationInView:vMain];
        if ((self.startPoint.y - txLocation.y) > 60) {
            //删除录音
            [self.recorder deleteRecording];
        }
        else {
            //当时间短于1秒时, 删除文件不保存
            AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:self.fileURL options:nil];
            CMTime audioDuration = audioAsset.duration;
            if ((1 - CMTimeGetSeconds(audioDuration)) > 0) {
                //显示提示
                [self.vTip recordTooShortView];
                ______WS();
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [wSelf.vTip removeFromSuperview];
                    wSelf.vTip = nil;
                    [wSelf normalButtonState];
                });
                return;
            }
            //保存录音
            [self.delegatets TSTextViewAddAudio:[TSSave audioFileUrlWithFileName:[NSString stringWithFormat:@"audio%ld.m4a", (long)audioCount]]];
        }
        
        [self.vTip removeFromSuperview];
        self.vTip = nil;
        [self normalButtonState];
        
        
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:self.fileURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    double length = CMTimeGetSeconds(audioDuration);
    BOOL bCount = NO;
    if (length - 50 > 0) {//如果录音长度超过50秒，开始倒计时
        [self initTimer];
        bCount = YES;
    }
    UIView *vMain = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    UITouch *touch = [touches anyObject];
    CGPoint txLocation = [touch locationInView:vMain];
    if ((self.startPoint.y - txLocation.y) > 60 && ![self.vTip isCancelRecordingView]) {
        //往上滑动，提示取消录音
        [self.vTip cancelRecordingView];
    }
    else if((self.startPoint.y - txLocation.y) < 60 && ![self.vTip isRecordingView]) {
        if (bCount == NO) {
            //提示录音
            [self.vTip recordingView];
        }
        else {
            self.vTip.imageTip = [NSString stringWithFormat:@"%d", self.count];
        }
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
        NSError *error;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
        if (error) {
            NSLog(@"AVAudioSession setCategory error: %@", [error localizedDescription]);
        }
        
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
