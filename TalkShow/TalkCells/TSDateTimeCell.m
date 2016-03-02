//
//  TSDateTimeCell.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/17.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSDateTimeCell.h"
#import "NSDate+MessgeCellDescription.h"

@interface TSDateTimeCell ()
@property (nonatomic, strong) UILabel *lblText;
@end

@implementation TSDateTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.lblText = [[UILabel alloc] init];
        self.lblText.font = [UIFont systemFontOfSize:13];
        self.lblText.textColor = [UIColor whiteColor];
        self.lblText.backgroundColor = [UIColor blackColor];
        self.lblText.alpha = 0.3;
        self.lblText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lblText];
        
        ______WS();
        [self.lblText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(wSelf);
            make.centerY.equalTo(wSelf);
        }];
    }
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate {
    _currentDate = currentDate;
    
    NSDate *today = [NSDate date];
    NSTimeInterval duration = [today timeIntervalSinceDate:currentDate];
    BOOL fullDate = (duration/(3600*24) >= 1);
    
    //一天之内，只显示时间
    NSString *dateString = [NSDate ts_desciptionOfDate:currentDate fullDate:fullDate];
    
    self.lblText.text = dateString;
    [self.lblText sizeToFit];
    CGSize size = self.lblText.frame.size;
    [self.lblText mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}

@end
