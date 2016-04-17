//
//  TSLocationCell.h
//  TalkShow
//
//  Created by ZhouQian on 16/4/5.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSLocationCell : UITableViewCell
@property (nonatomic, strong, nonnull, readonly) NSString *title;
@property (nonatomic, strong, nullable, readonly) NSString *subTitle;
@property (nonatomic) BOOL bChecked;

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;
@end
