//
//  BTTabbarContentView.h
//  mingZhong
//
//  Created by liao on 2022/5/8.
//

#import <UIKit/UIKit.h>
#import "BTTabbarView.h"

NS_ASSUME_NONNULL_BEGIN


@interface BTTabbarContentViewModel : NSObject

@property (nonatomic, strong, nullable) UIView * childView;

@property (nonatomic, assign) NSInteger index;

@end


@interface BTTabbarContentView : UIView<BTTabbarViewDelegate>

- (void)reloadData;

#pragma mark 子类实现
- (NSInteger)btTabbarContentViewNumOfData;

- (UIView*)btTabbarContentViewForIndex:(NSInteger)index;

- (CGRect)btTabbarContentViewForFrame:(NSInteger)index;

- (BTTabbarView*)btTabbarContentViewForTabbarView;

- (CGRect)btTabbarContentViewForTabbarViewFrame;



@end

NS_ASSUME_NONNULL_END
