//
//  BTLoadingSubView.h
//  BTLoadingTest
//
//  Created by zanyu on 2019/8/13.
//  Copyright © 2019 stonemover. All rights reserved.
//


/**
 
 布局默认为
 
 图片
 文字
 按钮
 
 以文字为中心固定，向上下拓展
 
 如果需要自定义
 
 布局相似
 创建对象，配置好参数后，调用initSubView初始化控件，然后设置到BTLoadingView对应的viewLoading、viewEmpty、viewError上即可
 
 布局不同
 继承该类，完成对应的布局，然后设置到BTLoadingView对应的viewLoading、viewEmpty、viewError上即可
 
 注意
 在点击重载的时候需要回调clickBlock，需要自己实现该方法显示内容- (void)show:(NSString*_Nullable)title img:(UIImage*_Nullable)img btnStr:(NSString*_Nullable)btnStr;
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTLoadingSubView : UIView

/// 中间文字上方的图片
@property (nonatomic, strong, nullable) UIImageView * contentImgView;

/// 中间的文字
@property (nonatomic, strong, nullable) UILabel * contentLabel;

/// 文字下方的按钮
@property (nonatomic, strong, nullable) UIButton * reloadBtn;

/// 按钮点击回调
@property (nonatomic, copy) void(^reloadClickBlock)(void);

/// 如果不需要默认样式重写该方法实现自己的布局
- (void)initSubView;

/// 提供给BTLoadingView使用的方法，显示具体的文字、图片、按钮文字内容
- (void)show:(NSString * _Nullable)title
         img:(UIImage * _Nullable)img
      btnStr:(NSString * _Nullable)btnStr;

/// 隐藏子view
- (void)hideLoading;

@end

NS_ASSUME_NONNULL_END
