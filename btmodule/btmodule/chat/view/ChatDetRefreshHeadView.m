//
//  ChatDetRefreshHeadView.m
//  word
//
//  Created by liao on 2022/5/22.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "ChatDetRefreshHeadView.h"
#import <BTHelp/BTHelp.h>

@implementation ChatDetRefreshHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)placeSubviews{
    [super placeSubviews];
    
    
    self.loadingView.BTCenterX = self.BTWidth / 2;
    self.loadingView.BTCenterY = self.BTHeight / 2;
    self.arrowView.frame = CGRectZero;
}

- (void)setState:(MJRefreshState)state{
    [super setState:state];
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    
    
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.arrowView.hidden = YES;
    
}

- (void)endRefreshing{
    [super endRefreshing];
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.arrowView.hidden = YES;
    self.loadingView.hidden = NO;
}

@end
