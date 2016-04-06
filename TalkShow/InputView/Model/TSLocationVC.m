//
//  TSLocationVC.m
//  TalkShow
//
//  Created by ZhouQian on 16/4/5.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSLocationVC.h"
#import <MapKit/MapKit.h>
//#import <QMapKit/QMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TSAnnotation.h"
#import "TSLocationCell.h"

#define LocationCell @"TSLocationCell"


@interface TSLocationVC () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D coordinateCurrent;
@property (nonatomic, strong) TSAnnotation *annotation;
@end

@implementation TSLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)dealloc {
    [self.locationManager stopUpdatingLocation];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStylePlain) target:self action:@selector(send)];
    self.navigationItem.title = @"位置";
    [self initGUI];
    
    CGFloat y = self.mapView.height;// + self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect rect = CGRectMake(0, y, kTSScreenWidth, kTSScreenHeight-y);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TSLocationCell class] forCellReuseIdentifier:LocationCell];
    [self.view addSubview:self.tableView];
    
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)send {
    //TODO: 添加数据
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)initLocationManager {
    self.geocoder = [[CLGeocoder alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        [[[UIAlertView alloc] initWithTitle:nil message:@"定位服务当前可能尚未打开，请设置打开" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    //如果没有授权请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        CLLocationDistance distance = 10.0;//十米定位一次
        self.locationManager.distanceFilter = distance;
        [self.locationManager startUpdatingLocation];
    }
}

- (void)initGUI {
    CGRect rect = CGRectMake(0, 0, kTSScreenWidth, kTSScreenHeight/2);
//    [QMapServices sharedServices].apiKey = QQMapKey;
    self.mapView = [[MKMapView alloc] initWithFrame:rect];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    [self initLocationManager];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
}

#pragma mark - 添加大头针

- (void)addCurrentAnnotation {
    if (!self.annotation) {
        self.annotation = [[TSAnnotation alloc] init];
    }
    self.annotation.coordinate = self.coordinateCurrent;
    self.annotation.title = @"Red";
    [self.mapView addAnnotation:self.annotation];
}


#pragma mark - 地图控件代理方法

//- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
//    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
//        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
//        QPinAnnotationView *annotationView = (QPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
//        
//        if (annotationView == nil)
//        {
//            annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
//        }
//        
//        annotationView.animatesDrop     = YES;
//        annotationView.draggable        = YES;
//        annotationView.canShowCallout   = YES;
//        
//        annotationView.pinColor = [self.mapView.annotations indexOfObject:annotation];
//        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        return annotationView;
//    }
//    return nil;
//}

#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.coordinateCurrent = userLocation.location.coordinate;
    [self addCurrentAnnotation];
    [self.locations removeAllObjects];
    [self.locations addObject:userLocation];
    
    if (self.tableView) {
        [self.tableView reloadData];
    }
    NSLog(@"GCJ-02 经度：%f,纬度：%f",self.coordinateCurrent.longitude,self.coordinateCurrent.latitude);
    
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //    [_mapView setRegion:region animated:true];
}


#pragma mark - CoreLocation delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location=[locations firstObject];//取出第一个位置
    self.coordinateCurrent = location.coordinate;//位置坐标
    NSLog(@"WGS-84 经度：%f,纬度：%f",self.coordinateCurrent.longitude,self.coordinateCurrent.latitude);
}

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSDictionary *dic = placemark.addressDictionary;
        NSLog(@"详细信息:%@",placemark.addressDictionary);
    }];
}


- (NSMutableArray *)locations {
    if (!_locations) {
        _locations = [[NSMutableArray alloc] init];
    }
    return _locations;
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCell];
    if (!cell) {
        cell = [[TSLocationCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:LocationCell];
    }
    MKUserLocation *location = self.locations[indexPath.row];
    [self getAddressByLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    if (indexPath.row == 0) {
        cell.bChecked = YES;
    }
    return cell;
}

@end
