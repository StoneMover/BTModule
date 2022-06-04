//
//  ChatFriendModel.h
//  word
//
//  Created by liao on 2022/5/22.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "BTModel.h"
#import "UserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatFriendModel : BTModel

/// 0为系统消息
@property (nonatomic, strong) NSString * friend_id;

@property (nonatomic, strong) NSString * last_msg_dt;

@property (nonatomic, strong) NSString * last_msg;

@property (nonatomic, strong) UserInfoModel * user;

/// 0:未读,1:已读
@property (nonatomic, assign) NSInteger is_read;

@end

NS_ASSUME_NONNULL_END
