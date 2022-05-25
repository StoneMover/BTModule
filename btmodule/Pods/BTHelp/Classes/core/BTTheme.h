//
//  BTTheme.h
//  BTHelpExample
//
//  Created by kds on 2022/4/6.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BTTheme)

- (void)bt_themeRefresh;

@end


@interface BTTheme : NSObject

@property (nonatomic, strong, readonly) NSString * nowTheme;


@property (nonatomic, strong, readonly) UIColor * mainColor;


+ (instancetype)share;

+ (nullable UIImage*)imageWithName:(NSString*)imageName;

+ (nullable UIColor*)colorWithName:(NSString*)colorName;

///当前主题下的主题色，如果在当前主题以及默认主题下获取不到颜色则返回红色
+ (UIColor*)mainColor;

///当前主题下生成系统Alert或者Action的颜色值，获取不到则返回mainColor
+ (UIColor*)mainActionColor;

/**
 初始化主题数据
 default 为默认key，其它为可选主题
 参考BTThemeColor.plist文件数据结构，读取转换成字典传入
 使用其它方法之前必须优先调用
 */
- (void)initThemeDict:(NSDictionary*)dict;

/**
 注册需要刷新主题的回调，实现NSObject+BTTheme分类的bt_themeRefresh方法的任意Object对象即可
 使用弱引用容器存储，不需要退出界面的时候进行删除操作
 */
- (void)registerRefreshWithObj:(NSObject*)obj;


/**
 会在图片后自动拼接主题名
 例如home_back图片，在dark模式下会转换为home_back_dark，在default主题下仍然为home_back
 如果在dark模式下获取为空，则直接返回默认主题资源
 */
- (nullable UIImage*)imageWithName:(NSString*)imageName;

/**
 获取plist中对应的颜色值，如果在非default主题下获取不到，则返回default主题下的颜色
 */
- (nullable UIColor*)colorWithName:(NSString*)colorName;


- (void)changeTheme:(NSString*)theme;

- (void)addThemeColor:(NSString*)theme color:(UIColor*)color colorName:(NSString*)colorName;

//+ (nullable UIImage*)

@end






NS_ASSUME_NONNULL_END
