//
//  TSCurrentLocation.h
//  TalkShow
//
//  Created by ZhouQian on 16/4/17.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSCurrentLocation : NSObject
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic) BOOL bChinese;

+ (instancetype)sharedInstance;
- (void)startUpdateLocation:(void(^)(CLLocation *currentLocation))callback;
@end
