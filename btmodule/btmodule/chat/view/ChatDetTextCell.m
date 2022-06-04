//
//  ChatDetTextCell.m
//  word
//
//  Created by liao on 2022/5/21.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "ChatDetTextCell.h"
#import "BTHttp.h"
#import "EmojHelp.h"

@implementation ChatDetTextCell

+ (void)calculateModelCell:(ChatModel *)model{
    
    NSMutableAttributedString * attributedString = [EmojHelp emojData:model.message];
    
    UIFont * font = [UIFont BTAutoFontWithSize:16 weight:UIFontWeightRegular];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 4 - (font.lineHeight - font.pointSize);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attributedString.length)];
    
    CGFloat height = [attributedString boundingRectWithSize:CGSizeMake([self messageViewWidth] - 20, 1500) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    model.contentAttributed = attributedString;
    
    
//    CGFloat height = [model.message bt_calculateStrHeight:[self messageViewWidth] - 20
//                                                     font:[UIFont BTAutoFontWithSize:14 weight:UIFontWeightRegular]
//                                               lineSpeace:4];
    height++;
    
    if (height + messageVeiwTopBottomMargin < [self iconSize]) {
        model.cellHeight = [self iconSize] + messageVeiwTopBottomMargin * 2;
        
        model.messageViewW = [attributedString boundingRectWithSize:CGSizeMake(1500, 1500) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
        model.messageViewW += 21;
        return;
    }
    
    height = height + 20 + messageVeiwTopBottomMargin * 2;
    model.cellHeight = height;
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
    
    return self;
}



- (void)initSubView:(ChatDetLocalType)type{
    if (self.contentLabel) {
        return;
    }
    [super initSubView:type];
    self.contentLabel = [UILabel new];
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = [UIFont BTAutoFontWithSize:14 weight:UIFontWeightRegular];
    self.contentLabel.textColor = [UIColor bt_RGBSame:11];
    [self.messageView addSubview:self.contentLabel];
    [self.contentLabel bt_addLeftToParentWithPadding:10];
    [self.contentLabel bt_addRightToParentWithPadding:-10];
    [self.contentLabel bt_addCenterYToParent];
}

- (void)setModel:(ChatModel *)model{
    [super setModel:model];
//    [self.contentLabel bt_setText:model.message lineSpacing:4];
    self.contentLabel.attributedText = model.contentAttributed;
    if (self.messageViewWConstraint.constant != model.messageViewW) {
        self.messageViewWConstraint.constant = model.messageViewW;
    }
    
}

@end
