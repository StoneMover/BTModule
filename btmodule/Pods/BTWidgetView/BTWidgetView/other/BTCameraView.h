//
//  BTCameraView.h
//  BTWidgetViewExample
//
//  Created by duang on 2021/10/9.
//  Copyright © 2021 stone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(11.0))

@interface BTCameraView : UIView

@property (nonatomic, copy) void (^resultImgBlock)(UIImage * img);

- (void)start;

- (void)stop;

- (void)makePhoto;

@end

NS_ASSUME_NONNULL_END
