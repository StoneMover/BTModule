//
//  BTTabbarView.m
//  mingZhong
//
//  Created by liao on 2022/5/6.
//

#import "BTTabbarView.h"
#import <BTHelp/UIView+BTViewTool.h>

@interface BTTabbarView()

@property (nonatomic, strong) NSMutableArray<UIView*> * childViewArray;

@property (nonatomic, assign) NSInteger lastSelectIndex;

@end


@implementation BTTabbarView

#pragma mark 生命周期
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initSelf];
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (int i=0; i<self.childViewArray.count; i++) {
        UIView * rootView = self.childViewArray[i];
        rootView.frame = [self itemFrameWithIndex:i];
        for (UIView * subView in rootView.subviews) {
            subView.frame = rootView.bounds;
        }
    }
}


#pragma mark 初始化
- (void)initSelf{
    self.childViewArray = [NSMutableArray new];
}



#pragma mark 点击事件
- (void)tabbarItemClick:(id)sender{
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    UIButton * view = sender;
    [self selectWithIndex:view.tag - 10000];
    
}

#pragma mark 相关方法
- (void)reloadData{
    if (!self.dataSource) {
        return;
    }
    self.lastSelectIndex = -1;
    for (UIView * view in self.childViewArray) {
        [view removeFromSuperview];
    }
    
    NSInteger totalNumber = [self.dataSource btTabbarViewNumOfData:self];
    for (int i=0; i<totalNumber; i++) {
        UIView * view = [self.dataSource btTabbarView:self viewForIndex:i];
        UIView * rootView = [UIView new];
        UIButton * btn = [UIButton new];
        btn.tag = 10000 + i;
        [btn addTarget:self action:@selector(tabbarItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [rootView addSubview:view];
        [rootView addSubview:btn];
        [self.childViewArray addObject:rootView];
        [self addSubview:rootView];
    }
    
}

- (void)selectWithIndex:(NSInteger)index{
    if (self.lastSelectIndex != -1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(btTabbarView:willUnSelect:)]) {
            [self.delegate btTabbarView:self willUnSelect:self.lastSelectIndex];
        }
    }
    self.lastSelectIndex = self.nowIndex;
    _nowIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(btTabbarView:willSelect:)]) {
        [self.delegate btTabbarView:self willSelect:_nowIndex];
    }
}


- (CGRect)itemFrameWithIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(btTabbarViewChildFrame:)]) {
        return [self.delegate btTabbarViewChildFrame:self];
    }
    
    CGFloat width = self.BTWidth / self.childViewArray.count;
    
    return CGRectMake(index * width, 0, width, self.BTHeight);
}

- (UIView*)indexWithChildView:(NSInteger)index{
    UIView * rootView = self.childViewArray[index];
    for (UIView * v in rootView.subviews) {
        if (v.tag < 10000) {
            return v;
        }
    }
    
    return nil;
}

#pragma mark 网络请求

@end
