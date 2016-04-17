//
//  TSCurrentLocation.m
//  TalkShow
//
//  Created by ZhouQian on 16/4/17.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSCurrentLocation.h"
#import <CoreLocation/CoreLocation.h>
#import <JZLocationConverter.h>
#import <INTULocationManager.h>

@interface TSCurrentLocation () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong, readwrite) NSString *address;
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@end

@implementation TSCurrentLocation

+ (instancetype)sharedInstance {
    static TSCurrentLocation *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initPrivate];
    });
    return manager;
}

- (instancetype)initPrivate {
    self = [super init];
    return self;
}

- (void)startUpdateLocation:(void(^)(CLLocation *currentLocation))callback {
//    self.geocoder = [[CLGeocoder alloc] init];
//    _locationManager = [[CLLocationManager alloc] init];
//    if (![CLLocationManager locationServicesEnabled]) {
//        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
//        [[[UIAlertView alloc] initWithTitle:nil message:@"定位服务当前可能尚未打开，请设置打开" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return;
//    }
//    //如果没有授权请求用户授权
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
//        [self.locationManager requestWhenInUseAuthorization];
//    }
//    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        self.locationManager.delegate = self;
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        CLLocationDistance distance = 10.0;//十米定位一次
//        self.locationManager.distanceFilter = distance;
//        [self.locationManager startUpdatingLocation];
//    }

    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:(INTULocationAccuracyHouse) timeout:5.0 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        if (status == INTULocationStatusServicesDisabled || status == INTULocationStatusServicesDenied) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"定位服务当前可能尚未打开，请设置打开" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
            [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber* x) {
                if (x.integerValue == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                }
            }];
            return;
        }
        
        [TSCurrentLocation sharedInstance].coordinate = currentLocation.coordinate;
        
        //geocoding
        CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
        [reverseGeocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error){
            
            if (error){
                return;
            }
            
            CLPlacemark *placemark=[placemarks firstObject];
            NSDictionary *dic = placemark.addressDictionary;
            NSLog(@"详细信息:%@",dic);
            [TSCurrentLocation sharedInstance].address = dic[@"FormattedAddressLines"];
            [TSCurrentLocation sharedInstance].name = placemark.name;

        }];
        
        if (callback) {
            callback(currentLocation);
        }
    }];
}



#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location=[locations firstObject];//取出第一个位置
    if (!self.bChinese) {
        self.coordinate = location.coordinate;//位置坐标
    }
    else {
        CLLocationCoordinate2D wgs84 = [JZLocationConverter gcj02ToWgs84:location.coordinate];
        self.coordinate = wgs84;
    }

    [self.locationManager stopUpdatingLocation];
}



@end
