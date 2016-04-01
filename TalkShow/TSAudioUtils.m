//
//  TSAudioUitls.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/31.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSAudioUtils.h"
#import "TSSave.h"
#import "TSAuthentication.h"



@interface TSAudioUtils ()  <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
@property (nonatomic, strong) NSURL *fileURL;

@end
@implementation TSAudioUtils

static long audioCount = 0;

#pragma mark - init

+ (instancetype)sharedInstance {
    static TSAudioUtils *audio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audio = [[TSAudioUtils alloc] initPrivate];
    });
    return audio;
}

- (instancetype)initPrivate {
    self = [super init];
    return self;
}
- (instancetype)init {
    return [TSAudioUtils sharedInstance];
}

- (BOOL)initAudio {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([TSAuthentication canRecord]) {
        NSError *error;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
        if (error) {
            NSLog(@"AVAudioSession setCategory error: %@", [error localizedDescription]);
            return NO;
        }
        return YES;
    }
    return NO;
}


#pragma mark - Actions

- (BOOL)record {
    if ([self initAudio]) {
        audioCount++;
        self.fileURL = [TSSave audioFileUrlWithFileName:[NSString stringWithFormat:@"audio%ld.m4a", (long)audioCount]];
        //define the recorder setting
        NSMutableDictionary *recordSetting = [@{AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                                AVSampleRateKey : @(44100.0),
                                                AVNumberOfChannelsKey : @2} mutableCopy];
        if (self.recorder) {
            [self.recorder stop];
            self.recorder = nil;
        }
        self.recorder = [[AVAudioRecorder alloc] initWithURL:self.fileURL settings:recordSetting error:nil];
        self.recorder.delegate = self;
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
        
        if ([self.player isPlaying]) {
            [self.player stop];
            NSLog(@"rate: %d", self.player.isPlaying);
        }
        if (![self.recorder isRecording]) {
            NSError *error;
            [[AVAudioSession sharedInstance] setActive:YES error:&error];
        }
        return [self.recorder record];
    }
    
    return NO;
}

- (AVAudioPlayer *)playerWithUrl:(NSURL *)url {
    self.fileURL = url;
    if (self.player) {
        [self.player stop];
        self.player = nil;
        NSLog(@"util player: %@", self.player);
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.fileURL error:nil];
    
    self.player.delegate = self;
    [self.player play];

    return self.player;
}

- (void)stopRecord {
    [self.recorder stop];
}
- (void)deleteRecording {
    [self.recorder deleteRecording];
}

- (float)decibels {
    [self.recorder updateMeters];
    return [self.recorder averagePowerForChannel: 0];
}
- (int)lengthOfUrl:(NSURL *)url {
    self.fileURL = url;
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:self.fileURL options:nil];
    CMTime audioDuration = audioAsset.duration;
    return (int)floor(CMTimeGetSeconds(audioDuration));
}
- (NSURL *)filePath {
    return self.fileURL;
}
- (void)setFileURL:(NSURL *)fileURL {
    _fileURL = fileURL;
}


+ (BOOL)usingHeadset
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif
    
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &propertySize, &route);
    
    BOOL hasHeadset = NO;
    if((route == NULL) || (CFStringGetLength(route) == 0))
    {
        // Silent Mode
    }
    else
    {
        /* Known values of route:
         * "Headset"
         * "Headphone"
         * "Speaker"
         * "SpeakerAndMicrophone"
         * "HeadphonesAndMicrophone"
         * "HeadsetInOut"
         * "ReceiverAndMicrophone"
         * "Lineout"
         */
        NSString* routeStr = (__bridge NSString*)route;
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        
        if (headphoneRange.location != NSNotFound)
        {
            hasHeadset = YES;
        }
        else if(headsetRange.location != NSNotFound)
        {
            hasHeadset = YES;
        }
    }
    
    if (route)
    {
        CFRelease(route);
    }
    
    return hasHeadset;
} 

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"%d, %d", player.isPlaying, flag);
    self.player = nil;
}

@end
