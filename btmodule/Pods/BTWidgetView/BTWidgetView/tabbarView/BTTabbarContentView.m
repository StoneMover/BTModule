//
//  BTTabbarContentView.m
//  mingZhong
//
//  Created by liao on 2022/5/8.
//

#import "BTTabbarContentView.h"
#import <BTHelp/UIView+BTViewTool.h>


@implementation BTTabbarContentViewModel



@end



@interface BTTabbarContentView()

@property (nonatomic, strong) NSMutableArray<BTTabbarContentViewModel*> * childViewArray;

@property (nonatomic, strong) BTTabbarView * tabbarView;

@end


@implementation BTTabbarContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.childViewArray = [NSMutableArray new];
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tabbarView.frame = [self btTabbarContentViewForTabbarViewFrame];
    NSInteger i = 0;
    for (BTTabbarContentViewModel * m in self.childViewArray) {
        m.childView.frame = [self btTabbarContentViewForFrame:i];
        i++;
    }
}

- (void)reloadData{
    [self bt_removeAllChildView];
    [self.childViewArray removeAllObjects];
    NSInteger number = [self btTabbarContentViewNumOfData];
    for (int i=0; i<number; i++) {
        BTTabbarContentViewModel * model = [BTTabbarContentViewModel new];
        model.index = i;
        [self.childViewArray addObject:model];
    }
    self.tabbarView = [self btTabbarContentViewForTabbarView];
    [self addSubview:self.tabbarView];
    
    self.tabbarView.delegate = self;
    [self.tabbarView reloadData];
    [self.tabbarView selectWithIndex:0];
    
}

#pragma mark 子类实现
- (NSInteger)btTabbarContentViewNumOfData{
    return 0;
}

- (UIView*)btTabbarContentViewForIndex:(NSInteger)index{
    return [UIView new];
}

- (CGRect)btTabbarContentViewForFrame:(NSInteger)index{
    return CGRectZero;
}

- (BTTabbarView*)btTabbarContentViewForTabbarView{
    return [BTTabbarView new];
}

- (CGRect)btTabbarContentViewForTabbarViewFrame{
    return CGRectZero;
}

#pragma mark BTTabbarViewDelegate
- (void)btTabbarView:(BTTabbarView *)tabbarView willSelect:(NSInteger)index{
    for (int i=0; i<self.childViewArray.count; i++) {
        BTTabbarContentViewModel * model = self.childViewArray[i];
        
        
        if (index != i) {
            model.childView.hidden = YES;
        }else{
            if (model.childView == nil) {
                model.childView = [self btTabbarContentViewForIndex:index];
                model.childView.frame = [self btTabbarContentViewForTabbarViewFrame];
                [self addSubview:model.childView];
            }
            model.childView.hidden = NO;
        }
        
    }
}


@end
