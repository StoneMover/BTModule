//
//  BTViewController.h
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BTHelp/BTHelp.h>
#import <BTHelp/BTTheme.h>
#import <BTHelp/BTUtils.h>
#import <BTHelp/UIView+BTConstraint.h>
#import <BTHelp/UIView+BTViewTool.h>
#import <BTHelp/UIColor+BTColor.h>
#import <BTHelp/UIViewController+BTNavSet.h>
#import <BTHelp/UIViewController+BTDialog.h>
#import <BTHelp/BTNavigationView.h>
#import <BTLoading/UIViewController+BTLoading.h>
#import <BTLoading/BTToast.h>
#import <BTLoading/BTProgress.h>
#import <BTWidgetView/BTProgressView.h>
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "BTPageLoadView.h"

@class BTVcConfig;

NS_ASSUME_NONNULL_BEGIN

typedef void(^BTVcSuccessBlock)(NSObject * _Nullable obj);

typedef NS_ENUM(NSInteger,BTWebViewLoadingType) {
    BTWebViewLoadingDefault = 0,
    BTWebViewLoadingProgress,
    BTWebViewLoadingNone
};

@interface UIViewController (BTCategoryViewController)

- (void)bt_popToViewController:(Class)cla;

- (void)bt_popToViewController:(Class)cla animated:(BOOL)animated;

- (void)bt_popToArrayViewController:(NSArray<Class>*)claArray animated:(BOOL)animated;

//必须在使用RTNav框架才能调用，当需要跳转到下一个界面并且需要移除当前界面的时候调用
- (void)bt_removeNowVcToNextVc:(UIViewController*)vc;


///返回rootVC，在控制器没有某个childVC的时候，如果有该childVC则返回到该childVC
- (void)bt_popToRootVcWithOutChildVc:(Class)childVcCla animated:(BOOL)animated;
@end


@interface BTViewController : UIViewController

//是否在触摸结束后关闭键盘，默认true
@property (nonatomic, assign) BOOL isTouceViewEndCloseKeyBoard;

//界面调用viewWillAppear的次数
@property (nonatomic, assign) NSInteger viewWillAppearIndex;

//界面调用viewDidAppear的次数
@property (nonatomic, assign) NSInteger viewDidAppearIndex;

//前后页面的简单回调
@property (nonatomic, copy, nullable) BTVcSuccessBlock blockSuccess;

//自定义的导航器头部
@property (nonatomic, strong, nullable) BTNavigationView * btNavView;

//当vc完全出现后的第一次调用，只会调用一次，用在一些需要在界面完全显示后才需要进行初始化的情况
- (void)viewDidAppearFirst;

//获取数据的方法
- (void)getData;

//重新加载网络数据
- (void)bt_loadingReload;

//debug模式下会调用该方法
- (void)debugConfig;

///添加右滑返回事件监听
- (void)addRightSwipe;

///又滑返回事件回调
- (void)swipeGestureRecognize:(UISwipeGestureRecognizer *)recognize;

@end

@interface BTNavigationController : RTRootNavigationController

@end

@class WKWebView;

@interface BTWebViewController : BTViewController

@property (nonatomic, strong) NSString * url;

//导航器初始title
@property (nonatomic, strong, nullable) NSString * webTitle;

//导航器标题是否跟随网页变化
@property (nonatomic, assign) BOOL isTitleFollowWeb;

//加载中样式
@property (nonatomic, assign) BTWebViewLoadingType loadingType;

//进度条加载样式情况下的进度条颜色,默认BTCoreConfig.share.mainColor
@property (nonatomic, strong, nullable) UIColor * progressViewColor;

//返回按钮样式
@property (nonatomic, strong, nullable) UIImage * backImg;

//关闭按钮,设置了该值后,将会出现返回和关闭两个按钮,返回按钮可以返回上一个网页,关闭按钮直接退出webview
@property (nonatomic, strong, nullable) UIImage * closeImg;

//导航器分割线颜色，默认238
@property (nonatomic, strong) UIColor * webNavLineColor;

//添加到js 的方法,在初始化之前设置,back为返回方法，组件自己设备，不允许重名，重名后将收不到回调并直接退出界面
@property (nonatomic, strong) NSArray * jsFunctionArray;

//是否为弹出样式
@property (nonatomic, assign) BOOL isPresentStyle;

//js方法调用回调
@property (copy, nonatomic) void (^jsFunctionBlock)(NSString * name,NSString * body);

//NSURLRequest设置回调
@property (copy, nonatomic) void (^requestSetBlock)(NSURLRequest * _Nullable  request);

//webview初始化完成
@property (nonatomic, copy) void (^btWebInitFinish)(WKWebView * webView);

//webView加载成功
@property (nonatomic, copy) void (^btWebLoadSuccessBlock)(WKWebView * webView);

//富文本内容，有则加载
@property (nonatomic, strong) NSString * richText;

@end


@interface BTPageLoadViewController : BTViewController<BTPageLoadViewDelegate>

@property (nonatomic, strong, readonly) BTPageLoadView * pageLoadView;

//从statusbar 开始布局适用于顶部透明的vc
- (void)setLayoutFromStatusBar;

@end








@interface BTLogVC : BTPageLoadViewController


@end


@interface BTLogTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * labelTitle;

@end


@interface BTVcConfig : NSObject



//默认为NO，该值是为了执行在测试过程中的某些固定的代码片段已达到测试的要求，与各API环境无关
@property (nonatomic, assign) BOOL isDoDebugCode;

///是否显示继承与BTVC的销毁Log，默认YES
@property (nonatomic, assign) BOOL isLogVcDestory;


+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
