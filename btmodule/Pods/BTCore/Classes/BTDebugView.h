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

NS_ASSUME_NONNULL_BEGIN

@interface BTDebugView : UIView

+ (void)show;

@end


@interface BTApiCell : UITableViewCell



@end

@interface BTApiVC : BTPageLoadViewController



@end


@interface BTDebugPageVC : BTPageViewController


@end




NS_ASSUME_NONNULL_END
