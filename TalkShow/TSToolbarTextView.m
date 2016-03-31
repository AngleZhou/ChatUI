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
#import "TSAudioUitls.h"



#define TouchDownColor [UIColor grayColor]
#define TouchUpColor [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.1]

@interface TSToolbarTextView ()
@property (nonatomic, strong) TSTipView *vTip;
@property (nonatomic) BOOL bCounting;
@property (nonatomic) BOOL bEnd;
@property (nonatomic, strong) NSTimer *timerVolume;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerTouch;
@property (nonatomic) NSInteger count;

@property (nonatomic) CGPoint startPoint;
@end



@implementation TSToolbarTextView



#pragma mark - Timer

- (void)initTimerVolume {
    [self invalidateTimerVolume];
    self.timerVolume = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateVolume) userInfo:nil repeats:YES];
}
- (void)invalidateTimerVolume {
    [self.timerVolume invalidate];
    self.timerVolume = nil;
}

- (void)updateVolume {
    if ([self.vTip isRecordingView] && !self.bCounting) {
        float decibels = [[TSAudioUitls sharedInstance] decibels];
        
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
    self.bCounting = YES;
    self.count = 10;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(counting) userInfo:nil repeats:YES];
}
- (void)counting {
    if (self.count == 0) {//倒计时结束，
        self.bEnd = YES;
        [self invalidateTimerVolume];
        [self invalidateTimer];
        [[TSAudioUitls sharedInstance] stop];
        
        [self.delegatets TSTextViewAddAudio:[[TSAudioUitls sharedInstance] filePath]];
        
        [self.vTip removeFromSuperview];
        self.vTip = nil;
        [self normalButtonState];
    }
    else {
        self.vTip.imageTip = [NSString stringWithFormat:@"%ld", (long)self.count];
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
        if ([[TSAudioUitls sharedInstance] record]) {
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
    if (self.tsState == TSTextViewStateButton && !self.bEnd) {
        [self invalidateTimerVolume];
        [self invalidateTimer];
        [self invalidateTimerTouch];
        
        [[TSAudioUitls sharedInstance] stop];
        
        UIView *vMain = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
        UITouch *touch = [touches anyObject];
        CGPoint txLocation = [touch locationInView:vMain];
        if ((self.startPoint.y - txLocation.y) > 60) {
            //删除录音
            [[TSAudioUitls sharedInstance] deleteRecording];
        }
        else {
            //当时间短于1秒时, 删除文件不保存
           
            if ((1 - [[TSAudioUitls sharedInstance] audioLength]) > 0) {
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
            [self.delegatets TSTextViewAddAudio:[[TSAudioUitls sharedInstance] filePath]];
        }
        
        [self.vTip removeFromSuperview];
        self.vTip = nil;
        [self normalButtonState];
        
        
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BOOL bCount = NO;
    if ([[TSAudioUitls sharedInstance] audioLength] - 50 > 0) {//如果录音长度超过50秒，开始倒计时
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
            self.vTip.imageTip = [NSString stringWithFormat:@"%ld", (long)self.count];
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








@end
