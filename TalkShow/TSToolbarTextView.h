//
//  TSTextView.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/17.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TSTextViewState) {
    TSTextViewStateNormal = 1,
    TSTextViewStateButton = 2
};


@protocol TSTextViewDelegate <NSObject>

@optional
- (void)TSTextViewAddAudio:(NSURL *)audioPath;
@end

@interface TSToolbarTextView : UITextView
@property (nonatomic) TSTextViewState tsState;

@property (nonatomic, weak) id<TSTextViewDelegate> delegatets;
@end
