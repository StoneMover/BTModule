//
//  BTPageViewController.h
//  BTWidgetViewExample
//
//  Created by zanyu on 2019/8/26.
//  Copyright © 2019 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTPageView.h"

NS_ASSUME_NONNULL_BEGIN


@class BTPageViewController;

@protocol BTPageViewControllerDataSource <NSObject>

@required

- (NSInteger)pageNumOfVc:(BTPageViewController*)pageView;

- (UIViewController*)pageVc:(BTPageViewController*)pageVc vcForIndex:(NSInteger)index;

//为空则不显示headView
- (nullable BTPageHeadView*)pageVcHeadView:(BTPageViewController*)pageVc;

- (CGPoint)pageVcHeadOrigin:(BTPageViewController*)pageVc;

- (CGRect)pageVcContentFrame:(BTPageViewController*)pageVc;

@end


@protocol BTPageViewControllerDelegate <NSObject>

- (void)pageVc:(BTPageViewController*)pageView didShow:(NSInteger)index;

- (void)pageVc:(BTPageViewController *)pageView didDismiss:(NSInteger)index;

@end

@interface BTPageViewController : UIViewController

- (instancetype)initWithIndex:(NSInteger)index;

/// 是否需要自动加载当前页面的上一页和下一页，默认为YES
@property (nonatomic, assign) BOOL isNeedLoadNextAndLast;

@property (nonatomic, weak) id<BTPageViewControllerDataSource> dataSource;

@property (nonatomic, weak) id<BTPageViewControllerDelegate> delegate;

/// 是否可以滑动切换
@property (nonatomic, assign) BOOL isCanScroll;


/// 初始化pageView，如果实现isSelfCallInitPageView返回YES，则需要自己调用,确保只调用一次
- (void)initPageView;

/// 重新加载所有组件
- (void)reloadData;

/// 滑动到某一个界面
- (void)selectIndex:(NSInteger)index animated:(BOOL)animated;

/// 获取所有的子vc
- (NSArray<UIViewController*>*)getAllVc;

/// 根据下标获取子vc
- (nullable UIViewController*)vcWithIndex:(NSInteger)index;

/// 获取当前选中的vc
- (nullable UIViewController*)vcSelect;

/// 重写该方法返回你想要的pageView大小以及位置
- (CGRect)pageViewFrame;

/// 是否自己调用初始化pageView的方法，默认为NO
- (BOOL)isSelfCallInitPageView;

/// pageView的对象
- (BTPageView*)rootView;

@end

NS_ASSUME_NONNULL_END
