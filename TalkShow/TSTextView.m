//
//  TSTextView.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/17.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSTextView.h"
#import "TSSave.h"
#import <AVFoundation/AVFoundation.h>


#define TouchDownColor [UIColor grayColor]
#define TouchUpColor [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.1]

@interface TSTextView () <AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *recorder;
@end



@implementation TSTextView

static NSInteger audioCount = 0;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tsState == TSTextViewStateButton) {
        self.backgroundColor = TouchDownColor;
        self.text = @"松开 结束";
        [self initAudio];
        [self.recorder record];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.tsState == TSTextViewStateButton) {
        self.backgroundColor = TouchUpColor;
        self.text = @"按住 说话";
        [self.recorder stop];
        [self.delegatets TSTextViewAddAudio:[TSSave fileUrlWithFileName:[NSString stringWithFormat:@"audio%ld.m4a", (long)audioCount]]];
    }
}

- (void)initAudio {
    audioCount++;
    NSURL *fileUrl = [TSSave fileUrlWithFileName:[NSString stringWithFormat:@"audio%ld.m4a", (long)audioCount]];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
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

@end
