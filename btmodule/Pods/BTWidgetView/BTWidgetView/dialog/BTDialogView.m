//
//  SMListDialogView.m
//  Base
//
//  Created by whbt_mac on 16/1/5.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "BTDialogView.h"
#import <BTHelp/BTHelp.h>
#import <BTHelp/UIFont+BTFont.h>

@interface BTDialogView()

//需要展示的view
@property(strong, nonatomic) UIView * showView;

//用来监听点击消失手势的按钮
@property(strong, nonatomic) UIButton * btnBg;

//透明的黑色
@property(strong, nonatomic) UIView * bgBlackColor;

//动画样式
@property (nonatomic,assign) BTDialogAnimStyle animStyle;

//位置对象
@property (nonatomic, assign) BTDialogLocation location;

//键盘监听工具
@property (nonatomic, strong) BTKeyboardHelp * keyboardHelp;

@end

@implementation BTDialogView

#pragma mark 初始化方法


-(instancetype)init:(UIView*)showView withLocation:(BTDialogLocation)location{
    self=[super init];
    self.location=location;
    self.showView=showView;
    [self initDialog];
    return self;
}

-(instancetype)init:(UIView*)showView{
    return [self init:showView withLocation:BTDialogLocationCenter];
}


//初始化弹框
-(void)initDialog{
    //设置颜色背景
    self.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.clickEmptyAreaDismiss=YES;
    
    //设置透明层
    self.bgBlackColor=[[UIView alloc]init];
    self.bgBlackColor.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    self.bgBlackColor.alpha=0;
    [self addSubview:self.bgBlackColor];
    
    //设置消失点击按钮
    self.btnBg=[[UIButton alloc]init];
    [self.btnBg addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnBg];
    
    [self addSubview:self.showView];
}




-(void)layoutSubviews{
    self.bgBlackColor.frame=self.bounds;
    self.btnBg.frame=self.bounds;
}



#pragma mark show & dismiss & destory

-(void)show:(UIView *)view{
    [self show:view withAnimStyle:BTDialogAnimStyleStyleDefault];
}

-(void)show:(UIView *)view withAnimStyle:(BTDialogAnimStyle)style{
    [view addSubview:self];
    self.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    self.animStyle=style;
    
    switch (self.location) {
        case BTDialogLocationCenter:
            self.showView.center=CGPointMake(self.BTWidth/2, self.BTHeight/2-self.centerOffset);
            [self centerLocationShowAnim];
            break;
        case BTDialogLocationTop:
        {
            self.showView.frame=CGRectMake(0, -self.showView.BTHeight, self.showView.BTWidth, self.showView.BTHeight);
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.bgBlackColor.alpha=.5;
                [self.showView setAlpha:1];
                self.showView.frame=CGRectMake(0, 0, self.showView.BTWidth, self.showView.BTHeight);
            } completion:^(BOOL finished) {
                
            }];
            
        }
            break;
        case BTDialogLocationBottom:
        {
            self.showView.frame=CGRectMake(0, self.BTHeight, self.showView.BTWidth, self.showView.BTHeight);
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.bgBlackColor.alpha=.5;
                [self.showView setAlpha:1];
                self.showView.frame=CGRectMake(self.showView.BTLeft, self.BTHeight-self.showView.BTHeight, self.showView.BTWidth, self.showView.BTHeight);
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
    }
}

- (void)setBgColor:(UIColor *)color{
    self.bgBlackColor.backgroundColor = color;
}

#pragma mark 显示动画
-(void)centerLocationShowAnim{
    switch (self.animStyle) {
        case BTDialogAnimStyleAndroid:{
            self.showView.alpha=0;
            self.showView.transform = CGAffineTransformMakeScale(.25f, .25f);
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.bgBlackColor.alpha=.5;
                self.showView.alpha=1;
                self.showView.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                
            }];
            
        }
            
            break;
        case BTDialogAnimStyleStyleDefault:{
            self.showView.alpha=0;
            self.showView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.showView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                self.showView.alpha = 1;
                self.bgBlackColor.alpha = .5;
            } completion:^(BOOL finished) {
                
            }];
        }
            
            break;
    }
}


#pragma mark 消失动画
-(void)dismiss{
    [self dismissAnimTime:0.3];
    
}

- (void)dismissAnimTime:(CGFloat)time{
    switch (self.location) {
        case BTDialogLocationCenter:
            [self dismissCenterAnim:time];
            break;
        case BTDialogLocationTop:
        {
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.bgBlackColor.alpha = 0;
                self.showView.frame=CGRectMake(self.showView.BTLeft,-self.showView.BTHeight, self.showView.BTWidth, self.showView.BTHeight);
            } completion:^(BOOL finished) {
                [self destory];
            }];
        }
            break;
        case BTDialogLocationBottom:
        {
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.bgBlackColor.alpha = 0;
                self.showView.frame=CGRectMake(self.showView.BTLeft, self.BTHeight, self.showView.BTWidth, self.showView.BTHeight);
            } completion:^(BOOL finished) {
                self.showView.alpha = 0;
                [self destory];
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)dismissCenterAnim:(CGFloat)time{
    switch (self.animStyle) {
        case BTDialogAnimStyleStyleDefault:
        {
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.showView.alpha = 0;
                self.bgBlackColor.alpha = 0;
            }completion:^(BOOL finished){
                [self destory];
            }];
        }
            break;
        case BTDialogAnimStyleAndroid:{
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.bgBlackColor.alpha = 0;
                self.showView.alpha=0;
                self.showView.transform=CGAffineTransformMakeScale(.25f, .25f);
            } completion:^(BOOL finished) {
                [self destory];
            }];
            
            
        }
            
        default:
            break;
    }
}



#pragma mark 销毁
-(void)destory{
    if (self.blockDismiss) {
        self.blockDismiss();
    }
    [self removeFromSuperview];
}

-(void)btnClick{
    if (self.clickEmptyAreaDismiss){
        if (self.isNeedMoveFollowKeyboard&&self.keyboardHelp.isKeyBoardOpen) {
            [self endEditing:YES];
            return;
        }
        [self dismiss];
    }
}

-(void)setCornerNum:(CGFloat)cornerNum{
    _cornerNum=cornerNum;
    self.showView.BTCorner=cornerNum;
}

- (void)setIsNeedMoveFollowKeyboard:(BOOL)isNeedMoveFollowKeyboard{
    [self setIsNeedMoveFollowKeyboard:isNeedMoveFollowKeyboard margin:18];
}

- (void)setIsNeedMoveFollowKeyboard:(BOOL)isNeedMoveFollowKeyboard margin:(CGFloat)margin{
    _isNeedMoveFollowKeyboard = isNeedMoveFollowKeyboard;
    if (isNeedMoveFollowKeyboard) {
        self.keyboardHelp = [[BTKeyboardHelp alloc] initWithShowView:self.showView moveView:self.showView margin:margin];
    }else{
        self.keyboardHelp = nil;
    }
}

@end


@implementation BTDialogNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
        [self configSubView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configSubView];
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    [self initSelf];
    return self;
}

- (void)initSelf{
    if (_leftBtn != nil) {
        return;
    }
    _leftBtn = [UIButton new];
    _centerLabel = [UILabel new];
    _rightBtn = [UIButton new];
    [self bt_addSubViewArray:@[self.leftBtn,self.centerLabel,self.rightBtn]];
    
}

- (void)configSubView{
    [self.leftBtn setTitle:self.leftBtnContentStr forState:[self getFontWeight:self.leftBtnTitleFontStyle]];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:self.rightBtnTitleFontSize weight:UIFontWeightMedium];
    [self.leftBtn setImage:self.leftBtnImg forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:self.leftBtnTitleColor forState:UIControlStateNormal];
    [self.leftBtn setTitle:self.leftBtnContentStr forState:UIControlStateNormal];
    
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.textColor = self.centerLabelColor;
    
    
    self.centerLabel.font = [UIFont systemFontOfSize:self.centerLabelFontSize weight:[self getFontWeight:self.centerLabelFontStyle]];
    self.centerLabel.text = self.centerLabelStr;
    
    [self.rightBtn setTitle:self.leftBtnContentStr forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont BTAutoFontWithSize:self.rightBtnTitleFontSize weight:self.rightBtnTitleFontStyle];
    
    [self.rightBtn setImage:self.rightBtnImg forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:self.rightBtnTitleColor forState:UIControlStateNormal];
    [self.rightBtn setTitle:self.rightBtnContentStr forState:UIControlStateNormal];
    
    
}

- (UIFontWeight)getFontWeight:(NSInteger)style{
    if (style == 0) {
        return UIFontWeightRegular;
    }
    
    if (style == 1) {
        return UIFontWeightMedium;
    }
    
    if (style == 2) {
        return UIFontWeightBold;
    }
    
    return UIFontWeightRegular;
}

- (void)layoutSubviews{
    
    
    if (self.leftBtnSize.width == 0 || self.leftBtnSize.height == 0) {
        [self.leftBtn sizeToFit];
        [self.leftBtn setBTLeft:self.leftBtnMargin];
        [self.leftBtn setBTCenterParentY];
    }else{
        self.leftBtn.frame = CGRectMake(0,
                                        0,
                                        self.leftBtnSize.width,
                                        self.leftBtnSize.height);
        [self.leftBtn setBTLeft:self.leftBtnMargin];
        [self.leftBtn setBTCenterParentY];
    }
    
    if (self.centerLabelSize.width == 0 || self.centerLabelSize.height == 0) {
        [self.centerLabel sizeToFit];
        [self.centerLabel setBTCenterParent];
    }else{
        self.centerLabel.frame = CGRectMake(0, 0, self.centerLabelSize.width, self.centerLabelSize.height);
        [self.centerLabel setBTCenterParent];
    }
    
    if (self.rightBtnSize.width == 0 || self.rightBtnSize.height == 0) {
        [self.rightBtn sizeToFit];
        [self.rightBtn setBTRight:self.BTWidth - self.rightBtnMargin];
        [self.rightBtn setBTCenterParentY];
    }else{
        self.rightBtn.frame = CGRectMake(0, 0, self.rightBtnSize.width, self.rightBtnSize.height);
        [self.rightBtn setBTRight:self.BTWidth - self.rightBtnMargin];
        [self.rightBtn setBTCenterParentY];
    }
    
    
}

@end
