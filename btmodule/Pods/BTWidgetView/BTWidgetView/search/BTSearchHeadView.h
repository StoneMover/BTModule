//
//  BTSearchHeadView.h
//  BTWidgetViewExample
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTDividerLineView.h"
#import "BTTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTSearchHeadView : UIView

- (instancetype)initNavHead;

- (instancetype)initDefaultHead;

@property (nonatomic, strong) UIImageView * imgSearchIcon;

//取消按钮，设置显示隐藏即可改变相应的布局
@property (nonatomic, strong) UIButton * btnCancel;

@property (nonatomic, strong) BTTextField * textFieldSearch;

@property (nonatomic, strong) BTDividerLineView * viewLine;

///可以改变高度和左边距来调整UI图
@property (nonatomic, strong) UIView * viewBgColor;

@property (nonatomic, copy) void(^cancelClickBlock)(void);

@property (nonatomic, copy) void(^searchClick) (NSString * _Nullable  searchStr);

@property (nonatomic, copy) void(^layoutBlock) (BTSearchHeadView * selfView);

//是否在点击搜索按钮的时候情况输入框内容
@property (nonatomic, assign) BOOL isSearchClickEmptyTextField;

///搜索框距离背景的左边距，默认为8
@property (nonatomic, assign) CGFloat iconImgLeftPadding;

///搜索框距离搜索icon的左边距，默认2
@property (nonatomic, assign) CGFloat textFieldSearchLeftPadding;

///搜索框距离背景右边的间距，默认2
@property (nonatomic, assign) CGFloat textFieldSearchRightPadding;

@end

NS_ASSUME_NONNULL_END
