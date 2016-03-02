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


typedef NS_ENUM(NSInteger, TalkCellType) {
    TalkCellTypeReceived,
    TalkCellTypeSend
};


@interface TalkCell : UITableViewCell
@property (nonatomic) NSString *contentType;
@property (nonatomic) TalkCellType cellType;

@property (nonatomic, strong) UIImageView *vBubble;
@property (nonatomic, strong) TPMessageBubbleImage *msgBubbleImage;

- (instancetype)initWithType:(TalkCellType)type talkCellContentType:(NSString *)talkCellContentType;

@end
