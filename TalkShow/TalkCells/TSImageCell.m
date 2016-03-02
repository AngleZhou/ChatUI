//
//  TSImageCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/2.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSImageCell.h"

@implementation TSImageCell

- (instancetype)initWithType:(TalkCellType)type talkCellContentType:(NSString *)talkCellContentType {
    self = [super initWithType:type talkCellContentType:TalkCellContentTypeImage];
    if (self) {
        
    }
    return self;
}

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;
    self.vBubble.image = [UIImage imageWithContentsOfFile:fileUrl.path];
}
@end
