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
@end



@implementation TSToolbarTextView

static NSInteger audioCount = 0;

//- (instancetype)init {
//    return [self initWithFrame:CGRectZero];
//}
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        _vTip = [[TSTipView alloc] init];
//    }
//    return self;
//}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tsState == TSTextViewStateButton) {
        self.backgroundColor = TouchDownColor;
        self.text = @"松开 结束";
        if (!self.vTip) {
            self.vTip = [[TSTipView alloc] init];
            self.vTip.tip = @"手指上滑，取消发送";
            self.vTip.image = [UIImage imageNamed:@"voice_volume0"];
            [self.vTip showInCenter];
        }
        
        [self initAudio];
        [self.recorder record];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tsState == TSTextViewStateButton) {
        self.backgroundColor = TouchUpColor;
        self.text = @"按住 说话";
        [self.vTip removeFromSuperview];
        self.vTip = nil;
        [self.recorder stop];
        [self.delegatets TSTextViewAddAudio:[TSSave audioFileUrlWithFileName:[NSString stringWithFormat:@"audio%ld.m4a", (long)audioCount]]];
    }
}

- (void)initAudio {
    audioCount++;
    NSURL *fileUrl = [TSSave audioFileUrlWithFileName:[NSString stringWithFormat:@"audio%ld.m4a", (long)audioCount]];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([TSAuthentication canRecord]) {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        
        //define the recorder setting
        NSMutableDictionary *recordSetting = [@{AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                                AVSampleRateKey : @(44100.0),
                                                AVNumberOfChannelsKey : @2} mutableCopy];
        self.recorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:recordSetting error:nil];
        self.recorder.delegate = self;
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
    }
}



@end
