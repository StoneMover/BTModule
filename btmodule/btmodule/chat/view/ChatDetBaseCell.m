//
//  ChatDetBaseCell.m
//  word
//
//  Created by liao on 2022/5/21.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "ChatDetBaseCell.h"
#import <BTHelp/BTHelp.h>


@implementation ChatDetBaseCell

+ (CGFloat)iconSize{
    return 44;
}

+ (CGFloat)messageViewWidth{
    if (messageDefaultViewWidth == 0) {
        messageDefaultViewWidth = BTUtils.SCREEN_W - [self iconSize] * 2 - 60;
    }
    return messageDefaultViewWidth;
}

+ (void)calculateModelCell:(ChatModel*)model{
    
}

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self;
}

- (void)initSubView:(ChatDetLocalType)type{
    if (self.iconImgView) {
        return;
    }
    
    self.iconImgView = [UIImageView new];
    self.iconImgView.backgroundColor = BTTheme.mainColor;
    self.iconImgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconImgView.BTCorner = 22;
    [self.contentView addSubview:self.iconImgView];
    
    
    
    self.messageView = [UIView new];
    self.messageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageView.BTCorner = 4;
    self.messageView.backgroundColor = [UIColor bt_RGBSame:249];
    [self.contentView addSubview:self.messageView];
    
    self.iconBtn = [UIButton new];
    [self.contentView addSubview:self.iconBtn];
    [self.iconBtn bt_addLeftToItemView:self.iconImgView isSame:YES];
    [self.iconBtn bt_addTopToItemView:self.iconImgView isSame:YES];
    [self.iconBtn bt_addWidth:ChatDetBaseCell.iconSize];
    [self.iconBtn bt_addHeight:ChatDetBaseCell.iconSize];
    
    if (type == ChatDetLocalTypeLeft) {
        [self.iconImgView bt_addWidth:ChatDetBaseCell.iconSize];
        [self.iconImgView bt_addHeight:ChatDetBaseCell.iconSize];
        [self.iconImgView bt_addLeftToParentWithPadding:itemPadding];
        [self.iconImgView bt_addTopToParentWithPadding:messageVeiwTopBottomMargin];
        
        [self.messageView bt_addTopToParentWithPadding:messageVeiwTopBottomMargin];
        [self.messageView bt_addLeftToItemView:self.iconImgView constant:itemPadding];
        self.messageViewWConstraint = [self.messageView bt_addWidth:ChatDetBaseCell.messageViewWidth];
        [self.messageView bt_addBottomToParentWithPadding:-messageVeiwTopBottomMargin];
        return;
    }
    
    [self.iconImgView bt_addWidth:ChatDetBaseCell.iconSize];
    [self.iconImgView bt_addHeight:ChatDetBaseCell.iconSize];
    [self.iconImgView bt_addRightToParentWithPadding:-itemPadding];
    [self.iconImgView bt_addTopToParentWithPadding:messageVeiwTopBottomMargin];
    
    [self.messageView bt_addTopToParentWithPadding:messageVeiwTopBottomMargin];
    [self.messageView bt_addRightToItemView:self.iconImgView constant:-itemPadding isSame:NO];
    self.messageViewWConstraint = [self.messageView bt_addWidth:ChatDetBaseCell.messageViewWidth];
    [self.messageView bt_addBottomToParentWithPadding:-messageVeiwTopBottomMargin];
    
}



@end
