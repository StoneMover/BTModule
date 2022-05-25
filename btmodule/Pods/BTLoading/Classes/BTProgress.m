//
//  BTProgress.m
//  loadinghelp
//
//  Created by stonemover on 2018/8/11.
//  Copyright © 2018年 StoneMover. All rights reserved.
//

#import "BTProgress.h"
#import "BTLoadingConfig.h"

@interface BTProgress()<BTLoadingHelpDelegate>

@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;

@property (nonatomic, strong) UILabel * loadingLabel;

@property (nonatomic, strong) UIView * rootView;

@property (nonatomic, strong) NSString * content;

@end


@implementation BTProgress

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (BTProgress*)showLoading:(NSString*_Nullable)str
            forceCloseLast:(BOOL)forceCloseLast
                parentView:(UIView*)view{
    if (forceCloseLast) {
        BTProgress * progress=[[BTProgress alloc]init:str];
        [progress show:view];
        return progress;
    }
    
    
    BTProgress * progress = nil;
    for (UIView * v in view.subviews) {
        if ([v isKindOfClass:[BTProgress class]]) {
            progress = ((BTProgress*)v);
            break;
        }
    }
    if (progress == nil) {
        progress= [[BTProgress alloc]init:str];
        [progress show:view];
    }else{
        [progress setValue:str forKey:@"content"];
        [progress layoutSubviews];
    }
    
    
    return progress;
    
}


+ (BTProgress*)showLoading:(NSString*_Nullable)str forceCloseLast:(BOOL)forceCloseLast{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    return [self showLoading:str forceCloseLast:forceCloseLast parentView:window];
}

+ (BTProgress*)showLoading:(NSString*_Nullable)str{
    return [self showLoading:str forceCloseLast:YES];
}

+ (BTProgress*)showLoading:(NSString *)str inParentView:(UIView*)view{
    return [self showLoading:str forceCloseLast:YES parentView:view];
}

+ (BTProgress*)showLoading{
    return [self showLoading:nil forceCloseLast:YES];
}

+ (BTProgress*)showLoadingFollow{
    return [self showLoading:nil forceCloseLast:NO];
}

+ (BTProgress*)showLoadingFollow:(NSString*_Nullable)str{
    return [self showLoading:str forceCloseLast:NO];
}

+ (void)hideLoading{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    [self hideLoading:window];
}

+ (void)hideLoading:(UIView*)parentView{
    for (UIView * view in parentView.subviews) {
        if ([view isKindOfClass:[BTProgress class]]) {
            [((BTProgress*)view) hide];
        }
    }
}

- (instancetype)init:(NSString*_Nullable)content{
    self=[super init];
    self.content=content;
    if (self.content.length==0) {
        self.content=nil;
    }
    [self initSelf];
    return self;
}

- (void)initSelf{
    [[BTLoadingConfig share]addDelegate:self];
    [self initRootView];
    [self initIndicatorView];
    [self initLabel];
}

- (void)initRootView{
    self.rootView=[[UIView alloc] init];
    self.rootView.alpha=0;
    self.rootView.backgroundColor = BTLoadingConfig.share.progressStyle.backgroudColor;
    self.rootView.layer.cornerRadius=BTLoadingConfig.share.progressStyle.backgroundCorner;
    [self addSubview:self.rootView];
}

- (void)initIndicatorView{
    self.indicatorView=[[UIActivityIndicatorView alloc] init];
    self.indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    self.indicatorView.color = BTLoadingConfig.share.progressStyle.progressColor;
    [self.rootView addSubview:self.indicatorView];
}

- (void)initLabel{
    self.loadingLabel=[[UILabel alloc] init];
    self.loadingLabel.textColor=BTLoadingConfig.share.progressStyle.textColor;
    self.loadingLabel.font=BTLoadingConfig.share.progressStyle.textFont;
    self.loadingLabel.textAlignment=NSTextAlignmentCenter;
    self.loadingLabel.text=self.content;
    self.loadingLabel.numberOfLines=0;
    [self.loadingLabel sizeToFit];
    CGFloat labelMaxW=[UIScreen mainScreen].bounds.size.width/3;
    if (self.loadingLabel.frame.size.width>labelMaxW) {
        CGFloat h=[self calculateStrHeight:self.content withWidth:labelMaxW withFont:self.loadingLabel.font];
        self.loadingLabel.frame=CGRectMake(0, 0, labelMaxW, h);
    }
    
    [self.rootView addSubview:self.loadingLabel];
}

- (void)setContent:(NSString *)content{
    _content = content;
    self.loadingLabel.text = content;
    [self.loadingLabel sizeToFit];
}

- (void)layoutSubviews{
    [self layoutLoading];
}

- (void)layoutLoading{
    CGFloat width=85;
    CGFloat height=80;
    
    if (self.content) {
        CGFloat padding=15;
        CGFloat labelTop=6;
        if (self.loadingLabel.frame.size.width+padding*2>width) {
            width=self.loadingLabel.frame.size.width+padding*2;
        }
        CGFloat totalHeight=37+self.loadingLabel.frame.size.height+padding*2+labelTop;
        if (totalHeight>height) {
            height=totalHeight;
        }
        
        self.rootView.frame=CGRectMake(self.frame.size.width/2-width/2, self.frame.size.height/2-height, width, height);
        self.rootView.center=CGPointMake(self.frame.size.width/2, (self.frame.size.height-[BTLoadingConfig share].keyboardHeight)/2);
        self.indicatorView.center=CGPointMake(width/2, padding+37/2);
        self.loadingLabel.frame=CGRectMake(padding, 37+padding+labelTop, self.loadingLabel.frame.size.width, self.loadingLabel.frame.size.height);
        
    }else{
        self.rootView.frame=CGRectMake(self.frame.size.width/2-width/2, self.frame.size.height/2-height, width, height);
        self.rootView.center=CGPointMake(self.frame.size.width/2, (self.frame.size.height-[BTLoadingConfig share].keyboardHeight)/2);
        self.indicatorView.center=CGPointMake(width/2, height/2);
    }
}

- (void)show:(UIView*)view{
    for (UIView * v in view.subviews) {
        if ([v isKindOfClass:[BTProgress class]]) {
            [((BTProgress*)v) hide];
        }
    }
    self.frame=view.bounds;
    [view addSubview:self];
    [self.indicatorView startAnimating];
    [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.rootView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)hide{
    [UIView animateWithDuration:.2 animations:^{
        self.rootView.alpha=0;
    } completion:^(BOOL finished) {
        [self.indicatorView stopAnimating];
        [[BTLoadingConfig share]removeDelegate:self];
        [self removeFromSuperview];
    }];
}

-(CGFloat)calculateStrHeight:(NSString*)str withWidth:(CGFloat)width withFont:(UIFont*)font{
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize labelSize =[str boundingRectWithSize:CGSizeMake(width, 1500) options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil].size;
    return labelSize.height;
}

- (void)BTLoadingKeyboardHeightChange{
    [UIView animateWithDuration:.25 animations:^{
        self.rootView.center=CGPointMake(self.frame.size.width/2, (self.frame.size.height-[BTLoadingConfig share].keyboardHeight)/2);
    }];
}

@end
