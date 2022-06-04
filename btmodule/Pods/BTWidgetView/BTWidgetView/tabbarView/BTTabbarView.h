//
//  BTTabbarView.h
//  mingZhong
//
//  Created by liao on 2022/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BTTabbarView;

@protocol BTTabbarViewDelegate <NSObject>

@optional
- (void)btTabbarView:(BTTabbarView*)tabbarView willSelect:(NSInteger)index;

- (void)btTabbarView:(BTTabbarView*)tabbarView willUnSelect:(NSInteger)index;

/// 不实现则平分布局
- (CGRect)btTabbarViewChildFrame:(BTTabbarView*)tabbarView;

@end


@protocol BTTabbarViewDataSource <NSObject>

@required

- (NSInteger)btTabbarViewNumOfData:(BTTabbarView*)tabbarView;

- (UIView*)btTabbarView:(BTTabbarView*)tabbarView viewForIndex:(NSInteger)index;

@end


@interface BTTabbarView : UIView

@property (nonatomic, assign, readonly) NSInteger nowIndex;

@property (nonatomic, weak) id<BTTabbarViewDelegate> delegate;

@property (nonatomic, weak) id<BTTabbarViewDataSource> dataSource;

- (void)reloadData;

- (void)selectWithIndex:(NSInteger)index;

- (UIView*)indexWithChildView:(NSInteger)index;

@end





NS_ASSUME_NONNULL_END
