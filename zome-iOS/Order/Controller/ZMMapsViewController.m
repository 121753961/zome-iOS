//
//  ZMMapsViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/8.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMMapsViewController.h"

// googleMaps
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleMaps/GMSGeocoder.h>
#import <GooglePlaces/GooglePlaces.h>
#import "ZMMapNavView.h"
#import "ZMMapLocationView.h"
#import "UIView+ZMUtil.h"
#import "ZMTimeTodayViewController.h"
#import "ZMMapsDropdownView.h"
#import "ZMMapsShowController.h"
#import "AFNetworking.h"
#import "ZMAutocompleteViewController.h"
#import "ZMLocation.h"


@interface ZMMapsViewController ()
<
GMSMapViewDelegate,
ZMMapLocationViewDelegate,
ZMMapsDropdownViewDelegate,
ZMAutocompleteViewDelegate,
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UIView *mapsView;



//最主要的地图类
@property (nonatomic, strong) GMSMapView *googleMapView;

//就是CoreLocation框架下的地理位置管理类
@property (nonatomic, strong) CLLocationManager *loacationManager;
@property (nonatomic, strong) ZMMapNavView *mapNavView;
@property (nonatomic, strong) ZMMapLocationView *mapLocationView;
@property (nonatomic, strong) GMSMarker *marker;
@property (nonatomic, strong) UIButton *barBtn;
@property (nonatomic, strong) UIButton *centerBtn;
@property (nonatomic, strong) UILabel *centerBtnTopLabel;
@property (nonatomic, strong) UIButton *centerBtnTopBtn;
@property (nonatomic, strong) UITextField *startLocationTextField;
@property (nonatomic, strong) ZMMapsDropdownView *mapsDropdownView;

/** *  起始位置 */
@property (nonatomic, assign) CLLocationCoordinate2D startLocation2D;
@property (nonatomic, strong) GMSMarker *startMarker;

/** *  终点位置 */
@property (nonatomic, assign) CLLocationCoordinate2D endLocation2D;
@property (nonatomic, copy) NSString *endCurrLocationStr;
@property (nonatomic, strong) GMSMarker *endMarker;


@property (nonatomic, strong) GMSPolyline *polyline;

/** *  1:起始位置   2:终点位置 */
@property (nonatomic, assign) NSInteger inputStart;



@end

@implementation ZMMapsViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inputStart = 1;
    
    
    ZMMapsShowController *testVC = [[ZMMapsShowController alloc] init];
    testVC.view.frame = self.view.bounds;
    testVC.googleMapView.delegate = self;
    self.googleMapView = testVC.googleMapView;
    
    [self.view addSubview:testVC.view];
    
    [self addMapNavView];
    
    [self addMapLocationView];
    
    if(self.goTripType == 2){
        self.gotripDetail = [[ZMOrderGotripDetail alloc] init];
        self.gotripDetail.fromLongitude = self.tripDetail.toLongitude;
        self.gotripDetail.fromLatitude = self.tripDetail.toLongitude;
        self.gotripDetail.fromAddr = self.tripDetail.toAddr;
        self.mapLocationView.currLocationTextField.text = self.tripDetail.toAddr;
        
        self.gotripDetail.toLongitude = self.tripDetail.fromLongitude;
        self.gotripDetail.toLatitude = self.tripDetail.fromLatitude;
        self.gotripDetail.toAddr = self.tripDetail.fromAddr;
        self.mapLocationView.destinationTextField.text = self.tripDetail.fromAddr;
    }else if (self.goTripType == 3){
        self.mapLocationView.currLocationTextField.text = self.gotripDetail.fromAddr;
        self.mapLocationView.destinationTextField.text = self.gotripDetail.toAddr;
    }else{
        self.gotripDetail = [[ZMOrderGotripDetail alloc] init];
    }
    
    
//    self.googleMapView.camera = camera;
    [[ZMLocation sharedLocation] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if(likelihoodList != nil){
            GMSPlace *place = [[[likelihoodList likelihoods] lastObject] place];
            if(place != nil){
                NSLog(@"place === %@",place);
                GMSCameraPosition *camera = [GMSCameraPosition
                                             cameraWithLatitude:place.coordinate.latitude
                                             longitude:place.coordinate.longitude
                                             zoom:13
                                             ];
                self.googleMapView.camera = camera;
            }
        }
    }];
    
}



-(void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    ZMLog(@"%@",position);
    if (self.inputStart == 1) {
        self.startLocation2D = position.target;
    }else if (self.inputStart == 2){
        self.endLocation2D = position.target;
    }
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:position.target completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (response.results) {
            GMSAddress *address = response.results[0];
            NSLog(@"%@",address.thoroughfare);
            if (!IsStrEmpty(address.thoroughfare)) {
                self.centerBtnTopLabel.text = [NSString stringWithFormat:@"%@", address.thoroughfare];
            }
        }
    }];
}



- (IBAction)backActon:(id)sender {
    [self backAction];
}

-(void)addMapNavView{
    ZMMapNavView *view = [[ZMMapNavView alloc] myMapNavView];
    self.mapNavView = view;
    [self.view addSubview:self.mapNavView];
    [self.mapNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(40));
        make.top.equalTo(self.view).offset(30);
    }];
    [self.mapNavView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mapNavView.closeBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *barBtn = [[UIButton alloc] init];
    self.barBtn = barBtn;
    [self.barBtn setImage:[UIImage imageNamed:@"action_bar"] forState:UIControlStateNormal];
    [self.barBtn addTarget:self action:@selector(barBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.barBtn];
    [self.barBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.equalTo(@(55));
        make.height.equalTo(@(55));
    }];
    
}

-(void)addMapLocationView{
    ZMMapLocationView *view = [[ZMMapLocationView alloc] myMapLocationView];
    self.mapLocationView = view;
    self.mapLocationView.delegate = self;
    self.mapLocationView.currLocationTextField.delegate = self;
    self.mapLocationView.destinationTextField.delegate = self;
    [self.mapLocationView setCornerRadius:5.f];
    [self.view addSubview:self.mapLocationView];
    [self.mapLocationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@(100));
        make.top.equalTo(self.mapNavView.mas_bottom).offset(10);
    }];
    
    
    
    self.mapsDropdownView = [[ZMMapsDropdownView alloc] myMapDropdownView];
    [self.mapsDropdownView setCornerRadius:5.f];
    self.mapsDropdownView.delegate = self;
    [self.view addSubview:self.mapsDropdownView];
    self.mapsDropdownView.hidden = YES;
    [self.mapsDropdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@(150));
        make.top.equalTo(self.mapLocationView.mas_bottom).offset(10);
    }];
    
    self.centerBtn = [[UIButton alloc] init];
    [self.centerBtn setImage:[UIImage imageNamed:@"pickuppin"] forState:UIControlStateNormal];
    self.centerBtn.hidden = YES;
    [self.view addSubview:self.centerBtn];
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(30));
        make.height.equalTo(@(40));
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    self.centerBtnTopLabel = [[UILabel alloc] init];
    self.centerBtnTopLabel.hidden = YES;
    [self.view addSubview:self.centerBtnTopLabel];
    self.centerBtnTopLabel.text = @"Loction";
    self.centerBtnTopLabel.backgroundColor = [UIColor whiteColor];
    
    [self.centerBtnTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30));
        make.bottom.equalTo(self.centerBtn.mas_top);
        make.centerX.equalTo(self.centerBtn.mas_centerX);
    }];
    
    self.centerBtnTopBtn = [[UIButton alloc] init];
    self.centerBtnTopBtn.hidden = YES;
    [self.centerBtnTopBtn addTarget:self action:@selector(centerBtnTopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.centerBtnTopBtn];
    [self.centerBtnTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerBtnTopLabel.mas_top);
        make.bottom.equalTo(self.centerBtnTopLabel.mas_bottom);
        make.left.equalTo(self.centerBtnTopLabel.mas_left);
        make.right.equalTo(self.centerBtnTopLabel.mas_right);
    }];
}

// 点击图标顶部Label 事件
-(void)centerBtnTopBtnAction:(UIButton *)btn{
    if (self.inputStart == 1) {
        ZMLog(@"起始位置");
        self.mapLocationView.currLocationTextField.text = self.centerBtnTopLabel.text;
        [self textEnabledanimations:11];
        [self.mapLocationView.currLocationTextField resignFirstResponder];
        
        self.gotripDetail.fromAddr = self.centerBtnTopLabel.text;
        self.gotripDetail.fromLatitude = [NSString stringWithFormat:@"%f",self.startLocation2D.latitude];
        self.gotripDetail.fromLongitude = [NSString stringWithFormat:@"%f",self.startLocation2D.longitude];
        
        [self drawStartLocactionMarker:self.startLocation2D];
    }else if (self.inputStart == 2){
        ZMLog(@"终点位置");
        self.mapLocationView.destinationTextField.text = self.centerBtnTopLabel.text;
        [self textEnabledanimations:12];
        [self.mapLocationView.destinationTextField resignFirstResponder];
        [self drawEndLocactionMarker:self.endLocation2D];
        self.centerBtn.hidden = YES;
        self.centerBtnTopLabel.hidden = YES;
        self.centerBtnTopBtn.hidden = YES;
        
        self.gotripDetail.toAddr = self.centerBtnTopLabel.text;
        self.gotripDetail.toLatitude = [NSString stringWithFormat:@"%f",self.endLocation2D.latitude];
        self.gotripDetail.toLongitude = [NSString stringWithFormat:@"%f",self.endLocation2D.longitude];
        
//        [self calculateRoutesFrom:self.startLocation2D to:self.endLocation2D];
        [self addPolayLineFrom:self.startLocation2D to:self.endLocation2D];
    }
    ZMLog(@"%@",self.centerBtnTopLabel.text);
}

#pragma mark 画起始位置的 Marker
-(void)drawStartLocactionMarker:(CLLocationCoordinate2D)startLoc{
    self.startMarker.map = nil;
    self.startMarker = [GMSMarker markerWithPosition:startLoc];
    CGRect frame = CGRectMake(0, 0, 30, 40);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"pickuppin"];
    self.startMarker.iconView = imageView;
    self.endMarker.title = self.mapLocationView.currLocationTextField.text;
    self.startMarker.map = self.googleMapView;
}

#pragma mark 画终点位置的 Marker
-(void)drawEndLocactionMarker:(CLLocationCoordinate2D)EndLoc{
    self.endMarker.map = nil;
    self.endMarker = [GMSMarker markerWithPosition:EndLoc];
    CGRect frame = CGRectMake(0, 0, 30, 40);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"destinationPin"];
    self.endMarker.iconView = imageView;
    self.endMarker.title = self.mapLocationView.destinationTextField.text;
    self.endMarker.map = self.googleMapView;
}

#pragma  mark ZMMapLocationViewDelegate
-(void)mapLocationView:(ZMMapLocationView *)vc startBtnAction:(UIButton *)btn{
//    self.centerBtn.hidden = NO;
//    self.centerBtnTopLabel.hidden = NO;
//    self.centerBtnTopBtn.hidden = NO;
    [self gotoAutocompleteVC];
}

-(void)mapLocationView:(ZMMapLocationView *)vc endBtnAction:(UIButton *)btn{
    [self gotoAutocompleteVC];
}

#pragma mark ZMMapsDropdownViewDelegate
-(void)mapsDropdownView:(ZMMapsDropdownView *)vc pickLocationAction:(UIButton *)btn{
    self.centerBtn.hidden = NO;
    self.centerBtnTopLabel.hidden = NO;
    self.centerBtnTopBtn.hidden = NO;
    [self.mapLocationView.currLocationTextField resignFirstResponder];
    [self.mapLocationView.destinationTextField resignFirstResponder];
}


#pragma mark UITextFileDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.inputStart = textField.tag - 10;
//    self.mapsDropdownView.hidden = NO;
//    [self textSelectanimations:textField.tag];
    
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
    ZMAutocompleteViewController *autocompleteVC =  [styoryBoard instantiateViewControllerWithIdentifier:@"AutocompleteVC"];
    autocompleteVC.delegate = self;
    [self.navigationController pushViewController:autocompleteVC animated:YES];
}

-(void)gotoAutocompleteVC{
    UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
    ZMAutocompleteViewController *autocompleteVC =  [styoryBoard instantiateViewControllerWithIdentifier:@"AutocompleteVC"];
    autocompleteVC.delegate = self;
    [self.navigationController pushViewController:autocompleteVC animated:YES];
}

#pragma mark ZMAutocompleteViewDelegate
// 搜索起始位置
-(void)autocompleteView:(ZMAutocompleteViewController *)vc withStartPlace:(GMSPlace *)place{
    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude:place.coordinate.latitude
                                 longitude:place.coordinate.longitude
                                 zoom:13
                                 ];
    self.googleMapView.camera = camera;
    [self selectStartLocation:place.name coordinate:place.coordinate textTag:11];
}

// 起始位置地图选点
-(void)autocompleteViewStartSelect:(ZMAutocompleteViewController *)vc{
    self.inputStart = 1;
    [self.centerBtn setImage:[UIImage imageNamed:@"pickuppin"] forState:UIControlStateNormal];
    self.centerBtn.hidden = NO;
    self.centerBtnTopLabel.hidden = NO;
    self.centerBtnTopBtn.hidden = NO;
}

// 搜索终点位置
-(void)autocompleteView:(ZMAutocompleteViewController *)vc withEndPlace:(GMSPlace *)place{
    // 选择终于位置后的处理
    [self selectEndLocation:place.name coordinate:place.coordinate textTag:12];
}

-(void)selectStartLocation:(NSString *)addr coordinate:(CLLocationCoordinate2D)startCoordinate textTag:(NSInteger)tag{
    
    GMSCameraPosition *camera = [GMSCameraPosition
                                 cameraWithLatitude:startCoordinate.latitude
                                 longitude:startCoordinate.longitude
                                 zoom:13
                                 ];
    self.googleMapView.camera = camera;
    
    self.startLocation2D = startCoordinate;
    [self textEnabledanimations:11];
    self.mapLocationView.currLocationTextField.text = addr;
    self.gotripDetail.fromAddr = addr;
    self.gotripDetail.fromLatitude = [NSString stringWithFormat:@"%f",startCoordinate.latitude];
    self.gotripDetail.fromLongitude = [NSString stringWithFormat:@"%f",startCoordinate.longitude];
    [self drawStartLocactionMarker:startCoordinate];
}


-(void)selectEndLocation:(NSString *)addr coordinate:(CLLocationCoordinate2D)endCoordinate textTag:(NSInteger)tag{
    self.endLocation2D = endCoordinate;
    self.mapLocationView.destinationTextField.text = addr;
    [self textEnabledanimations:tag];
    [self.mapLocationView.destinationTextField resignFirstResponder];
    [self drawEndLocactionMarker:endCoordinate];
    
    self.gotripDetail.toAddr = addr;
    self.gotripDetail.toLatitude = [NSString stringWithFormat:@"%f",endCoordinate.latitude];
    self.gotripDetail.toLongitude = [NSString stringWithFormat:@"%f",endCoordinate.longitude];
    
    //    [self calculateRoutesFrom:self.startLocation2D to:self.endLocation2D]
    [self addPolayLineFrom:self.startLocation2D to:self.endLocation2D];
}

// 终点位置地图选点
-(void)autocompleteViewEndSelect:(ZMAutocompleteViewController *)vc{
    self.inputStart = 2;
    [self.centerBtn setImage:[UIImage imageNamed:@"destinationPin"] forState:UIControlStateNormal];
    self.centerBtn.hidden = NO;
    self.centerBtnTopLabel.hidden = NO;
    self.centerBtnTopBtn.hidden = NO;
}

-(void)autocompleteView:(ZMAutocompleteViewController *)vc workSelectAddr:(NSString *)addr latitude:(NSString *)Latitude longitude:(NSString *)Longitude{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([Latitude floatValue], [Longitude floatValue]);
    if (vc.inputStart == 1) {
        [self selectStartLocation:addr coordinate:coordinate textTag:11];
    }else{
        [self selectEndLocation:addr coordinate:coordinate textTag:12];
    }
}

-(void)autocompleteView:(ZMAutocompleteViewController *)vc homeSelectAddr:(NSString *)addr latitude:(NSString *)Latitude longitude:(NSString *)Longitude{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([Latitude floatValue], [Longitude floatValue]);
    if (vc.inputStart == 1) {
        [self selectStartLocation:addr coordinate:coordinate textTag:11];
    }else{
        [self selectEndLocation:addr coordinate:coordinate textTag:12];
    }
}



// 输入状态时圆点的动画
-(void)textSelectanimations:(NSInteger)index{
    self.centerBtn.hidden = YES;
    self.centerBtnTopLabel.hidden = YES;
    self.centerBtnTopBtn.hidden = YES;
    NSString *btnIcon;
    if (index == 11) {
        [UIView animateWithDuration:0.3f animations:^{
            self.mapLocationView.pickupImgML.constant = 9.f;
            self.mapLocationView.pickupImgH.constant = 20.f;
            self.mapLocationView.pickupImgW.constant = 20.f;
            [self.mapLocationView.pickupImg layoutIfNeeded];
        }];
        btnIcon = @"pickuppin";
    }else if(index == 12){
        [UIView animateWithDuration:0.3f animations:^{
            self.mapLocationView.dstinImgML.constant = 9.f;
            self.mapLocationView.dstionImgW.constant = 20.f;
            self.mapLocationView.dstionImgH.constant = 20.f;
            [self.mapLocationView.dstionImg layoutIfNeeded];
        }];
        btnIcon = @"destinationPin";
    }
    [self.centerBtn setImage:[UIImage imageNamed:btnIcon] forState:UIControlStateNormal];
}

// 输入完时圆点的动画
-(void)textEnabledanimations:(NSInteger)index{
    if (index == 11) {
        [UIView animateWithDuration:0.3f animations:^{
            self.mapLocationView.pickupImgML.constant = 15.f;
            self.mapLocationView.pickupImgH.constant = 8.f;
            self.mapLocationView.pickupImgW.constant = 8.f;
            [self.mapLocationView.pickupImg layoutIfNeeded];
        }];
    }else if(index == 12){
        [UIView animateWithDuration:0.3f animations:^{
            self.mapLocationView.dstinImgML.constant = 15.f;
            self.mapLocationView.dstionImgW.constant = 8.f;
            self.mapLocationView.dstionImgH.constant = 8.f;
            [self.mapLocationView.dstionImg layoutIfNeeded];
        }];
    }
}



-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self textEnabledanimations:textField.tag];
}

- (void)calculateRoutesFrom:(CLLocationCoordinate2D)startLoc to:(CLLocationCoordinate2D)endLoc{
    //开始地址
    NSString *startAddress = [NSString stringWithFormat:@"%f,%f",startLoc.latitude,startLoc.longitude];
    
    //结束地址
    NSString *endAddress = [NSString stringWithFormat:@"%f,%f",endLoc.latitude,endLoc.longitude];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=driving&key=%@",startAddress,endAddress,@"AIzaSyDHq6iRGtDLREjmJnyJPdncScybwDMgaBU"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = responseObject;
        NSLog(@"%@",responseDic);
        [self addPolyline:responseDic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

-(void)addPolyline:(NSDictionary *)res{
    NSArray *arr = res[@"routes"];
    NSArray *legs = [arr firstObject][@"legs"];
    NSArray *steps = [legs firstObject][@"steps"];
    NSLog(@"%ld",steps.count);
    
    GMSMutablePath *path = [GMSMutablePath path];
    for (NSDictionary *obj in steps) {
        NSDictionary *end_location = obj[@"end_location"];
        [path addLatitude:[end_location[@"lat"] floatValue] longitude:[end_location[@"lng"]floatValue]];
    }
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 4.f; // 线条宽度
    polyline.strokeColor = [UIColor blackColor];
    polyline.geodesic = YES;
    polyline.map = _googleMapView;
}

-(void)addPolayLineFrom:(CLLocationCoordinate2D)startLoc to:(CLLocationCoordinate2D)endLoc{
//    [self.googleMapView clear];
    self.polyline.map = nil;
    GMSMutablePath *path = [GMSMutablePath path];
    [path addLatitude:startLoc.latitude longitude:startLoc.longitude];
    [path addLatitude:endLoc.latitude longitude:endLoc.longitude];
    self.polyline = [GMSPolyline polylineWithPath:path];
    
    
    self.polyline.strokeWidth = 4.f; // 线条宽度
    self.polyline.strokeColor = [UIColor blackColor];
    self.polyline.geodesic = YES;
    self.polyline.map = _googleMapView;
}



-(void)barBtnAction:(UIButton *)btn{
    if (self.goTripType == 3) {
        [self backAction];
    }else{
        UIStoryboard *styoryBoard = [UIStoryboard storyboardWithName:@"ZMOrder" bundle:nil];
        ZMTimeTodayViewController *timeTodayVC =  [styoryBoard instantiateViewControllerWithIdentifier:@"TimeTodayVC"];
        timeTodayVC.gotripDetail = self.gotripDetail;
        timeTodayVC.orderTripReqParams = self.orderTripReqParams;
        timeTodayVC.goTripType = self.goTripType;
        [self.navigationController pushViewController:timeTodayVC animated:YES];
    }
}


-(void)backAction{
    if (self.goTripType == 3) {
        if ([_delegate respondsToSelector:@selector(mapsView:gotripDetail:)]) {
            [_delegate mapsView:self gotripDetail:self.gotripDetail];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
