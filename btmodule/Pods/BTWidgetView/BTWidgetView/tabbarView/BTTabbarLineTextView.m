//
//  BTTabbarLineTextView.m
//  mingZhong
//
//  Created by liao on 2022/5/6.
//

#import "BTTabbarLineTextView.h"
#import <BTHelp/UIView+BTViewTool.h>
#import <BTHelp/UIView+BTConstraint.h>

@interface BTTabbarLineTextView()<BTTabbarViewDataSource>

@property (nonatomic, strong) NSArray<NSString*> * titleArray;

@property (nonatomic, strong) NSMutableArray<UIView*> * verticalLineViewArray;

@property (nonatomic, strong) UIView * hozLineView;

@property (nonatomic, strong) UIView * coverLineView;

@end


@implementation BTTabbarLineTextView



#pragma mark 生命周期
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray<NSString*> *)titleArray{
    self = [super initWithFrame:frame];
    self.titleArray = titleArray;
    self.verticalLineViewArray = [NSMutableArray new];
    self.dataSource = self;
    return self;
}

#pragma mark 初始化

#pragma mark 点击事件

#pragma mark 相关方法
- (void)selectWithIndex:(NSInteger)index{
    for (int i=0; i<self.titleArray.count; i++) {
        BTTabbarLineTextItemView * view = (BTTabbarLineTextItemView*)[self indexWithChildView:i];
        if (index == i) {
            view.topLineView.hidden = YES;
            view.label.textColor = self.selectColor;
        }else{
            view.topLineView.hidden = NO;
            view.label.textColor = self.normalColor;
        }
    }
    [super selectWithIndex:index];
}

#pragma mark 网络请求

#pragma mark BTTabbarViewDataSource

- (NSInteger)btTabbarViewNumOfData:(BTTabbarView*)tabbarView{
    return self.titleArray.count;
}

- (UIView*)btTabbarView:(BTTabbarView*)tabbarView viewForIndex:(NSInteger)index{
    BTTabbarLineTextItemView * view = [BTTabbarLineTextItemView new];
    view.label.text = self.titleArray[index];
    view.label.font = self.labelFont;
    view.label.textColor = self.normalColor;
    [view initLineView:BTTabbarLineTextItemViewTop lineSize:0.5 color:self.lineColor];
    if (index != 0) {
        [view initLineView:BTTabbarLineTextItemViewLeft lineSize:0.5 color:self.lineColor];
    }
    return view;
}

@end



@implementation BTTabbarLineTextItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.label = [UILabel new];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.label];
    [self.label bt_addToParentWithPadding:BTPaddingMake(0, 0, 0, 0)];
    
    
    return self;
}

- (void)initLineView:(BTTabbarLineTextItemViewLocation)type lineSize:(CGFloat)size color:(UIColor*)color{
    if (type == BTTabbarLineTextItemViewTop) {
        if (self.topLineView) {
            [self.topLineView removeFromSuperview];
            self.topLineView = nil;
        }
        
        self.topLineView = [UIView new];
        self.topLineView.backgroundColor = color;
        self.topLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.topLineView];
        [self.topLineView bt_addHeight:size];
        [self.topLineView bt_addTopToParent];
        [self.topLineView bt_addLeftToParent];
        [self.topLineView bt_addRightToParent];
        return;
    }
    
    if (type == BTTabbarLineTextItemViewBottom) {
        if (self.bottomLineView) {
            [self.bottomLineView removeFromSuperview];
            self.bottomLineView = nil;
            return;
        }
        self.bottomLineView = [UIView new];
        self.bottomLineView.backgroundColor = color;
        self.bottomLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.bottomLineView];
        [self.bottomLineView bt_addHeight:size];
        [self.bottomLineView bt_addBottomToParent];
        [self.bottomLineView bt_addLeftToParent];
        [self.bottomLineView bt_addRightToParent];
        return;
    }
    
    
    if (type == BTTabbarLineTextItemViewLeft) {
        if (self.leftLineView) {
            [self.leftLineView removeFromSuperview];
            self.leftLineView = nil;
            return;
        }
        self.leftLineView = [UIView new];
        self.leftLineView.backgroundColor = color;
        self.leftLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.leftLineView];
        [self.leftLineView bt_addWidth:size];
        [self.leftLineView bt_addBottomToParent];
        [self.leftLineView bt_addLeftToParent];
        [self.leftLineView bt_addTopToParent];
        
        return;
    }
    
    if (type == BTTabbarLineTextItemViewRight) {
        if (self.rightLineView) {
            [self.rightLineView removeFromSuperview];
            self.rightLineView = nil;
            return;
        }
        self.rightLineView = [UIView new];
        self.rightLineView.backgroundColor = color;
        self.rightLineView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.rightLineView];
        [self.rightLineView bt_addWidth:size];
        [self.rightLineView bt_addBottomToParent];
        [self.rightLineView bt_addRightToParent];
        [self.rightLineView bt_addTopToParent];
        
        return;
    }
    
}

@end
