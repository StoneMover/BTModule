//
//  BTLoadingSubView.m
//  BTLoadingTest
//
//  Created by zanyu on 2019/8/13.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTLoadingSubView.h"
#import "BTLoadingConfig.h"
#import <BTHelp/UIColor+BTColor.h>
#import <BTHelp/BTHelp.h>
#import <BTHelp/UIView+BTConstraint.h>
#import <BTHelp/UIFont+BTFont.h>
#import <BTHelp/UIView+BTViewTool.h>

@implementation BTLoadingSubView

- (instancetype)init{
    self=[super init];
    self.backgroundColor = UIColor.whiteColor;
    [self initSubView];
    return self;
}

- (void)initSubView{
    [self initLabel];
    [self initImgView];
    [self initBtn];
}


- (void)initLabel{
    self.contentLabel = [UILabel new];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLabel.font = [UIFont BTAutoFontWithSize:16 weight:UIFontWeightMedium];
    self.contentLabel.textColor = [UIColor bt_RGBSame:120];
    [self addSubview:self.contentLabel];
    [self.contentLabel bt_addCenterToParent];
}


- (void)initImgView{
    self.contentImgView = [UIImageView new];
    self.contentImgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.contentImgView];
    [self.contentImgView bt_addCenterXToParent];
    [self.contentImgView bt_addBottomToItemView:self.contentLabel constant:-10 isSame:NO];
}

- (void)initBtn{
    self.reloadBtn = [UIButton new];
    self.reloadBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.reloadBtn.backgroundColor = [UIColor bt_colorWithHexString:@"#4c8edb"];
    self.reloadBtn.BTCorner = 8;
    self.reloadBtn.titleLabel.font = [UIFont BTAutoFontWithSize:16 weight:UIFontWeightMedium];
    [self.reloadBtn setTitle:@"点击重试" forState:UIControlStateNormal];
    [self.reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.reloadBtn addTarget:self action:@selector(reloadClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reloadBtn];
    [self.reloadBtn bt_addWidth:90];
    [self.reloadBtn bt_addHeight:35];
    [self.reloadBtn bt_addCenterXToParent];
    [self.reloadBtn bt_addTopToItemView:self.contentLabel constant:28];
}



- (void)reloadClick{
    if (self.reloadClickBlock == nil) {
        return;
    }
    self.reloadClickBlock();
}


- (void)show:(NSString*_Nullable)title
         img:(UIImage*_Nullable)img
      btnStr:(NSString*_Nullable)btnStr{
    self.hidden=NO;
    if (title) {
        self.contentLabel.text = title;
    }
    
    if (img) {
        self.contentImgView.image = img;
    }

    if (btnStr) {
        [self.reloadBtn setTitle:btnStr forState:UIControlStateNormal];
    }
    
}

- (void)hideLoading{
    self.hidden = YES;
}

@end
