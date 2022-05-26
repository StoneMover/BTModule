//
//  BTAreaSectionView.m
//  btmodule
//
//  Created by kds on 2022/5/26.
//

#import "BTAreaSectionView.h"
#import <BTHelp/BTHelp.h>

@implementation BTAreaSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.bt_bg_color;
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont BTAutoFontWithSize:12];
    self.titleLabel.textColor = UIColor.bt_text_color1;
    [self addSubview:self.titleLabel];
    return self;
}

- (void)layoutSubviews{
    [self.titleLabel sizeToFit];
    self.titleLabel.BTCenterY = self.BTHeight / 2;
    self.titleLabel.BTLeft = 15;
}

@end
