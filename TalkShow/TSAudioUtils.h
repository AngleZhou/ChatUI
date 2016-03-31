//
//  TSAudioUitls.h
//  TalkShow
//
//  Created by ZhouQian on 16/3/31.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TSAudioUtils : NSObject
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

+ (instancetype)sharedInstance;
- (BOOL)record;
- (void)stopRecord;
- (void)deleteRecording;

- (float)decibels;
- (int)lengthOfUrl:(NSURL *)url;
- (NSURL *)filePath;

- (void)playerWithUrl:(NSURL *)url;
@end
