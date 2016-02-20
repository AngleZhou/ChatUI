//
//  TSContentView.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/19.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TalkCellContentType) {
    TalkCellContentTypeText,
    TalkCellContentTypeAudio,
    TalkCellContentTypeImage,
    TalkCellContentTypeVideo
};

@interface TSContentView : UIView
@property (nonatomic) TalkCellContentType contentType;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSURL *fileUrl;
@end
