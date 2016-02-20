//
//  TalkCell.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/16.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPMessageBubble.h"
#import "UIImage+TPMessgeBubble.h"

typedef NS_ENUM(NSInteger, TalkCellContentType) {
    TalkCellContentTypeText,
    TalkCellContentTypeAudio,
    TalkCellContentTypeImage,
    TalkCellContentTypeVideo
};


@interface TalkCell : UITableViewCell
@property (nonatomic) TalkCellContentType contentType;

@property (nonatomic, strong) UIImageView *vBubble;
@property (nonatomic, strong) UIView *vContent;
@property (nonatomic, strong) TPMessageBubbleImage *msgBubbleImage;
@property (nonatomic, strong) UILabel *lblVoiceLength;
@property (nonatomic, strong) UIImageView *vSound;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSURL *fileUrl;
@end
