//
//  TSLocationVC.m
//  TalkShow
//
//  Created by ZhouQian on 16/4/5.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSLocationVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TSAnnotation.h"
#import "TSLocationCell.h"
#import <JZLocationConverter.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "TSCurrentLocation.h"

#define LocationCell @"TSLocationCell"


@interface TSLocationVC () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MAMapViewDelegate, AMapSearchDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSMutableArray *addresses;

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *mapSearch;
@property (nonatomic) CLLocationCoordinate2D coordinateCurrent;
@property (nonatomic, strong) MAPointAnnotation *annotation;
@end

@implementation TSLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStylePlain) target:self action:@selector(send)];
    self.navigationItem.title = @"位置";
    [self initGUI];
    
    CGFloat y = self.mapView.frame.origin.y + self.mapView.height;// + self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height;
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

- (void)initGUI {
    [MAMapServices sharedServices].apiKey = amap_key;
    [MAMapServices sharedServices].apiKey = amap_key;
    [AMapSearchServices sharedServices].apiKey = amap_key;
    
    CGFloat y = self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect rect = CGRectMake(0, y, kTSScreenWidth, kTSScreenHeight/2);
//    [QMapServices sharedServices].apiKey = QQMapKey;
    self.mapView = [[MAMapView alloc] initWithFrame:rect];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
//    [self initLocationManager];
    
//    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.mapType = MAMapTypeStandard;
//    self.mapView.showsUserLocation = YES;
    self.mapView.showsScale = YES;
    self.mapView.showsCompass = NO;
    [self.mapView setZoomLevel:15 animated:YES];
    self.mapView.scaleOrigin = CGPointMake(20, 22);
    
    ______WS();
    [[TSCurrentLocation sharedInstance] startUpdateLocation:^(CLLocation *currentLocation) {
        [wSelf.mapView setCenterCoordinate:currentLocation.coordinate animated:YES];
        [wSelf addAnnotation:currentLocation.coordinate];
    }];
    

    self.mapSearch = [[AMapSearchAPI alloc] init];
    self.mapSearch.delegate = self;
    
    
    self.geocoder = [[CLGeocoder alloc] init];
    self.addresses = [[NSMutableArray alloc] init];
}

#pragma mark - 添加大头针

- (void)addAnnotation:(CLLocationCoordinate2D)coordinate {
    if (!self.annotation) {
        self.annotation = [[MAPointAnnotation alloc] init];
    }
    self.annotation.coordinate = coordinate;
    self.annotation.title = @"Red";
    [self.mapView addAnnotation:self.annotation];
}


//#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
//
//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
//    if (updatingLocation) {
//        self.coordinateCurrent = userLocation.location.coordinate;
//        
//        
//        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
//        request.location = [AMapGeoPoint locationWithLatitude:self.coordinateCurrent.latitude longitude:self.coordinateCurrent.longitude];
//        request.sortrule = 0;
//        request.requireExtension = YES;
//        [self.mapSearch AMapPOIAroundSearch:request];
//        
//        CLLocationCoordinate2D wgs84 = [JZLocationConverter gcj02ToWgs84:self.coordinateCurrent];
//        MKUserLocation *location = [[MKUserLocation alloc] init];
//        location.coordinate = wgs84;
//        [self addCurrentAnnotation];
//        [self.locations removeAllObjects];
//        [self.locations addObject:location];
//        
//        if (self.tableView) {
//            [self.tableView reloadData];
//        }
//        NSLog(@"GCJ-02 经度：%f,纬度：%f",self.coordinateCurrent.longitude,self.coordinateCurrent.latitude);
//        
//        //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
//        //    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
//        //    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
//        //    [_mapView setRegion:region animated:true];
//    }
//    
//}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - CoreLocation delegate



#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
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
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    //反地理编码
    ______WS();
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSDictionary *dic = placemark.addressDictionary;
        NSLog(@"详细信息:%@",dic);
        
        if (dic) {
            [wSelf.addresses removeAllObjects];
            [wSelf.addresses addObject:dic];
            [wSelf.tableView reloadData];
        }
        
    }];
}


- (NSMutableArray *)locations {
    if (!_locations) {
        _locations = [[NSMutableArray alloc] init];
    }
    return _locations;
}

#pragma mark - 搜索附近的地址



#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCell];
    if (!cell) {
        cell = [[TSLocationCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:LocationCell];
    }
    MKUserLocation *location = self.locations[indexPath.row];
    [self getAddressByLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    if (self.addresses.count > 0) {
        NSDictionary *dic = self.addresses[indexPath.row];
        [cell setTitle:dic[@"Name"] subTitle:[dic[@"FormattedAddressLines"] firstObject]];
    }
    if (indexPath.row == 0) {
        cell.bChecked = YES;
    }
    return cell;
}





@end
