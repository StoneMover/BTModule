//
//  ChatDetTimeCell.m
//  word
//
//  Created by liao on 2022/5/29.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "ChatDetTimeCell.h"
#import <BTHelp/BTHelp.h>

@implementation ChatDetTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = UIColor.lightGrayColor;
    self.timeLabel.font = [UIFont BTAutoFontWithSize:15];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel bt_addCenterToParent];
    return self;
}

@end
