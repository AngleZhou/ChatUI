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


@interface TSEmojiView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *emojiViews;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *btnSend;
@end

@implementation TSEmojiView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, kTSScreenHeight, kTSScreenWidth, kTSInputPlugInViewHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        ______WS();
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kTSScreenWidth, kTSInputPlugInViewHeight-44-10)];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        
        NSArray *emojis = [self loadEmoji];
        NSInteger numInRow = [self emojiNumberOfItemInOneRow];
        NSInteger numInPage = numInRow*3-1;
        NSInteger numOfPages = emojis.count/numInPage;
        CGFloat inset = [self emojiItenInset];
        CGFloat x = 0;
        CGFloat width = inset * (numInRow+1) + numInRow * 35;
        CGFloat xPadding = (kTSScreenWidth - width)/2;
        for (int i=0; i<numOfPages; i++) {
            CGRect rect = CGRectMake(x, 0, kTSScreenWidth, kTSInputPlugInViewHeight-self.pageControl.height-44);
            SFTagView *vEmoji = [[SFTagView alloc] initWithFrame:rect];
            vEmoji.insets = inset;
            vEmoji.lineSpace = inset;
            vEmoji.margin = UIEdgeInsetsMake(16, xPadding, 16-inset, xPadding);//top left bottom right
            [self.scrollView addSubview:vEmoji];
            for (int j=0; j<numInPage; j++) {
                SFTag *emoji = [[SFTag alloc] init];
                emoji.text = emojis[i*numInPage+j];
                emoji.font = kTSFontEmoji;
                emoji.size = CGSizeMake(35, 35);
                emoji.action = @selector(addEmoji:);
                [vEmoji addTag:emoji];
            }
            SFTag *btnEmojiDelete = [[SFTag alloc] init];
            btnEmojiDelete.image = [UIImage imageNamed:@"emoji_btn_delete"];
            btnEmojiDelete.imageInsets = UIEdgeInsetsMake(6, 0, 6, 0);//top left bottom right
            btnEmojiDelete.size = CGSizeMake(35, 35);
            btnEmojiDelete.action = @selector(deleteEmoji);
            [vEmoji addTag:btnEmojiDelete];
            
            x = x + kTSScreenWidth;
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width * numOfPages, self.scrollView.height);
        
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = numOfPages;
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(wSelf.scrollView.mas_bottom);
            make.leading.equalTo(wSelf);
            make.trailing.equalTo(wSelf);
            make.height.mas_equalTo(10);
        }];
        
        
        self.bottomBar = [[UIView alloc] init];
        self.bottomBar.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:self.bottomBar];
        [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(wSelf);
            make.trailing.equalTo(wSelf);
            make.top.equalTo(wSelf.pageControl.mas_bottom).with.offset(10);
            make.bottom.equalTo(wSelf);
        }];
        
        self.btnSend = [[UIButton alloc] init];
        self.btnSend.titleLabel.font = kTSFontMain;
        [self.bottomBar addSubview:self.btnSend];
        [self.btnSend setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        [self.btnSend setTitle:@"发送" forState:UIControlStateNormal];
        [self.btnSend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnSend.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);//top left bottom right
        [[[self.btnSend rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            if ([wSelf.delegate respondsToSelector:@selector(TSEmojiViewSendButtonTapped)]) {
                [wSelf.delegate TSEmojiViewSendButtonTapped];
            }
        }];
        CGSize size = [self.btnSend.titleLabel.text textSizeWithFont:self.btnSend.titleLabel.font constrainedToSize:CGSizeMake(kTSScreenWidth, 44) lineBreakMode:(NSLineBreakByTruncatingTail)];
        [self.btnSend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(wSelf.bottomBar);
            make.top.equalTo(wSelf.bottomBar);
            make.bottom.equalTo(wSelf.bottomBar);
            make.width.mas_equalTo(size.width+20);
        }];
    }
    return self;
}

- (void)addEmoji:(UIButton *)button {
    NSString *text = button.titleLabel.text;
    if ([self.delegate respondsToSelector:@selector(TSEmojiView:emoji:)]) {
        [self.delegate TSEmojiView:self emoji:text];
    }
}
- (void)deleteEmoji {
    if ([self.delegate respondsToSelector:@selector(TSEmojiViewDeleteLast)]) {
        [self.delegate TSEmojiViewDeleteLast];
    }
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
    else {
        return 9;
    }
}
- (CGFloat)emojiItenInset {
    if (kTSScreenHeight <= kTSHEIGHT5) {
        return 6;
    }
    else if (kTSScreenHeight <= kTSHEIGHT6) {
        return 8;
    }
    else {
        return 10;
    }
}

- (void)sendButtonHighlighted:(BOOL)highlight {
    if (highlight) {
        [self.btnSend setBackgroundColor:[UIColor colorWithRed:0 green:128/255.0 blue:255/255.0 alpha:1]];
        [self.btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        [self.btnSend setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        [self.btnSend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = self.scrollView.width;
    CGFloat xPostion = scrollView.contentOffset.x;
    
    self.pageControl.currentPage = xPostion/width;
}

@end
