//
//  BTGeneralTableViewCell.h
//  BTWidgetViewExample
//
//  Created by apple on 2021/1/26.
//  Copyright © 2021 stone. All rights reserved.
//  ⚠️ 在很长的列表中使用的时候，每一个样式都要给一个cellId，根据index+cellId获取对应的cell样式

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BTGeneralCellStyle) {
    BTGeneralCellStyleFullText = 0, //图标-标题-----------------副标题-箭头
    BTGeneralCellStyleFullSwitch,   //图标-标题----------------- 开关
    BTGeneralCellStyleSimpleText,   //标题----------------- 箭头
    BTGeneralCellStyleSimpleText2,   //标题-----------------副标题-箭头
    BTGeneralCellStyleSimpleText3,   //标题-----------------副标题
    BTGeneralCellStyleSimpleSwitch,  //标题----------------- 开关
    BTGeneralCellStyleJustTitle,      //标题
    BTGeneralCellStyleJustTitleCenter,  //标题居中显示
    BTGeneralCellStyleFullText2  //图标-标题-----------------副标题-副标题、箭头,最后一个副标题和箭头重合
};

@class BTGeneralCellConfig;

@class BTGeneralView;

typedef void (^BTGeneralCellConfigBlock)(BTGeneralCellConfig * config);

@interface BTGeneralCell : UITableViewCell

@property (nonatomic, strong) BTGeneralView * generalView;

/// 内容的边距约束，上、下、左、右四个
@property (nonatomic, strong) NSArray<NSLayoutConstraint*> * contentPadding;

@end

@interface BTGeneralCellConfig : NSObject

/*
控件的大小
 BTGeneralCellStyleCustome 模式下所有控件都需要设置
 imageView、label 可以设置大小，设置位置无效
*/
@property (nonatomic, assign) CGRect rect;

//距离上一个控件的左间距，如果为第一个则为距离父view的左间距
@property (nonatomic, assign) CGFloat leftPadding;

//距离上一个控件的右间距，如果为第一个则为距离父view的右间距
@property (nonatomic, assign) CGFloat rightPadding;

//文字颜色
@property (nonatomic, strong) UIColor * textColor;

//文字字体
@property (nonatomic, strong) UIFont * font;

//上一个view对象，如果没有则以父view为基础
@property (nonatomic, weak, nullable) UIView * lastView;

//当前BTGeneralView对象
@property (nonatomic, weak) BTGeneralView * generalView;

@end


@interface BTGeneralView : UIView

//覆盖cell的按钮，默认隐藏
@property (nonatomic, strong) UIButton * fullBtn;

//标题图标
@property (nonatomic, strong) UIImageView * titleIconImgView;

@property (nonatomic, copy) BTGeneralCellConfigBlock titleIconImgViewBlock;

//标题文字
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, copy) BTGeneralCellConfigBlock titleLabelBlock;

//副标题
@property (nonatomic, strong) UILabel * subTitleLabel;

@property (nonatomic, copy) BTGeneralCellConfigBlock subTitleLabelBlock;

//右边的箭头图片
@property (nonatomic, strong) UIImageView * arrowImgView;

@property (nonatomic, copy) BTGeneralCellConfigBlock arrowImgViewBlock;

//与最右边箭头重合的副标题
@property (nonatomic, strong) UILabel * coincideLabel;

@property (nonatomic, copy) BTGeneralCellConfigBlock coincideLabelBlock;

//右边的开关按钮，会和副标题文字重合
@property (nonatomic, strong) UISwitch * contentSwitch;

//开关上的按钮可以实现BlockUI点击事件的回调来改变contentSwitch的状态
@property (nonatomic, strong) UIButton * switchBtn;

@property (nonatomic, copy) BTGeneralCellConfigBlock contentSwitchBlock;

//分割线
@property (nonatomic, strong) UIView * lineView;

//是否已经初始化
@property (nonatomic, assign) BOOL isHadInit;

//需要改变设置的时候，先实现对应的block，然后调用该方法，该方法可重复调用，只会执行一次
- (void)initWidget:(BTGeneralCellStyle)style;

//会设置里面的除了y值以外的位置属性
- (void)initLineViewWith:(CGRect)rect;


//初始化覆盖button，initWidget调用后会自动调用该方法
- (void)initFullBtn;

/**
 
 自由排序初始化，根据config的lastView作为基准排序
 titleIconImgView，titleLabel从左开始依次排序
 
 其它控件从右边依次排序
 
 */
- (void)initTitleIconImgView:(BTGeneralCellConfigBlock)configBlock;

- (void)initTitleLabel:(BTGeneralCellConfigBlock)configBlock;

- (void)initSubTitleLabel:(BTGeneralCellConfigBlock)configBlock;

- (void)initArrowImgView:(BTGeneralCellConfigBlock)configBlock;

- (void)initCoincideLabel:(BTGeneralCellConfigBlock)configBlock;

- (void)initSwitch:(BTGeneralCellConfigBlock)configBlock;

@end

NS_ASSUME_NONNULL_END
