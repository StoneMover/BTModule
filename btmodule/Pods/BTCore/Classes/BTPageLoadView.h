//
//  BTPageLoadView.h
//  BTCoreExample
//
//  Created by apple on 2020/9/3.
//  Copyright © 2020 stonemover. All rights reserved.
//


/**
 使用方式
 self.pageLoadView = [[BTPageLoadView alloc] initWithFrame:self.view.bounds];
 self.pageLoadView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
 self.pageLoadView.delegate = self;
 [self.view addSubview:self.pageLoadView];
 
 */

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import <BTHelp/BTUtils.h>
#import <BTHelp/BTModel.h>
#import <BTLoading/BTToast.h>
#import <BTLoading/BTLoadingView.h>
#import <BTHelp/UIView+BTViewTool.h>
#import "BTHttp.h"


@class BTPageLoadView;

NS_ASSUME_NONNULL_BEGIN

@protocol BTPageLoadViewDelegate <NSObject>

@required

//网络请求加载数据
- (void)BTPageLoadGetData:(BTPageLoadView*)loadView;



@optional

- (id<UITableViewDelegate>)BTPageLoadTableDelegate:(BTPageLoadView*)loadView;
- (id<UITableViewDataSource>)BTPageLoadTableDataSource:(BTPageLoadView*)loadView;

- (id<UICollectionViewDelegate>)BTPageLoadCollectionDelegate:(BTPageLoadView*)loadView;
- (id<UICollectionViewDataSource>)BTPageLoadCollectionDataSource:(BTPageLoadView*)loadView;

//自动化创建model的时候回调,如果你想计算cell的高度则可以实现此代理进行计算即可,会将转换后的model以及字典传回
- (void)BTPageLoadCreate:(BTPageLoadView*)loadView obj:(NSObject*)obj dict:(NSDictionary*)dict index:(NSInteger)index;

//MJFoot刷新距离底部的距离，适配iphonex,普通手机不会用到,如果是在tabbarView中则实现该方法返回0
- (CGFloat)BTPageLoadIgnoredContentInsetBottom:(BTPageLoadView*)loadView;


//获取array数组的方法回调，如果结构复杂则重写该方法然后返回数组字典即可
- (NSArray<NSDictionary*>*)BTPageLoadData:(BTPageLoadView*)loadView dataOri:(NSDictionary*)dataOri;

//下拉刷新的头部
- (MJRefreshHeader*)BTPageLoadRefreshHeader:(BTPageLoadView*)loadView;

//上拉加载的footer
- (MJRefreshFooter*)BTPageLoadRefreshFooter:(BTPageLoadView*)loadView;

//空数据Toast执行方法，需要自定义可重写方法
- (void)BTPageLoadEmptyDataToast:(BTPageLoadView*)loadView;

//错误Toast执行方法，需要自定义可重写该方法
- (void)BTPageLoadErrorToast:(BTPageLoadView*)loadView error:(NSError* _Nullable)error errorInfo:(NSString* _Nullable)errorInfo;

//获取默认的网络配置，如果不实现则返回BTHttp.share.filter
- (BTHttpFilter*)BTPageLoadHttpConfig:(BTPageLoadView*)loadView;

@end

@interface BTPageLoadView : UIView

@property (nonatomic, weak) id<BTPageLoadViewDelegate> delegate;

//需要loading的情况下传入对应的对象即可,是关联vc里面的对象,而不是重新初始化一个
@property (nonatomic, strong, nullable) BTLoadingView * loadingHelp;

//tableview 对象需要通过initTableView方法生成
@property (nonatomic, strong, nullable ,readonly) UITableView * tableView;

//collectionView 需要通过initCollectionView生成
@property (nonatomic, strong, nullable ,readonly) UICollectionView * collectionView;

//上次刷新的时间key,如果不设置为当前类的名称
@property (nonatomic, strong, nullable) NSString * refreshTimeKey;

//当前分页下标数字
@property (nonatomic, assign, readonly) NSInteger pageNumber;

//数据加载完成的标记，当数组中的条数少于该值则认为加载完毕
@property (nonatomic, assign) NSInteger loadFinishDataNum;

//是否需要下拉加载
@property (nonatomic, assign) BOOL isNeedHeadRefresh;

//是否需要上拉刷新
@property (nonatomic, assign) BOOL isNeedFootRefresh;

//是否已经加载完成数据
@property (nonatomic, assign, readonly) BOOL isLoadFinish;

//是否是下拉刷新加载数据
@property (nonatomic, assign, readonly) BOOL isRefresh;

//数据源
@property (nonatomic, strong) NSMutableArray * dataArray;

//cellId 数组
@property (nonatomic, strong, nullable ,readonly) NSMutableArray * dataArrayCellId;

//数据为空的时候是否Toast提示
@property (nonatomic, assign) BOOL isToastWhenDataEmpty;

//空数据Toast是否为当前VC中
@property (nonatomic, assign) BOOL isEmptyToastInCurrentVc;

//是否错误信息Toast在当前VC中显示
@property (nonatomic, assign) BOOL isErrorToastInCurrentVc;

//是否需要在刷新请求后调用autoLoadSuccess方法中清空dataArray数组,默认为YES
@property (nonatomic, assign) BOOL isNeedClearDataWhenRefresh;

//collectionViewCell size
@property (nonatomic, assign) CGSize collectionViewCellSize;

//是否在加载完成后延时显示错误界面，0为不延时，主要配合下拉刷新第一次加载没有loading界面的情况下，直接出现empty界面和生硬的问题
@property (nonatomic, assign) CGFloat delayShowErrorViewTime;

//是否在加载完成收延时显示空界面，0为不延时，主要配合下拉刷新第一次加载没有loading界面的情况下，直接出现empty界面和生硬的问题
@property (nonatomic, assign) CGFloat delayShowEmptyViewTime;

/// 是否正在reload后进行layoutIfNeeded操作，保持tableivew的及时刷新，避免多次reload中的崩溃
@property (nonatomic, assign) BOOL isAfterReloadLayout;

#pragma mark 初始化相关操作

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<BTPageLoadViewDelegate>)delegate;

/**
 在swift情况下注册isRegisgerNib为false的情况下，
 通过字符串获取class会失败,需要再次调用registerCollectionViewCellWithClass自己注册
 也可以调用新的初始化方法解决问题
 Object-c下可以继续正常使用
 */


- (void)initTableView:(NSArray<NSString*>*)cellNames;
- (void)initTableView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib;
- (void)initTableView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib style:(UITableViewStyle)style;
- (void)initTableView:(NSArray<NSString*>*)cellNames cellIdArray:(NSArray<NSString*>*)cellIdArray isRegisgerNib:(BOOL)isRegisgerNib style:(UITableViewStyle)style;


- (void)initCollectionView:(NSArray<NSString*>*)cellNames;
- (void)initCollectionView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib;
- (void)initCollectionView:(NSArray<NSString*>*)cellNames isRegisgerNib:(BOOL)isRegisgerNib layout:(UICollectionViewFlowLayout*)layout;


///新的初始化以及注册方法
- (void)initTableViewWithStyle:(UITableViewStyle)style;
- (void)initTableView;
- (void)registerTableViewCellWithClass:(Class)cla;
- (void)registerTableViewCellWithNibName:(NSString*)nibName;

- (void)initCollectionView;
- (void)initCollectionViewWithLayout:(UICollectionViewFlowLayout*)layout;
- (void)registerCollectionViewCellWithClass:(Class)cla;
- (void)registerCollectionViewCellWithNibName:(NSString*)nibName;

- (void)setTableViewNoMoreEmptyLine;

///iOS15 去除列表顶部的分割线，如果tableHeaderView有值则不用设置
- (void)clearTableViewSectionSeparatorLine;

#pragma mark 自动加载逻辑

//成功传入数据自动解析
- (void)autoLoadSuccess:(NSArray* _Nullable)dataArrayDict modelCla:(Class)cls;

//成功传入已经解析好的数组
- (void)autoLoadSuccess:(NSArray * _Nullable)dataArray;

//服务器错误与网络错误提示，如果error不空则进入autoLoadNetError方法，反之进入autoLoadSeverError方法
- (void)autoLoadError:(NSError* _Nullable)error errorInfo:(NSString* _Nullable)errorInfo;

//服务器错误状态显示
- (void)autoLoadSeverError:(NSString*)errorInfo;

//网络错误状态显示
- (void)autoLoadNetError:(NSError*)error;



#pragma mark 刷新相关
- (void)startHeadRefresh;

- (void)startRefreshNoAction;

- (void)startRefreshNoActionWithDelayTime:(CGFloat)time;

- (void)startHeadRefreshWithDelayTime:(CGFloat)time;

- (void)endHeadRefresh;

- (void)endFootRefresh;


#pragma mark 相关辅助方法
//获取字符串类型的pageNumber
- (NSString*)pageNumStr;

//获取cell的Id
- (NSString* _Nullable)cellId:(NSInteger)index;

//获取当前第一个的cellID
- (NSString* _Nullable)cellId;

//删除列表数据为空的时候请求,每删除一条数据后调用
- (void)emptyGetData;

//恢复所有值到默认状态，然后请求数据
- (void)resetValueAndGetData;

- (void)resetValue;

//设置MJ刷新头部的主题颜色为白色
- (void)setRefreshHeadThemeWhite;

//去除系统contentInset
- (void)clearTableViewSystemInset;

//设置tableview弹性头部图片，把headView背景设置为透明
- (void)setTableViewBounceHeadImgView:(NSString *)imgName height:(CGFloat)height;

//当scrollView的代理滑动的时候调用如下方法，则可实现头部图片缩放功能
- (void)bt_scrollViewDidScroll:(UIScrollView*)scrollView;

@end

NS_ASSUME_NONNULL_END
