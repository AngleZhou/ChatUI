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
#define kTSTintColor [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1]


//其他颜色：线条，不可用等
#define HEXCOLORA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]
#define HEXCOLOR(rgbValue) HEXCOLORA(rgbValue, 1.0)
#define CTColorOther       HEXCOLOR(0xded8d7)



#define toolBarMinHeight 50

#define kTSScreenWidth [UIScreen mainScreen].bounds.size.width
#define kTSScreenHeight [UIScreen mainScreen].bounds.size.height
#define iconFont(size) [UIFont fontWithName:@"IconFont" size:size]

#define kTSHEIGHT4 480
#define kTSHEIGHT5 568
#define kTSHEIGHT6 667
#define kTSHEIGHT6S 736

#define QQMapKey @"X6HBZ-Q4H3X-2LF4L-ZOYG3-7QWTH-INFLA"

#define ______WS() __weak __typeof(&*self) wSelf = self
#define ______SS() __weak __typeof(&*wSelf) sSelf = wSelf
#define ______WX(x,y) __weak __typeof(&*x) y = x

#define kTSFontMain [UIFont systemFontOfSize:15]
#define kTSFontInputPluginCell [UIFont systemFontOfSize:13]
#define kTSFontRemark [UIFont systemFontOfSize:13]
#define kTSFontRemarkBold [UIFont boldSystemFontOfSize:13]
#define kTSFontEmoji [UIFont systemFontOfSize:33]
#define  kTSFontTip [UIFont systemFontOfSize:11]

#define amap_key        @"8a39b68b5d02c8ff4b7cd5595644f8cd"

static NSString *SENDCELL = @"SendCell";
static NSString *RECEIVECELL = @"ReceiveCell";
static NSString *TIMECELL = @"TimeCell";
static NSString *VOICECELL = @"VoiceCell";


static NSString *TalkCellContentTypeText = @"TalkCellContentTypeText";
static NSString *TalkCellContentTypeAudio = @"TalkCellContentTypeAudio";
static NSString *TalkCellContentTypeImage = @"TalkCellContentTypeImage";
static NSString *TalkCellContentTypeVideo = @"TalkCellContentTypeVideo";

#endif /* Constant_h */
