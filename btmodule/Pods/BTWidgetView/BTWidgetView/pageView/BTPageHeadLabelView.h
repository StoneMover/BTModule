//
//  BTPageHeadLabelView.h
//  live
//
//  Created by stonemover on 2019/7/30.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTPageHeadView.h"

NS_ASSUME_NONNULL_BEGIN

@class BTPageHeadLabelView;

@protocol BTPageHeadLabelDeletegate <NSObject>

@optional
//创建label回调,可处理改变大小、背景、圆角等熟悉
- (void)BTPageHeadLabelView:(BTPageHeadLabelView*)labelView label:(UILabel*)createLabel index:(NSInteger)index;

@end

@interface BTPageHeadLabelView : BTPageHeadView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles style:(BTPageHeadViewStyle)style;

//选中字体大小
@property (nonatomic, assign) CGFloat selectFontSize;

//未选中字体大小
@property (nonatomic, assign) CGFloat normalFontSize;

//选中文字颜色
@property (nonatomic, strong) UIColor * selectColor;

//未选中文字颜色
@property (nonatomic, strong) UIColor * normalColor;

//系统字体字重
@property (nonatomic, assign) UIFontWeight weight;

//item的宽度,不设置则自适应,只在默认排序情况生效
@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, weak) id<BTPageHeadLabelDeletegate> labelDelegate;

//将label恢复到出事状态，解决初始化的时候颜色不更新问题
- (void)unSelectLabel:(NSInteger)index;

//重载label文字的颜色
- (void)reloadLabelsColor:(NSInteger)selectIndex;

//根据下标获取对应的label对象
- (UILabel*)labelWithIndex:(NSInteger)index;

//获取所有的label对象
- (NSArray*)getLabelArray;

@end


NS_ASSUME_NONNULL_END

