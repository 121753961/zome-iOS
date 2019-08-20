//
//  ZMMapsShowController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/12.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMMapsShowController.h"
#import <GoogleMaps/GMSGeocoder.h>
#import <GooglePlaces/GooglePlaces.h>

@interface ZMMapsShowController ()



//就是CoreLocation框架下的地理位置管理类
@property (nonatomic, strong) CLLocationManager *loacationManager;

@end

@implementation ZMMapsShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _loacationManager = [[CLLocationManager alloc] init];
    // 请求前台定位权限
    [_loacationManager requestWhenInUseAuthorization];
    
    // 23.132928  113.270378
    NSString *latitudeStr = [[ZMAppInfomationSingleton sharedInstance] getCurrLatitude];
    CGFloat latitude = latitudeStr ? [latitudeStr floatValue] : 23.132928;
    
    NSString *longitudeStr = [[ZMAppInfomationSingleton sharedInstance] getCurrLongitude];
    CGFloat longitude = longitudeStr ? [longitudeStr floatValue] : 113.270378;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:13];
    _googleMapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    _googleMapView.delegate = self;
    _googleMapView.settings.rotateGestures = NO;
    _googleMapView.settings.tiltGestures = NO;
    _googleMapView.myLocationEnabled = NO;
    self.view = _googleMapView;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
