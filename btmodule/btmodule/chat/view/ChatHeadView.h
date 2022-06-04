//
//  ChatHeadView.h
//  word
//
//  Created by liao on 2022/5/25.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatHeadView : UIView

@property (nonatomic, strong) UILabel * finishLabel;

@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;

- (void)setLoadFinish;

@end

NS_ASSUME_NONNULL_END
