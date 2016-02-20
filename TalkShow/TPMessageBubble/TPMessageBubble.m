//
//  TPMessageBubble.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/18.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TPMessageBubble.h"
#import "UIImage+TPMessgeBubble.h"
#import "UIColor+DarkerLighter.h"

#define MsgSendBubbleColor [UIColor colorWithRed:102/255.0 green:204/255.0 blue:255/255.0 alpha:1]
#define MsgReceivedBubbleColor [UIColor grayColor]


@implementation TPMessageBubbleImage

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(nullable UIImage *)highlightedImage {
    self = [super init];
    if (self) {
        _image = image;
        _highlightedImage = highlightedImage;
    }
    return self;
}

@end




@interface TPMessageBubble ()
@property (nonatomic, strong) UIImage *baseImage;
@property (nonatomic) UIEdgeInsets capInset;
@end

@implementation TPMessageBubble

- (instancetype)init {
    UIImage *image = [UIImage imageNamed:@"chat_from_bg_normal"];
    return [self initWithImage:image capInset:UIEdgeInsetsZero];
}

- (instancetype)initWithImage:(UIImage *)image capInset:(UIEdgeInsets)capInset {
    self = [super init];
    if (self) {
        _baseImage = image;
        if (UIEdgeInsetsEqualToEdgeInsets(capInset, UIEdgeInsetsZero)) {
            _capInset = [self ts_centerPointEdgeInsetsForImageSize:image.size];
        }
        else {
            _capInset = capInset;
        }
    }
    return self;
}

- (UIEdgeInsets)ts_centerPointEdgeInsetsForImageSize:(CGSize)size {
    // make image stretchable from center point
    CGPoint center = CGPointMake(size.width / 2.0f, size.height / 2.0f);
    return UIEdgeInsetsMake(center.y, center.x, center.y, center.x);
}

- (TPMessageBubbleImage *)tpMsgSendBubble {
    return [self tpMsgBubbleWithColor:MsgSendBubbleColor flipped:YES];
}

- (TPMessageBubbleImage *)tpMsgReceivedBubble {
    return [self tpMsgBubbleWithColor:MsgReceivedBubbleColor flipped:NO];
}

- (TPMessageBubbleImage *)tpMsgBubbleWithColor:(UIColor *)color flipped:(BOOL)flipped {
    UIImage *normalImage = [UIImage tp_maskedImage:self.baseImage WithColor:color];
    UIImage *highlightedImage = [UIImage tp_maskedImage:self.baseImage WithColor:[UIColor darkerColorForColor:color]];
    if (flipped) {
        normalImage = [UIImage tp_horizontallyFlippedFromImage:normalImage];
        highlightedImage = [UIImage tp_horizontallyFlippedFromImage:highlightedImage];
    }
    
    normalImage = [UIImage tp_stretchableImage:normalImage WithCapInsets:self.capInset];
    highlightedImage = [UIImage tp_stretchableImage:highlightedImage WithCapInsets:self.capInset];
    
    return [[TPMessageBubbleImage alloc] initWithImage:normalImage highlightedImage:highlightedImage];
}

@end
