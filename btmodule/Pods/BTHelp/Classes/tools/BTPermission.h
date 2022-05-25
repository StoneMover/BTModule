//
//  BTPermission.h
//  doctor
//
//  Created by stonemover on 2017/12/19.
//  Copyright © 2017年 stonemover. All rights reserved.
//  直接调用每个权限的获取方法即可，未选择权限的情况下会弹出权限请求框，被拒绝则会提示用户去开启
//  已经拒绝情况会直接提示用户打开权限
//  已经获得授权的会直接在block中回调，isCamera等参数只是提供外部判断的一个方便的途径

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BTPermissionSuccessBlock)(void);
typedef void(^BTPermissionBlock)(NSInteger index);

@interface BTPermission : NSObject



+ (instancetype)share;


//请求获取相机权限
@property (nonatomic, assign) BOOL isCamera;
- (void)getCameraPermission:(BTPermissionSuccessBlock)block;
- (void)getCameraPermission:(NSString*_Nullable)meg success:(BTPermissionSuccessBlock)block;


//请求获取相册权限
@property (nonatomic, assign) BOOL isAlbum;
- (void)getAlbumPermission:(BTPermissionSuccessBlock)block;
- (void)getAlbumPermission:(NSString*_Nullable)meg success:(BTPermissionSuccessBlock)block;



//请求麦克风权限
@property (nonatomic, assign) BOOL isMic;
- (void)getMicPermission:(BTPermissionSuccessBlock)block;
- (void)getMicPermission:(NSString*_Nullable)meg success:(BTPermissionSuccessBlock)block;



@end


@protocol BTLocationDelegate <NSObject>

- (void)locationSuccess:(NSString*)province city:(NSString*)city;

@end

@interface BTLocation : NSObject

//开始定位
- (void)start;

//停止定位
- (void)stop;

//是否有定位权限，包括完全定位权限和使用中定位权限
- (BOOL)isHasLocationPermission;

//是否有完全定位权限
- (BOOL)isHasAuthorizedAlways;

//是否需要申请定位权限
- (BOOL)isNeedRequestLocation;

//申请使用中权限，如果是初次申请权限block不会被回调
- (void)requestWhenInUseAuthorization:(NSString * _Nullable)meg success:(BTPermissionSuccessBlock _Nullable)block;

//申请完全定位权限，如果是初次申请权限block不会被回调
- (void)requestAlwaysAuthorization:(NSString * _Nullable)meg success:(BTPermissionSuccessBlock _Nullable)block;

//申请单次定位权限，如果是初次申请权限block不会被回调
- (void)requestLocation:(NSString * _Nullable)meg success:(BTPermissionSuccessBlock _Nullable)block;

@property (nonatomic, weak) id<BTLocationDelegate>  delegate;


@end

typedef NS_ENUM(NSInteger,BTThirdMapType){
    BTThirdMapApple = 0,
    BTThirdMapGaoDe,
    BTThirdMapBaiDu,
    BTThirdMapTencent
};

typedef NS_ENUM(NSInteger,BTThirdMapGuideType){
    BTThirdMapGuideWalking = 0, //步行
    BTThirdMapGuideRiding, //骑行
    BTThirdMapDriver,  //驾车
    BTThirdMapTransit // 公交
};

@class BTThirdMapModel;

/// 该坐标体系基于高德，如果使用的为百度SDK，需要自己转换坐标
@interface BTThirdMapHelp : NSObject

///用来判断是否安装某个地图应用的url，如果后期改变可自己设置相应的值
@property (nonatomic, strong) NSMutableArray * thirdMapUrlArray;

///是否安装了相应的地图应用
- (BOOL)isCanOpenMap:(BTThirdMapType)type;

///打开相应的地图进行导航
- (void)guideTo:(CLLocationCoordinate2D)coordinate model:(BTThirdMapModel*)model;

///已安装的地图应用列表
- (NSArray<BTThirdMapModel*>*)installedArray;


@end

@interface BTThirdMapModel : NSObject

- (instancetype)initWithType:(BTThirdMapType)type;

@property (nonatomic, strong, readonly) NSString * name;

/// 0:苹果地图，1:高德地图，2：百度地图，3：腾讯地图
@property (nonatomic, assign, readonly) BTThirdMapType type;

/// 导航类型
@property (nonatomic, assign) BTThirdMapGuideType wayType;

/// 腾讯跳转需要开发者key
@property (nonatomic, strong,nullable) NSString * tencentDevKey;

@end

NS_ASSUME_NONNULL_END
