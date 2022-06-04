//
//  BTTabbarLineTextView.h
//  mingZhong
//
//  Created by liao on 2022/5/6.
//

#import "BTTabbarView.h"

NS_ASSUME_NONNULL_BEGIN




@interface BTTabbarLineTextView : BTTabbarView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray<NSString*> *)titleArray;

@property (nonatomic, strong) UIFont * labelFont;

@property (nonatomic, strong) UIColor * normalColor;

@property (nonatomic, strong) UIColor * selectColor;

@property (nonatomic, strong) UIColor * lineColor;

@property (nonatomic, weak) id<BTTabbarViewDelegate> lineDelegate;

@end



typedef NS_ENUM(NSInteger,BTTabbarLineTextItemViewLocation) {
    BTTabbarLineTextItemViewTop = 0,
    BTTabbarLineTextItemViewBottom,
    BTTabbarLineTextItemViewLeft,
    BTTabbarLineTextItemViewRight
};


@interface BTTabbarLineTextItemView : UIView

@property (nonatomic, strong, nullable) UIView * topLineView;

@property (nonatomic, strong, nullable) UIView * leftLineView;

@property (nonatomic, strong, nullable) UIView * bottomLineView;

@property (nonatomic, strong, nullable) UIView * rightLineView;

@property (nonatomic, strong) UILabel * label;


- (void)initLineView:(BTTabbarLineTextItemViewLocation)type lineSize:(CGFloat)size color:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
