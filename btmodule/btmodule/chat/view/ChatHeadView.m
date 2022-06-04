//
//  ChatHeadView.m
//  word
//
//  Created by liao on 2022/5/25.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "ChatHeadView.h"
#import <BTHelp/BTHelp.h>

@implementation ChatHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.finishLabel = [UILabel new];
    self.finishLabel.text = @"以下为全部数据";
    self.finishLabel.font = [UIFont BTAutoFontWithSize:12];
    self.finishLabel.textColor = UIColor.lightGrayColor ;
    self.finishLabel.hidden = YES;
    
    self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.tintColor = BTTheme.mainColor;
    [self addSubview:self.finishLabel];
    [self addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    return self;
}


- (void)layoutSubviews{
    [self.finishLabel sizeToFit];
    self.finishLabel.center = self.center;
    self.indicatorView.center = self.center;
}


- (void)setLoadFinish{
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
    self.finishLabel.hidden = NO;
}


@end
