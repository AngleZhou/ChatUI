//
//  Constant.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/16.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


#define kTSSideX 16
#define kTSBubbleHeight 40
#define kTSBubbleTextXMargin 10
#define kTSBubbleTextYMargin 12

#define kTSTalkCellMaxWidth kTSScreenWidth*2/3

#define kTSAvataWidth 32

#define kTSInputPlugInViewHeight (kTSInputPluginCellWidth+20+12)*2+30
#define kTSInputPluginCellWidth 57

#define kTSInputPluginTextColor [UIColor grayColor]
#define kTSInputPluginViewBGColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]

#define toolBarMinHeight 50

#define kTSScreenWidth [UIScreen mainScreen].bounds.size.width
#define kTSScreenHeight [UIScreen mainScreen].bounds.size.height
#define iconFont(size) [UIFont fontWithName:@"IconFont" size:size]

#define kTSHEIGHT4 480
#define kTSHEIGHT5 568
#define kTSHEIGHT6 667
#define kTSHEIGHT6S 736



#define ______WS() __weak __typeof(&*self) wSelf = self
#define ______SS() __weak __typeof(&*wSelf) sSelf = wSelf
#define ______WX(x,y) __weak __typeof(&*x) y = x

#define kTSFontMain [UIFont systemFontOfSize:15]
#define kTSFontInputPluginCell [UIFont systemFontOfSize:13]
#define kTSFontRemark [UIFont systemFontOfSize:13]
#define kTSFontRemarkBold [UIFont boldSystemFontOfSize:13]
#define kTSFontEmoji [UIFont systemFontOfSize:33]

static NSString *SENDCELL = @"SendCell";
static NSString *RECEIVECELL = @"ReceiveCell";
static NSString *TIMECELL = @"TimeCell";
static NSString *VOICECELL = @"VoiceCell";


static NSString *TalkCellContentTypeText = @"TalkCellContentTypeText";
static NSString *TalkCellContentTypeAudio = @"TalkCellContentTypeAudio";
static NSString *TalkCellContentTypeImage = @"TalkCellContentTypeImage";
static NSString *TalkCellContentTypeVideo = @"TalkCellContentTypeVideo";

#endif /* Constant_h */
