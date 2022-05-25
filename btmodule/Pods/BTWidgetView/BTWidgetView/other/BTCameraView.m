//
//  BTCameraView.m
//  BTWidgetViewExample
//
//  Created by duang on 2021/10/9.
//  Copyright © 2021 stone. All rights reserved.
//

#import "BTCameraView.h"
#import <AVFoundation/AVFoundation.h>
#import <BTHelp/BTPermission.h>

API_AVAILABLE(ios(11.0))

@interface BTCameraView()<AVCapturePhotoCaptureDelegate>

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice * device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput * input;

//输出图片
@property (nonatomic ,strong) AVCapturePhotoOutput * imageOutput;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession * session;

//图像预览层，实时显示捕获的图像
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer * previewLayer;

@end


@implementation BTCameraView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [BTPermission.share getCameraPermission:^{
        [self initSelf];
    }];
    
    return self;
}

- (void)initSelf{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
        
        self.imageOutput = [[AVCapturePhotoOutput alloc] init];
        
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        //输入输出设备结合
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
        if ([self.session canAddOutput:self.imageOutput]) {
            [self.session addOutput:self.imageOutput];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
            self.previewLayer.frame = self.bounds;
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.layer addSublayer:self.previewLayer];
            //设备取景开始
            [self start];
        });
          
    });
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    AVCaptureDeviceDiscoverySession * session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    NSArray * devices = session.devices;
    for (AVCaptureDevice * device in devices){
        if ( device.position == position ){
            return device;
        }
    }
        
    return nil;
}

- (void)start{
    [self.session startRunning];
}

- (void)stop{
    [self.session stopRunning];
}


- (void)makePhoto{
    AVCapturePhotoSettings * settings = [AVCapturePhotoSettings photoSettings];
    [self.imageOutput capturePhotoWithSettings:settings delegate:self];
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error{
    if (error) {
        return;
    }
    
    NSData * data = [photo fileDataRepresentation];
    UIImage * image = [UIImage imageWithData:data];
    if (self.resultImgBlock) {
        self.resultImgBlock(image);
    }
}

@end
