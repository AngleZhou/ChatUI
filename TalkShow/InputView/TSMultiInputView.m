//
//  TSMultiInputView.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/19.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSMultiInputView.h"
#import "TSInputPluginCell.h"
#import "TSInputPluginModel.h"

#define TSInputPlugInViewHeight (kTSInputPluginCellWidth+20+12)*2+30

@interface TSMultiInputView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *pluginItems;
@end

@implementation TSMultiInputView

- (instancetype)init {
    CGRect rect = CGRectMake(0, kTSScreenHeight, kTSScreenWidth, TSInputPlugInViewHeight);
    return [self initWithFrame:rect];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(0, 0, self.width, self.height);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemSpacing = (kTSScreenWidth - 4*kTSInputPluginCellWidth)/5;
        layout.minimumInteritemSpacing = itemSpacing;
        layout.sectionInset = UIEdgeInsetsMake(12, itemSpacing, 0, itemSpacing);
        layout.itemSize = CGSizeMake(kTSInputPluginCellWidth, kTSInputPluginCellWidth+20);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = kTSInputPluginViewBGColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.collectionView registerClass:[TSInputPluginCell class] forCellWithReuseIdentifier:@"InputPluginCell"];
        [self addSubview:_collectionView];
        ______WS();
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(wSelf);
        }];
        
        self.pluginItems = [TSInputPluginModel initInputPlugins];
    }
    return self;
}


#pragma mark - Animations



#pragma mark - CollectionView 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pluginItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"InputPluginCell";
    TSInputPluginCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[TSInputPluginCell alloc] initWithFrame:CGRectMake(0, 0, kTSInputPluginCellWidth, kTSInputPluginCellWidth)];
    }
    cell.item = self.pluginItems[indexPath.row];
    return cell;
}



@end
