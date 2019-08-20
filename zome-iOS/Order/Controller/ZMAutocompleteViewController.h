//
//  ZMAutocompleteViewController.h
//  zome-iOS
//
//  Created by CFW on 2017/12/31.
//  Copyright © 2017年 KunagBing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

@class ZMAutocompleteViewController;


@protocol ZMAutocompleteViewDelegate <NSObject>

@required

/** 起始位置的搜索 */
-(void)autocompleteView:(ZMAutocompleteViewController *)vc withStartPlace:(GMSPlace *)place;

/** 起始位置的地图选点 */
-(void)autocompleteViewStartSelect:(ZMAutocompleteViewController *)vc;

/** 终点位置的搜索 */
-(void)autocompleteView:(ZMAutocompleteViewController *)vc withEndPlace:(GMSPlace *)place;

/** 终点位置的地图选点 */
-(void)autocompleteViewEndSelect:(ZMAutocompleteViewController *)vc;

-(void)autocompleteView:(ZMAutocompleteViewController *)vc homeSelectAddr:(NSString *)addr latitude:(NSString *)Latitude longitude:(NSString *)Longitude;

-(void)autocompleteView:(ZMAutocompleteViewController *)vc workSelectAddr:(NSString *)addr latitude:(NSString *)Latitude longitude:(NSString *)Longitude;



@end

@interface ZMAutocompleteViewController : UIViewController

@property (nonatomic, weak) id<ZMAutocompleteViewDelegate> delegate;


/** *  1:起始位置   2:终点位置 */
@property (nonatomic, assign) NSInteger inputStart;

@end
