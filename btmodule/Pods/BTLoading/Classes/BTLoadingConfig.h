//
//  BTLoadingHelp.h
//  moneyMaker
//
//  Created by Motion Code on 2019/2/13.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BTLoadingSubView.h"
#import "BTToast.h"

NS_ASSUME_NONNULL_BEGIN

@class BTToastStyleItem;

@protocol BTLoadingHelpDelegate <NSObject>

- (void)BTLoadingKeyboardHeightChange;

@end

@interface BTLoadingConfig : NSObject

+ (BTLoadingConfig*)share;

@property (nonatomic, assign, readonly) CGFloat keyboardHeight;

#pragma mark BTLoadingView相关设置

//默认加载中的文字
@property (nonatomic, strong) NSString * loadingStr;

//默认空数据的提示文字
@property (nonatomic, strong) NSString * emptyStr;

//默认界面错误的提示文字
@property (nonatomic, strong) NSString * errorInfo;

//默认加载中的图片，为gif
@property (nonatomic, strong) UIImage * loadingGif;

//空数据显示的图片
@property (nonatomic, strong) UIImage * emptyImg;

//错误界面现实的图片
@property (nonatomic, strong) UIImage * errorImg;

//tosat style可自行设置
@property (nonatomic, strong) BTToastStyleItem * toastStyle;

//progress style 可自行设置
@property (nonatomic, strong) BTToastStyleItem * progressStyle;

//自定义加载中的界面,需要每次都生成一个新的对象，默认为BTLoadingSubView,可参考.m类实现方式
@property (nonatomic, copy) BTLoadingSubView * (^customLoadingViewBlock)(void);

//自定义空界面,需要每次都生成一个新的对象，默认为BTLoadingSubView
@property (nonatomic, copy) BTLoadingSubView * (^customEmptyViewBlock)(void);

//自定义错误的界面,需要每次都生成一个新的对象，默认为BTLoadingSubView
@property (nonatomic, copy) BTLoadingSubView * (^customErrorViewBlock)(void);

- (void)addDelegate:(id)delegate;

- (void)removeDelegate:(id)delegate;

+ (UIImage*)imageBundleName:(NSString*)name;

@end


@interface BTToastStyleItem : NSObject

+ (instancetype)defaultItem;

@property (nonatomic, strong) UIColor * backgroudColor;

@property (nonatomic, strong) UIColor * textColor;

@property (nonatomic, strong) UIFont * textFont;

@property (nonatomic, strong,nullable) UIImage * errorImg;

@property (nonatomic, strong,nullable) UIImage * warningsImg;

@property (nonatomic, strong,nullable) UIImage * successImg;

@property (nonatomic, assign) CGFloat backgroundCorner;

@property (nonatomic, strong,nullable) UIColor * progressColor;

@end





NS_ASSUME_NONNULL_END

