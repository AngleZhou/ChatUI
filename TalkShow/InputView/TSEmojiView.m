//
//  TSMojiView.m
//  TalkShow
//
//  Created by ZhouQian on 16/3/4.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSEmojiView.h"
#import "SFTagView.h"
#import "SFTag.h"

@interface TSEmojiView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *emojiViews;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation TSEmojiView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kTSScreenWidth, kTSInputPlugInViewHeight-44)];
        [self addSubview:self.scrollView];
        
        self.pageControl = [[UIPageControl alloc] init];
        [self addSubview:self.pageControl];
        
        NSArray *emojis = [self loadEmoji];
        NSInteger numInRow = [self emojiNumberOfItemInOneRow];
        NSInteger numInPage = numInRow*3-1;
        NSInteger numOfPages = emojis.count/numInPage;
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        CGFloat x = 0;
        for (int i=0; i<numOfPages; i++) {
            CGRect rect = CGRectMake(x, 0, kTSScreenWidth, kTSInputPlugInViewHeight-self.pageControl.height-44);
            SFTagView *vEmoji = [[SFTagView alloc] initWithFrame:rect];
            [self.scrollView addSubview:vEmoji];
            for (int j=0; j<numInPage; j++) {
                SFTag *emoji = [[SFTag alloc] init];
                emoji.text = emojis[i*numInPage+j];
                
            }
            vEmoji addTag:<#(SFTag *)#>
            x = x + kTSScreenWidth;
        }
        self.emojiView = [[SFTagView alloc] init];
        [self addSubview:self.emojiView];
        
        
    }
    return self;
}

- (NSArray *)loadEmoji {
    NSString *emojiPath = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@".plist"];
    return [NSArray arrayWithContentsOfFile:emojiPath];
}
- (NSInteger)emojiNumberOfItemInOneRow {
    if (kTSScreenHeight <= kTSHEIGHT5) {
        return 7;
    }
    else if (kTSScreenHeight <= kTSHEIGHT6) {
        return 8;
    }
    else if (kTSScreenHeight <= kTSHEIGHT6S) {
        return 9;
    }
}

@end
