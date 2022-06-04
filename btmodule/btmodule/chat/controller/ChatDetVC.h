//
//  ChatDetVC.h
//  word
//
//  Created by liao on 2022/5/18.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "BTViewController.h"
#import "ChatFriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatDetVC : BTPageLoadViewController

@property (nonatomic, strong) ChatFriendModel * friendModel;

@end

NS_ASSUME_NONNULL_END
