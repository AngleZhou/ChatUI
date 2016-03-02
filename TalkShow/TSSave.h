//
//  TSSave.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/17.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSSave : NSObject
+ (NSURL *)audioFileUrlWithFileName:(NSString *)fileName;
+ (NSURL *)imageFileUrlWithFileName:(NSString *)fileName;

+ (NSURL *)saveImage:(UIImage *)image;
@end
