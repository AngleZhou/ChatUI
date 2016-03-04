//
// Created by shiweifu on 12/9/14.
// Copyright (c) 2014 shiweifu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFTag : NSObject

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic) BOOL bCheck;

@property (nonatomic, strong) NSString *category;

@property (nonatomic) CGFloat textToBorderX;
@property (nonatomic) CGFloat textToBorderY;

@property (nonatomic) CGFloat borderWidth;
//上下左右的缝隙
//@property (nonatomic) CGFloat inset;

@property (nonatomic, strong) id target;

@property (nonatomic) SEL action;

- (instancetype)initWithText:(NSString *)text;

+ (instancetype)tagWithText:(NSString *)text;


@end
