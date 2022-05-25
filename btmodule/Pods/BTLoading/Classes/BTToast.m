//
//  BTToast.m
//  loadinghelp
//
//  Created by stonemover on 2018/8/11.
//  Copyright © 2018年 StoneMover. All rights reserved.
//

#import "BTToast.h"
#import "BTLoadingConfig.h"
#import <BTHelp/BTUtils.h>
#import <BTHelp/NSString+BTString.h>

static const CGFloat BT_TOAST_PADDING=12;

static const CGFloat BT_TOAST_IMG_LABEL_TOP=5;


@interface BTToast()<BTLoadingHelpDelegate>

@property (nonatomic, strong) NSString * contentStr;

@property (nonatomic, strong) UIImage * contentImg;

@property (nonatomic, assign) BTToastStyle style;

@property (nonatomic, strong) UILabel * labelContent;

@property (nonatomic, strong) UIImageView * imgViewType;

@property (nonatomic, strong) UIView * rootView;

@property (nonatomic, assign) CGFloat yOffset;


@end


@implementation BTToast


+ (BTToast*)show:(NSString*_Nullable)str{
    return [self show:str img:nil];
}

+ (BTToast*)show:(NSString*_Nullable)str img:(UIImage*_Nullable)img{
    return [self show:str img:img isInVc:NO];
}

+ (BTToast*)show:(NSString*_Nullable)str
             img:(UIImage*_Nullable)img
          isInVc:(BOOL)isInVc{
    BTToast * toast = [[BTToast alloc] init:BTToastStyleCenter str:str img:img];
    if (str == nil || str.length == 0) {
        return toast;
    }
    if (isInVc) {
        UIViewController * currentVc = BTUtils.getCurrentVc;
        CGFloat yOffset = 0;
        if (!currentVc.navigationController.navigationBar.isHidden) {
            yOffset = BTUtils.NAVCONTENT_HEIGHT / 2;
        }
        
        [toast show:currentVc.view yOffset:yOffset];
        return toast;
    }
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [toast show:window];
    return toast;
}


+ (BTToast*)showSuccess:(NSString*_Nullable)str{
    return [self show:str img:BTLoadingConfig.share.toastStyle.successImg];
}

+ (BTToast*)showWarning:(NSString*_Nullable)str{
    return [self show:str img:BTLoadingConfig.share.toastStyle.warningsImg];
}

+ (BTToast*)showErrorInfo:(NSString*_Nullable)info{
    return [self show:info img:BTLoadingConfig.share.toastStyle.errorImg];
}

+ (BTToast*)showErrorObj:(NSError*_Nullable)error{
    if (error == nil) {
        return [self showErrorInfo:@"错误:error对象为空"];
    }
    NSString * info=nil;
    if ([error.userInfo.allKeys containsObject:@"NSLocalizedDescription"]) {
        info = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    }else {
        info = error.domain;
    }
    return [self showErrorInfo:info];
}

+ (BTToast*)showErrorObj:(NSError *_Nullable)error errorInfo:(NSString*_Nullable)errorInfo{
    if (error) {
        return [self showErrorObj:error];
    }else{
        return [self showErrorInfo:errorInfo];
    }
}

+ (BTToast*)showVc:(NSString*_Nullable)str{
    return [self show:str img:nil isInVc:YES];
}

+ (BTToast*)showVcSuccess:(NSString*_Nullable)str{
    return [self show:str img:[BTLoadingConfig imageBundleName:@"bt_toast_success"] isInVc:YES];
}

+ (BTToast*)showVcWarning:(NSString*_Nullable)str{
    return [self show:str img:[BTLoadingConfig imageBundleName:@"bt_toast_warning"] isInVc:YES];
}

+ (BTToast*)showVcErrorInfo:(NSString*_Nullable)info{
    return [self show:info img:[BTLoadingConfig imageBundleName:@"bt_toast_error"] isInVc:YES];
}

+ (BTToast*)showVcErrorObj:(NSError*_Nullable)error{
    if (error == nil) {
        return [self showErrorInfo:@"错误:error对象为空"];
    }
    NSString * info=nil;
    if ([error.userInfo.allKeys containsObject:@"NSLocalizedDescription"]) {
        info = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    }else {
        info = error.domain;
    }
    return [self showVcErrorInfo:info];
}

+ (BTToast*)showVcErrorObj:(NSError *_Nullable)error errorInfo:(NSString*_Nullable)errorInfo{
    if (error) {
        return [self showVcErrorObj:error];
    }else{
        return [self showVcErrorInfo:errorInfo];
    }
}


#pragma mark init
- (instancetype)init:(BTToastStyle)style str:(NSString*_Nullable)str img:(UIImage*_Nullable)img{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    self.style = style;
    if (str == nil) {
        str = @"";
    }
    self.contentStr = str;
    self.contentImg = img;
    self.backgroundColor = [UIColor clearColor];
    [self initSelf];
    return self;
}

- (void)initSelf{
    [BTLoadingConfig.share addDelegate:self];
    self.isClickInToast = YES;
    self.delayDismissTime = 1.5;
    [self initRootView];
    [self initLabel];
    [self initImg];
}

- (void)initRootView{
    self.rootView = [[UIView alloc] init];
    self.rootView.alpha = 0;
    self.rootView.layer.cornerRadius = BTLoadingConfig.share.toastStyle.backgroundCorner;
    self.rootView.clipsToBounds = YES;
    [self addSubview:self.rootView];
    self.rootView.backgroundColor = BTLoadingConfig.share.toastStyle.backgroudColor;
}

- (void)initImg{
    if (!self.contentImg) {
        return;
    }
    
    self.imgViewType = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.imgViewType.image = self.contentImg;
    [self.rootView addSubview:self.imgViewType];
}

- (void)initLabel{
    self.labelContent = [[UILabel alloc] init];
    self.labelContent.textColor = BTLoadingConfig.share.toastStyle.textColor;
    self.labelContent.font = BTLoadingConfig.share.toastStyle.textFont;
    self.labelContent.textAlignment = NSTextAlignmentCenter;
    self.labelContent.text = self.contentStr;
    self.labelContent.numberOfLines = 0;
    [self.labelContent sizeToFit];
    CGFloat labelMaxW = UIScreen.mainScreen.bounds.size.width / 2;
    if (self.labelContent.frame.size.width > labelMaxW) {
        CGFloat h = [self.contentStr bt_calculateStrHeight:labelMaxW font:self.labelContent.font];
        self.labelContent.frame = CGRectMake(0, 0, labelMaxW, h);
    }
    
    if (self.labelContent.frame.size.width<80) {
        self.labelContent.frame = CGRectMake(self.labelContent.frame.origin.x, self.labelContent.frame.origin.x, 80, self.labelContent.frame.size.height);
    }
    
    [self.rootView addSubview:self.labelContent];
}



#pragma mark 布局
- (void)layoutSubviews{
    CGFloat labelW = self.labelContent.frame.size.width;
    CGFloat labelH = self.labelContent.frame.size.height;
    
    CGFloat totalW = labelW+BT_TOAST_PADDING*2;
    CGFloat totalH = labelH+BT_TOAST_PADDING*2;
    if (self.imgViewType) {
        totalH += BT_TOAST_IMG_LABEL_TOP + self.imgViewType.frame.size.height;
    }
    
    self.rootView.frame = CGRectMake(0, 0, totalW, totalH);
    self.rootView.center = CGPointMake(self.frame.size.width/2,
                                       (self.frame.size.height - BTLoadingConfig.share.keyboardHeight) / 2 - self.yOffset);
    
    if (self.imgViewType) {
        self.imgViewType.frame = CGRectMake(totalW/2-self.imgViewType.frame.size.width/2,
                                          BT_TOAST_PADDING,
                                          self.imgViewType.frame.size.width,
                                          self.imgViewType.frame.size.height);
        self.labelContent.frame = CGRectMake(BT_TOAST_PADDING,
                                           self.imgViewType.frame.origin.y+self.imgViewType.frame.size.height+BT_TOAST_IMG_LABEL_TOP,
                                           self.labelContent.frame.size.width,
                                           self.labelContent.frame.size.height);
    }else{
        self.labelContent.frame = CGRectMake(BT_TOAST_PADDING,
                                           BT_TOAST_PADDING,
                                           self.labelContent.frame.size.width,
                                           self.labelContent.frame.size.height);
    }
    
    
}

#pragma mark 显示
- (void)show:(UIView *)rootView{
    [self show:rootView yOffset:0];
}

- (void)show:(UIView *)rootView yOffset:(CGFloat)yOffset{
    self.yOffset = yOffset;
    for (UIView * view in rootView.subviews) {
        if ([view isKindOfClass:[BTToast class]]) {
            view.hidden=YES;
        }
    }
    
    self.frame = rootView.bounds;
    [rootView addSubview:self];
    [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.rootView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayDismissTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.2 animations:^{
                self.rootView.alpha=0;
            } completion:^(BOOL finished) {
                [BTLoadingConfig.share removeDelegate:self];
                [self removeFromSuperview];
            }];
        });
    }];
}

#pragma mark 相关方法


- (void)setIsClickInToast:(BOOL)isClickInToast{
    self.userInteractionEnabled = !isClickInToast;
}


- (void)BTLoadingKeyboardHeightChange{
    [UIView animateWithDuration:.25 animations:^{
        self.rootView.center=CGPointMake(self.frame.size.width/2, (self.frame.size.height-[BTLoadingConfig share].keyboardHeight)/2);
    }];
}



@end
