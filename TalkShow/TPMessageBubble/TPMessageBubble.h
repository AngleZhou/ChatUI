//
//  TPMessageBubble.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/18.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TPMessageBubbleImage : NSObject
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) UIImage *highlightedImage;
@end



@interface TPMessageBubble : NSObject
- (TPMessageBubbleImage *)tpMsgSendBubble;
- (TPMessageBubbleImage *)tpMsgReceivedBubble;
@end
