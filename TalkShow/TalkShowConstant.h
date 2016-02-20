//
//  Constant.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/16.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


#define kTSSideX 8
#define kTSBubbleHeight 40
#define kTSBubbleTextXMargin 10
#define kTSBubbleTextYMargin 5
#define kTSScreenWidth [UIScreen mainScreen].bounds.size.width
#define iconFont(size) [UIFont fontWithName:@"IconFont" size:size]

#define ______WS() __weak __typeof(&*self) wSelf = self
#define ______SS() __weak __typeof(&*wSelf) sSelf = wSelf
#define ______WX(x,y) __weak __typeof(&*x) y = x

static UILabel* iconfontLabel(NSString *name, CGFloat size) {
    UILabel *label = [[UILabel alloc] init];
    label.font = iconFont(size);
    label.text = name;
    return label;
}


static NSString *SENDCELL = @"SendCell";
static NSString *RECEIVECELL = @"ReceiveCell";
static NSString *TIMECELL = @"TimeCell";
static NSString *VOICECELL = @"VoiceCell";
#endif /* Constant_h */
