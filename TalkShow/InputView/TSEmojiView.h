//
//  TSMojiView.h
//  TalkShow
//
//  Created by ZhouQian on 16/3/4.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSEmojiView;

@protocol TSEmojiViewDelegate <NSObject>

- (void)TSEmojiView:(TSEmojiView *)vEmoji emoji:(NSString *)emoji;
- (void)TSEmojiViewDeleteLast;
- (void)TSEmojiViewSendButtonTapped;

@end

@interface TSEmojiView : UIView
@property (nonatomic, weak) id<TSEmojiViewDelegate> delegate;

- (void)sendButtonHighlighted:(BOOL)highlight;
@end
