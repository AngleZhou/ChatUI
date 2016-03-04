//
//  SFTagView.h
//  WrapViewWithAutolayout
//
//  Created by shiweifu on 12/9/14.
//  Copyright (c) 2014 shiweifu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFTag;

@interface SFTagView : UIView

//初始化的时候一定要设置width，不然算出的高度不对
@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) int lineSpace;
@property (nonatomic, assign) CGFloat insets; //tag之间的间隔 px

- (void)addTag:(SFTag *)tag;

- (void)removeAllTags;

- (void)removeTagText:(NSString *)text;
@end

