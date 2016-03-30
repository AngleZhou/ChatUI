//
//  TSTipView.h
//  TalkShow
//
//  Created by ZhouQian on 16/3/21.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSTipView : UIView
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageTip;

+ (instancetype)sharedInstance;
- (void)showInCenter;

- (void)recordingView;
- (void)cancelRecordingView;
- (void)recordTooShortView;

- (BOOL)isCancelRecordingView;
- (BOOL)isRecordingView;
@end
