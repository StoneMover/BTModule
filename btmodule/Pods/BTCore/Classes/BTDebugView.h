//
//  BTDebugView.h
//  BTCoreExample
//
//  Created by kds on 2022/4/18.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTViewController.h"
#import <BTWidgetView/BTPageViewController.h>
#import <BTWidgetView/BTTextField.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTDebugView : UIView

///手动调用立即弹出
+ (void)show;

///当前立即弹出，且下次启动后延迟5s自动弹出
+ (void)showNextOpen;

///是否会弹出debugView，如果是则不用将环境强制设置为发布环境
+ (BOOL)isShowNextOpen;
@end


@interface BTApiCell : UITableViewCell



@end

@interface BTApiVC : BTPageLoadViewController

- (void)showCreateDialog;

@end


@interface BTDebugPageVC : BTPageViewController


@end


@interface BTApiCrateView : UIView

@property (nonatomic, strong) BTTextField * apiUrlField;

@property (nonatomic, strong) BTTextField * imgUrlField;

@property (nonatomic, strong) BTTextField * otherField;

@end


NS_ASSUME_NONNULL_END
