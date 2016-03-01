//
//  TSInputPluginModel.h
//  TalkShow
//
//  Created by ZhouQian on 16/2/26.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ActionBlock)();

@interface TSInputPluginItem : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) ActionBlock action;
@end

@interface TSInputPluginModel : NSObject
+ (NSArray *)initInputPlugins;
@end
