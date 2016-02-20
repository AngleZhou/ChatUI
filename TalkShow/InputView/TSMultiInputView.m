//
//  TSMultiInputView.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/19.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSMultiInputView.h"

@interface TSMultiInputView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation TSMultiInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(0, 0, self.width, self.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame];
    }
    return self;
}
@end
