//
//  ChatModel.h
//  word
//
//  Created by liao on 2022/5/21.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "BTModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatModel : BTModel

@property (nonatomic, readonly, class) NSArray * defaultArray;

/// 消息字符串
@property (nonatomic, strong) NSString * message;

/// cell的高度
@property (nonatomic, assign) CGFloat cellHeight;

/// 消息父view的宽度
@property (nonatomic, assign) CGFloat messageViewW;

/// 消息发送自
@property (nonatomic, strong) NSString * from_user_id;

/// 创建时间
@property (nonatomic, strong) NSString * create_dt;

/// 消息id
@property (nonatomic, strong) NSString * msg_id;

/// 消息的富文本内容
@property (nonatomic, strong) NSMutableAttributedString * contentAttributed;

/// 0:聊天类型;1:时间类型
@property (nonatomic, assign) NSInteger cellType;

/// 时间类型显示的时间字符串
@property (nonatomic, strong) NSString * displayTimeStr;


- (instancetype)initTimeTypeWithDate:(NSDate*)date;

@end

NS_ASSUME_NONNULL_END
