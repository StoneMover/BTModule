//
//  ChatListCell.h
//  word
//
//  Created by liao on 2022/5/16.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatFriendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatListCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *redPointView;

@property (nonatomic, strong) ChatFriendModel * model;

@end

NS_ASSUME_NONNULL_END
