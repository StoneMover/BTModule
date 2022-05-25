//
//  BTPermission.m
//  doctor
//
//  Created by stonemover on 2017/12/19.
//  Copyright © 2017年 stonemover. All rights reserved.
//

#import "BTPermission.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "BTUtils.h"
#import <MapKit/MapKit.h>


static BTPermission * permission;



@implementation BTPermission

+(instancetype)share{
    if (!permission) {
        permission=[[BTPermission alloc]init];
    }
    
    return permission;
}

-(instancetype)init{
    self=[super init];
    return self;
}


//请求获取相机权限
- (BOOL)isCamera{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if (authStatus!=AVAuthorizationStatusAuthorized) {
        return NO;
    }
    
    return YES;
}
- (void)getCameraPermission:(BTPermissionSuccessBlock)block{
    [self getCameraPermission:nil success:block];
}
- (void)getCameraPermission:(NSString* _Nullable)meg success:(BTPermissionSuccessBlock)block{
    if (!meg) {
        meg=@"当前没有相机权限,是否前往设置?";
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//读取设备授权状态
    if (authStatus==AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted){
                    [self showSysAlert:@"温馨提示"
                              messages:meg?meg:@"当前没有相机权限,是否前往设置?"
                                  btns:@[@"取消",@"确定"]
                                 block:^(NSInteger index) {
                                     if (index==1) {
                                         [BTUtils openSetVc];
                                     }
                                 }];
                }else{
                    if (block) {
                        block();
                    }
                }
            });
        }];
        return;
    }
    
    
    if (!self.isCamera) {
        [self showSysAlert:@"温馨提示"
                  messages:meg
                      btns:@[@"取消",@"确定"]
                     block:^(NSInteger index) {
                         if (index==1) {
                             [BTUtils openSetVc];
                         }
                     }];
    }else{
        if (block) {
            block();
        }
    }
    
}


//请求获取相册权限
- (BOOL)isAlbum{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus!=PHAuthorizationStatusAuthorized) {
        return NO;
    }
    return YES;
}

- (void)getAlbumPermission:(BTPermissionSuccessBlock)block{
    [self getAlbumPermission:nil success:block];
}

- (void)getAlbumPermission:(NSString*_Nullable)meg success:(BTPermissionSuccessBlock)block{
    if (!meg) {
        meg=@"当前没有相册权限,是否前往设置?";
    }
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    
    if (authStatus==PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                    // 没有权限
                    [self showSysAlert:@"温馨提示"
                              messages:meg
                                  btns:@[@"取消",@"确定"]
                                 block:^(NSInteger index) {
                                     if (index==1) {
                                         [BTUtils openSetVc];
                                     }
                                 }];
                }else{
                    if (block) {
                        block();
                    }
                }
            });
            
        }];
        return;
    }
    
    if (!self.isAlbum) {
        [self showSysAlert:@"温馨提示"
                  messages:meg
                      btns:@[@"取消",@"确定"]
                     block:^(NSInteger index) {
                         if (index==1) {
                             [BTUtils openSetVc];
                         }
                     }];
    }else{
        if (block) {
            block();
        }
    }
    
    
    
}

//请求麦克风权限
- (BOOL)isMic{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus!=AVAuthorizationStatusAuthorized) {
        return NO;
    }
    
    return YES;
}
- (void)getMicPermission:(BTPermissionSuccessBlock)block{
    [self getMicPermission:nil success:block];
}
- (void)getMicPermission:(NSString*_Nullable)meg success:(BTPermissionSuccessBlock)block{
    if (!meg) {
        meg=@"当前没有麦克风权限,是否前往设置?";
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//读取设备授权状态
    if (authStatus==AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted){
                    [self showSysAlert:@"温馨提示"
                              messages:meg
                                  btns:@[@"取消",@"确定"]
                                 block:^(NSInteger index) {
                                     if (index==1) {
                                         [BTUtils openSetVc];
                                     }
                                 }];
                }else{
                    if (block) {
                        block();
                    }
                }
            });
        }];
        
        return;
    }
    
    if (!self.isMic) {
        [self showSysAlert:@"温馨提示"
                  messages:meg
                      btns:@[@"取消",@"确定"]
                     block:^(NSInteger index) {
                         if (index==1) {
                             [BTUtils openSetVc];
                         }
                     }];
    }else{
        if (block) {
            block();
        }
    }
}



- (void)showSysAlert:(NSString*)title
            messages:(NSString*)message
                btns:(NSArray<NSString*>*)btns
               block:(BTPermissionBlock)block{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __weak UIAlertController * weakAlerController=alertController;
    for (NSString * str in btns) {
        UIAlertAction * action =[UIAlertAction actionWithTitle:str
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           NSInteger index=[weakAlerController.actions indexOfObject:action];
                                                           block(index);
                                                       }];
        [alertController addAction:action];
    }
    //    UIWindow * window=[[UIApplication sharedApplication] delegate].window;
    [[BTUtils getCurrentVc] presentViewController:alertController animated:YES completion:nil];
}




@end

@interface BTLocation()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * mananger;

@property (nonatomic, strong) CLGeocoder * geocoder;

@end


@implementation BTLocation

- (instancetype)init{
    self=[super init];
    self.mananger=[[CLLocationManager alloc] init];
    self.mananger.delegate=self;
    self.mananger.desiredAccuracy = kCLLocationAccuracyBest;
    self.mananger.distanceFilter = kCLDistanceFilterNone;
    return self;
}


- (BOOL)isHasLocationPermission{
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            return NO;
        case kCLAuthorizationStatusRestricted:
            return NO;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return YES;
        case kCLAuthorizationStatusDenied:
            return NO;
    }
    
    return NO;
}

- (BOOL)isHasAuthorizedAlways{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isNeedRequestLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        return YES;
    }
    
    return NO;
}

- (void)requestWhenInUseAuthorization:(NSString * _Nullable)meg success:(BTPermissionSuccessBlock _Nullable)block{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        if ([BTUtils isEmpty:meg]) {
            meg = @"当前暂无定位权限，请前往设置界面更改权限";
        }
        
        [self showSysAlert:@"温馨提示"
                  messages:@"当前暂无定位权限，请前往设置界面更改权限"
                      btns:@[@"取消",@"确定"]
                     block:^(NSInteger index) {
            if (index == 1) {
                [BTUtils openSetVc];
            }
        }];
        return;
    }
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if (block) {
            block();
        }
        
        return;
    }
    
    
    [self.mananger requestWhenInUseAuthorization];
}

- (void)requestAlwaysAuthorization:(NSString * _Nullable)meg success:(BTPermissionSuccessBlock _Nullable)block{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        if ([BTUtils isEmpty:meg]) {
            meg = @"当前暂无定位权限，请前往设置界面更改权限";
        }
        [self showSysAlert:@"温馨提示"
                  messages:@"当前暂无定位权限，请前往设置界面更改权限"
                      btns:@[@"取消",@"确定"]
                     block:^(NSInteger index) {
            if (index == 1) {
                [BTUtils openSetVc];
            }
        }];
        return;
    }
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if ([BTUtils isEmpty:meg]) {
            meg = @"当前定位权限为使用期间定位，请前往设置界面更改权限";
        }
        [self showSysAlert:@"温馨提示"
                  messages:@"当前定位权限为使用期间定位，请前往设置界面更改权限"
                      btns:@[@"取消",@"确定"]
                     block:^(NSInteger index) {
            if (index == 1) {
                [BTUtils openSetVc];
            }
        }];
        
        return;
    }
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        if (block) {
            block();
        }
        return;
    }
    
    
    [self.mananger requestAlwaysAuthorization];
}

- (void)requestLocation:(NSString * _Nullable)meg success:(BTPermissionSuccessBlock _Nullable)block{
    [self.mananger requestLocation];
}

- (void)start{
    [self.mananger startUpdatingLocation];
}

- (void)stop{
    [self.mananger stopUpdatingLocation];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorLocationUnknown) {
        NSLog(@"无法检索位置");
    }
    else if(error.code == kCLErrorNetwork) {
        NSLog(@"网络问题");
    }
    else if(error.code == kCLErrorDenied) {
        NSLog(@"定位权限的问题");
        [self.mananger stopUpdatingLocation];
//        [self showAlert];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * location=[locations lastObject];
    if (!self.geocoder) {
        self.geocoder=[[CLGeocoder alloc] init];
    }
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * k=[placemarks lastObject];
        if (self.delegate) {
            [self.delegate locationSuccess:k.administrativeArea city:k.locality];
        }
    }];
}

- (void)showSysAlert:(NSString*)title
            messages:(NSString*)message
                btns:(NSArray<NSString*>*)btns
               block:(BTPermissionBlock)block{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __weak UIAlertController * weakAlerController=alertController;
    for (NSString * str in btns) {
        UIAlertAction * action =[UIAlertAction actionWithTitle:str
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           NSInteger index=[weakAlerController.actions indexOfObject:action];
                                                           block(index);
                                                       }];
        [alertController addAction:action];
    }
    //    UIWindow * window=[[UIApplication sharedApplication] delegate].window;
    [[BTUtils getCurrentVc] presentViewController:alertController animated:YES completion:nil];
}

@end

@implementation BTThirdMapHelp

- (instancetype)init{
    self = [super init];
    self.thirdMapUrlArray = [[NSMutableArray alloc] initWithArray:@[@"http://maps.apple.com/",
                                                                    @"iosamap://",
                                                                    @"baidumap://",
                                                                    @"qqmap://"
                                                                  ]
    ];
    
    return self;
}

- (BOOL)isCanOpenMap:(BTThirdMapType)type{
    NSString * urlStr = self.thirdMapUrlArray[type];
    NSString * urlStrResult = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:urlStrResult];
    BOOL result = [UIApplication.sharedApplication canOpenURL:url];
    return result;
}

- (void)guideTo:(CLLocationCoordinate2D)coordinate model:(BTThirdMapModel*)model{
    if (model.type == BTThirdMapApple) {
        MKMapItem * currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKPlacemark * mark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem * endMapItem = [[MKMapItem alloc] initWithPlacemark:mark];
        NSString * way = MKLaunchOptionsDirectionsModeWalking;
        if (model.wayType == BTThirdMapDriver) {
            way = MKLaunchOptionsDirectionsModeDriving;
        }else if(model.wayType == BTThirdMapTransit){
            way = MKLaunchOptionsDirectionsModeTransit;
        }
        
        NSDictionary * options= @{MKLaunchOptionsDirectionsModeKey : way,
                                  MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
        
        [MKMapItem openMapsWithItems:@[currentLocation,endMapItem] launchOptions:options];
        return;
    }
    
    if (model.type == BTThirdMapGaoDe) {
        NSString * way = @"2";
        if (model.wayType == BTThirdMapDriver) {
            way = @"0";
        }else if(model.wayType == BTThirdMapTransit){
            way = @"1";
        }else if(model.wayType == BTThirdMapGuideRiding){
            way = @"3";
        }
        
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&dlat=%f&dlon=%f&dev=0&t=%@",@"送个东西",coordinate.latitude, coordinate.longitude,way] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [BTUtils toUrlPage:urlString];
        return;
    }
    
    if (model.type == BTThirdMapBaiDu) {
        NSString * way = @"walking";
        if (model.wayType == BTThirdMapDriver) {
            way = @"driving";
        }else if(model.wayType == BTThirdMapTransit){
            way = @"transit";
        }else if(model.wayType == BTThirdMapGuideRiding){
            way = @"riding";
        }
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=%@&coord_type=gcj02",coordinate.latitude, coordinate.longitude,way] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [BTUtils toUrlPage:urlString];
        return;
    }
    
    if (model.type == BTThirdMapTencent) {
        NSString * way = @"walk";
        if (model.wayType == BTThirdMapDriver) {
            way = @"drive";
        }else if(model.wayType == BTThirdMapTransit){
            way = @"bus";
        }else if(model.wayType == BTThirdMapGuideRiding){
            way = @"bike";
        }
        
        NSString *urlString = [NSString stringWithFormat:@"qqmap://map/routeplan?type=%@&fromcoord=CurrentLocation&tocoord=%f,%f&referer=%@",way,coordinate.latitude, coordinate.longitude,model.tencentDevKey];
        [BTUtils toUrlPage:urlString];
        return;
    }
    
}

- (NSArray<BTThirdMapModel*>*)installedArray{
    NSMutableArray * dataArray = [NSMutableArray new];
    for (NSInteger i=0; i<self.thirdMapUrlArray.count; i++) {
        if ([self isCanOpenMap:i]) {
            BTThirdMapModel * model = [[BTThirdMapModel alloc] initWithType:i];
            [dataArray addObject:model];
        }
    }
    
    
    return dataArray;
}

@end




@implementation BTThirdMapModel

- (instancetype)initWithType:(BTThirdMapType)type{
    self = [super init];
    _type = type;
    return self;
}

- (NSString *)name{
    NSArray * nameArray = @[@"苹果地图",@"高德地图",@"百度地图",@"腾讯地图"];
    return [nameArray objectAtIndex:self.type];
}

@end
