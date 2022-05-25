//
//  UIViewController+BTNavSet.h
//  BTHelpExample
//
//  Created by kds on 2022/4/14.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTConfig.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,NavItemType) {
    NavItemTypeLeft = 0,
    NavItemTypeRight
};

@interface UIViewController (BTNavSet)


#pragma mark item创建
- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                            color:(UIColor*)color
                             font:(UIFont*)font
                           target:(nullable id)target
                           action:(nullable SEL)action;

- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                           target:(nullable id)target
                           action:(nullable SEL)action;

- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                           action:(nullable SEL)action;

- (UIBarButtonItem*)bt_createItemImg:(UIImage*)img
                           action:(nullable SEL)action;

- (UIBarButtonItem*)bt_createItemImg:(UIImage*)img
                           target:(nullable id)target
                           action:(nullable SEL)action;

#pragma mark title、leftItem、rightItem初始化
- (void)bt_initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (void)bt_initTitle:(NSString*)title color:(UIColor*)color;
- (void)bt_initTitle:(NSString*)title;

- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title color:(UIColor*)color;
- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title;
- (UIBarButtonItem*)bt_initRightBarImg:(UIImage*)img;
- (void)bt_rightBarClick;

- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title color:(UIColor*)color;
- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title;
- (UIBarButtonItem*)bt_initLeftBarImg:(UIImage*)img;
- (void)bt_leftBarClick;

#pragma mark 多个item的自定义view初始化
//在item上生成2个或者多个按钮的时候使用该方法
- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type str:(NSArray<NSString*>*)strs;
- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type img:(NSArray<UIImage*>*)imgs;
- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type views:(NSArray<UIView*>*)views;

//获取相关的配置
- (CGSize)bt_customeItemSize:(NavItemType)type index:(NSInteger)index;
- (CGFloat)bt_customePadding:(NavItemType)type index:(NSInteger)index;

//仅限自定义字符串样式的回调
- (UIColor*)bt_customeStrColor:(NavItemType)type index:(NSInteger)index;
- (UIFont*)bt_customeFont:(NavItemType)type index:(NSInteger)index;

//点击后的事件
- (void)bt_customeItemClick:(NavItemType)type index:(NSInteger)index;


#pragma mark 其它相关快捷方法
//设置item左右间距为默认间距，默认为5，可以在BTCoreConfig的navItemPadding设置所有默认值
- (void)bt_setItemPaddingDefault;

//设置item左右间距
- (void)bt_setItemPadding:(CGFloat)padding;

//设置导航器背景透明，iOS15的时候，界面没有滑动view的时候需要去除safeArea自己布局顶部即可
- (void)bt_setNavTrans;

//设置导航器背景颜色
- (void)bt_setNavBgColor:(UIColor*)color;

- (void)bt_setNavBgImg:(UIImage*)bgImg;

//隐藏导航器分割线
- (void)bt_setNavLineHide;

//设置导航器分割线颜色
- (void)bt_setNavLineColor:(UIColor*)color;

///iOS15 设置height无效
- (void)bt_setNavLineColor:(UIColor*)color height:(CGFloat)height;

//如果想单独调整某一个vc的item的左右间距，实现该方法
- (CGFloat)bt_NavItemPadding:(NavItemType)type;

///单个界面的返回按钮图片，默认为nav_back名称的图片，且目前会取原色图片，不再受导航器tintColor的设置
- (UIImage*)bt_backImg;


@end

NS_ASSUME_NONNULL_END
