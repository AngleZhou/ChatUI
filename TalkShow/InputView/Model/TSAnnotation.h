//
//  TSAnnotation.h
//  TalkShow
//
//  Created by ZhouQian on 16/4/5.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TSAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
