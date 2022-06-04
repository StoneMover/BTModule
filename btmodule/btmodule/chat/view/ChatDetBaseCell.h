//
//  ChatDetBaseCell.h
//  word
//
//  Created by liao on 2022/5/21.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSInteger,ChatDetLocalType) {
    ChatDetLocalTypeLeft = 0,
    ChatDetLocalTypeRight
};

/// 消息view的默认宽度
static  CGFloat messageDefaultViewWidth = 0;

/// 水平方向各个控件的间距
static const CGFloat itemPadding = 15;


/// 消息view距离cell顶部和底部的间距
static const CGFloat messageVeiwTopBottomMargin = 12;

@interface ChatDetBaseCell : UITableViewCell

@property (nonatomic,class,readonly) CGFloat iconSize;

/// 默认的消息宽度
@property (nonatomic,class,readonly) CGFloat messageViewWidth;


@property (nonatomic, strong) UIImageView * iconImgView;

@property (nonatomic, strong) UIView * messageView;

@property (nonatomic, strong) UIButton * iconBtn;

@property (nonatomic, strong) ChatModel * model;

@property (nonatomic, strong) NSLayoutConstraint * messageViewWConstraint;


+ (void)calculateModelCell:(ChatModel*)model;

- (void)initSubView:(ChatDetLocalType)type;

@end

NS_ASSUME_NONNULL_END
