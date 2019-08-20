//
//  ZMAutocompleteViewController.m
//  zome-iOS
//
//  Created by CFW on 2017/12/31.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import "ZMAutocompleteViewController.h"
#import "ZMMapLocationView.h"
#import "ZMMapsDropdownView.h"
#import "ZMMapsPredictionCell.h"
#import "ZMUserInfo.h"


static NSString *CellID = @"PredictionCell";

@interface ZMAutocompleteViewController ()
<
    ZMMapsDropdownViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UITextFieldDelegate
>

@property (nonatomic, strong) GMSPlacesClient *placesClient;

@property (weak, nonatomic) IBOutlet UIView *warpView;

@property (weak, nonatomic) IBOutlet ZMMapLocationView *mapLocationView;

@property (nonatomic, strong) ZMMapsDropdownView *mapsDropdownView;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSArray *arrayModel;

@property (nonatomic, copy) NSString *homeAddr;

@property (nonatomic, copy) NSString *workAddr;


@property (nonatomic, strong) ZMUserInfo *userInfo;

@end

@implementation ZMAutocompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 如果产品需要当键盘弹起时，点击背景收起键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self setupUI];
    
    [self addMapsDropdownView];
    
    
    self.placesClient = [[GMSPlacesClient alloc] init];
    
    ZMUserInfo *userInfo = [[ZMAppInfomationSingleton sharedInstance] getUserDefault];
    self.userInfo = userInfo;
    self.homeAddr = userInfo.homeAddr;
    self.workAddr = userInfo.workAddr;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI{
    [self.mapLocationView setCornerRadius:5.f];
}


-(void)addMapsDropdownView{
    self.mapsDropdownView = [[ZMMapsDropdownView alloc] myMapDropdownView];
    CGFloat vh = 200;
    if (IsStrEmpty(self.homeAddr)) {
        vh = vh - 50;
        self.mapsDropdownView.homeAddView.hidden = YES;
        self.mapsDropdownView.homeAddViewH.constant = 0.0f;
    }
    if (IsStrEmpty(self.workAddr)) {
        vh = vh - 50;
        self.mapsDropdownView.workAddView.hidden = YES;
        self.mapsDropdownView.workAddViewH.constant = 0.0f;
    }
    
    [self.mapsDropdownView setCornerRadius:5.f];
    self.mapsDropdownView.delegate = self;
    self.mapsDropdownView.homeAddrLabel.text = self.homeAddr;
    self.mapsDropdownView.workAddrLabel.text = self.workAddr;
    [self.view addSubview:self.mapsDropdownView];
//    self.mapsDropdownView.hidden = YES;
    [self.mapsDropdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@(vh));
        make.top.equalTo(self.mapLocationView.mas_bottom).offset(10);
    }];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayModel.count;
//    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ZMMapsPredictionCell *cell = [ZMMapsPredictionCell cellWithTableView:tableView];
    GMSAutocompletePrediction *prediction = [self.arrayModel objectAtIndex:indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:@"pickuppin_icon"];
    cell.titleLabel.text = prediction.attributedPrimaryText.string;
    cell.subTileLabel.text = prediction.attributedFullText.string;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GMSAutocompletePrediction *prediction = [self.arrayModel objectAtIndex:indexPath.row];
    if (self.inputStart == 1) {
        self.mapLocationView.currLocationTextField.text = prediction.attributedPrimaryText.string;
        [self.mapLocationView.currLocationTextField resignFirstResponder];
    }else{
        self.mapLocationView.destinationTextField.text =  prediction.attributedPrimaryText.string;
    }
    
    self.mapsDropdownView.hidden = NO;
    self.myTableView.hidden = YES;
    
    [self lookUpPlaceID:prediction.placeID];
    
}

#pragma mark mapsDropdownViewDelegate
-(void)mapsDropdownView:(ZMMapsDropdownView *)vc pickLocationAction:(UIButton *)btn{
    ZMLog(@"fjkdfds");
    if ([_delegate respondsToSelector:@selector(autocompleteViewStartSelect:)]) {
        [_delegate autocompleteViewStartSelect:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)mapsDropdownView:(ZMMapsDropdownView *)vc pickEnterLocationAction:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(autocompleteViewEndSelect:)]) {
        [_delegate autocompleteViewEndSelect:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)mapsDropdownViewHomeSelectAddr:(ZMMapsDropdownView *)vc{
    if ([_delegate respondsToSelector:@selector(autocompleteView:homeSelectAddr:latitude:longitude:)]) {
        [_delegate autocompleteView:self homeSelectAddr:self.homeAddr latitude:self.userInfo.homeLatitude longitude:self.userInfo.homeLongitude];
    }
}

-(void)mapsDropdownViewWorkSelectAddr:(ZMMapsDropdownView *)vc{
    if ([_delegate respondsToSelector:@selector(autocompleteView:workSelectAddr:latitude:longitude:)]) {
        [_delegate autocompleteView:self workSelectAddr:self.workAddr latitude:self.userInfo.workLatitude longitude:self.userInfo.workLongitude];
        
    }
}


#pragma mark UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self autoAddress:textField.text];
    self.mapsDropdownView.hidden = YES;
    self.myTableView.hidden = NO;
    self.inputStart = textField.tag - 10;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    //这对于想要加入撤销选项的应用程序特别有用
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    //要防止文字被改变可以返回NO
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    [self autoAddress:textField.text];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    [textField resignFirstResponder];
    [self autoAddress:textField.text];
    return YES;
}




-(void)autoAddress:(NSString *)str{
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
//    [ZMProgressHUD show];
    [self.placesClient autocompleteQuery:str bounds:nil filter:filter callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError * _Nullable error) {
//        [ZMProgressHUD dismiss];
        self.arrayModel = results;
        [self.myTableView reloadData];
    }];
}

-(void)lookUpPlaceID:(NSString *)placeID{
    [self.placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place placeID %@", place.placeID);
            NSLog(@"Place attributions %@", place.attributions);
            if (self.inputStart == 1) {
                if ([_delegate respondsToSelector:@selector(autocompleteView:withStartPlace:)]) {
                    [_delegate autocompleteView:self withStartPlace:place];
                }
            }else{
                if ([_delegate respondsToSelector:@selector(autocompleteView:withEndPlace:)]) {
                    [_delegate autocompleteView:self withEndPlace:place];
                }
            }
        } else {
            NSLog(@"No place details for %@", placeID);
        }
    }];
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
