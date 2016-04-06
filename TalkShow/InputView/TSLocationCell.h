//
//  TSLocationCell.h
//  TalkShow
//
//  Created by ZhouQian on 16/4/5.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSLocationCell : UITableViewCell
@property (nonatomic, strong, nonnull) NSString *title;
@property (nonatomic, strong, nullable) NSString *subTitle;
@property (nonatomic) BOOL bChecked;
@end
