//
//  ChatListCell.m
//  word
//
//  Created by liao on 2022/5/16.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "ChatListCell.h"
#import "BTHttp.h"
#import <BTHelp/BTHelp.h>

@implementation ChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.iconImgView.backgroundColor = BTTheme.mainColor;
    self.iconImgView.BTCorner = self.iconImgView.BTWidth / 2.0;
    self.redPointView.BTCorner = self.redPointView.BTWidth / 2.0;
    self.iconImgView.BTBorderWidth = 0.5;
    self.iconImgView.BTBorderColor = UIColor.bt_235Color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ChatFriendModel *)model{
    _model = model;
    self.messageLabel.text = model.last_msg;
    self.nameLabel.text = model.user.user_name;
    self.iconImgView.backgroundColor = UIColor.bt_main_color;
    
    NSDate * date = [NSDate bt_dateYMDHMS:model.last_msg_dt];
    NSInteger day = [date bt_calculateDayToDate:[NSDate bt_initLocalDate]];
    if (day == 0) {
        self.timeLabel.text = [date bt_dateStr:@"HH:mm"];
    }else if (day == 1){
        self.timeLabel.text = @"昨天";
    }else{
        self.timeLabel.text = [date bt_dateStr:@"yy/MM/dd"];
    }
    self.redPointView.hidden = model.is_read == 1;
}

@end
