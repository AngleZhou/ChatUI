//
//  TSImageCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/2.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSImageCell.h"
#import "UIImage+ThumbImage.h"
#import "UIView+ToImage.h"

@interface TSImageCell ()
@property (nonatomic, strong) UIImageView *imageContent;
@end

@implementation TSImageCell

- (instancetype)initWithType:(TalkCellType)type talkCellContentType:(NSString *)talkCellContentType {
    self = [super initWithType:type talkCellContentType:TalkCellContentTypeImage];
    if (self) {
        self.imageContent = [[UIImageView alloc] init];
        [self.vBubble addSubview:self.imageContent];
        ______WS();
        [self.imageContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(wSelf.vBubble);
            make.top.equalTo(wSelf.vBubble);
        }];
    }
    return self;
}

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;
    UIImage *image = [UIImage imageWithContentsOfFile:fileUrl.path];
    UIImage *thumbImage = [image getThumbImage];

    ______WS();
    
    [self.vBubble mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf).with.offset(kTSBubbleTextYMargin);
        make.size.mas_equalTo(thumbImage.size);
    }];
    [self layoutSubviews];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, thumbImage.size.width, thumbImage.size.height);
    maskLayer.contents = (__bridge id)[self.vBubble toImage].CGImage;
    self.imageContent.image = thumbImage;
    self.imageContent.layer.mask = maskLayer;
    
    [self.imageContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(thumbImage.size);
    }];
    self.height = thumbImage.size.height + kTSBubbleTextYMargin*2;
}
@end
