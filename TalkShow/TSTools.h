//
//  TSTools.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/26.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTools : NSObject
+ (UIImage *)imageFromIconFont:(NSString *)iconFontName;
+ (UILabel*)iconfontLabel:(NSString *)name size:(CGFloat)size;
@end
