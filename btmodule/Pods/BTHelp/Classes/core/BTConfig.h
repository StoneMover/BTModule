//
//  BTConfig.h
//  BTHelpExample
//
//  Created by kds on 2022/4/14.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BTModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTNavConfig : NSObject

+ (nonnull BTNavConfig*)share;

/*
 如果需要去掉导航器左右间距的约束回调
 */
@property (nonatomic, copy) BOOL (^navItemPaddingBlock)(NSLayoutConstraint * constraint);

//导航器标题默认文字字体
@property (nonatomic, strong) UIFont * defaultNavTitleFont;

//导航器标题默认文字颜色
@property (nonatomic, strong) UIColor * defaultNavTitleColor;

//导航器leftBarItem标题默认字体
@property (nonatomic, strong) UIFont * defaultNavLeftBarItemFont;

//导航器leftBarItem标题默认颜色
@property (nonatomic, strong) UIColor * defaultNavLeftBarItemColor;

//导航器rightBarItem标题默认字体
@property (nonatomic, strong) UIFont * defaultNavRightBarItemFont;

//导航器rightBarItem标题默认颜色
@property (nonatomic, strong) UIColor * defaultNavRightBarItemColor;

//导航器默认分割线颜色
@property (nonatomic, strong) UIColor * defaultNavLineColor;

//默认的vc背景色
@property (nonatomic, strong) UIColor * defaultVCBgColor;

//导航器返回的按钮距离左边的间距,默认5
@property (nonatomic, assign) CGFloat navItemPadding;

@end

typedef NS_ENUM(NSInteger,BTDebugType) {
    BTDebugTypeDev = 0,
    BTDebugTypeTest,
    BTDebugTypeProduct,
    BTDebugTypeCustome
};

static NSString * const BTDebugTypeDevId =@"开发环境";

static NSString * const BTDebugTypeTestId =@"测试环境";

static NSString * const BTDebugTypeProductId =@"生产环境";

@interface BTEnvModel : BTModel


@property (nonatomic, strong) NSString * identify;

@property (nonatomic, assign) BTDebugType type;

@property (nonatomic, strong) NSString * url;

///图片拼接的前缀地址，如果后端返回的为完整地址则可以忽略
@property (nonatomic, strong) NSString * imgUrlStart;

@property (nonatomic, strong,nullable) NSDictionary * otherDict;

///是否为当前环境设置，0：NO；1：YES；该值不要自己生成的设置，设置了也无效，调用BTEnvMananger的selectWithId方法
@property (nonatomic, assign) NSInteger isSelect;

- (instancetype)initWithType:(BTDebugType)type url:(NSString*)url;

- (instancetype)initCustomeTypeWithIdentify:(NSString*)identify url:(NSString*)url;

@end

@interface BTEnvMananger : NSObject


+ (instancetype)share;

+ (nullable BTEnvModel *)nowModel;

/*
 程序进入的时候调用，如果能够查询到本地存储数据则忽略执行
 查询不到则执行初始化操作
 */
- (void)initWithArray:(NSArray*)array;

- (void)initWithArray:(NSArray *)array selectIndex:(NSInteger)index;

- (void)save;

- (void)addModel:(BTEnvModel*)model;

/**
 删除环境，尽量不需要调用，如果初始化有3个环境，删掉一个，那么删掉的需要自己调动addmodel添加，
 在initWithArray并不会把删除的model重新加入
 */
- (void)deleteModel:(BTEnvModel*)model;

///选中当前环境变量
- (void)selectWithId:(NSString*)identify;

///清除所有变量，下次调动initWithArray会再次执行
- (void)clear;

///获取全部环境数据
- (NSArray*)allEnv;
@end

NS_ASSUME_NONNULL_END
