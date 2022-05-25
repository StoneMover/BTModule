//
//  BTLoadingHelp.m
//  moneyMaker
//
//  Created by Motion Code on 2019/2/13.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTLoadingConfig.h"
#import <BTHelp/UIImage+BTImage.h>
#import <BTHelp/UIColor+BTColor.h>

static BTLoadingConfig * help=nil;

@interface BTLoadingConfig()

@property (nonatomic, strong) NSMutableArray * delegates;

@end



@implementation BTLoadingConfig

+ (BTLoadingConfig*)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        help = [[super allocWithZone:NULL] init];
    });
    return help;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
   return [BTLoadingConfig share] ;
}


- (id)copyWithZone:(NSZone *)zone {
    return [BTLoadingConfig share];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [BTLoadingConfig share];
}



- (instancetype)init{
    self=[super init];
    self.toastStyle = [BTToastStyleItem defaultItem];
    self.progressStyle = [BTToastStyleItem defaultItem];
    self.delegates = [NSMutableArray new];
    self.loadingStr = @"加载中...";
    self.emptyStr = @"貌似这里什么都没有";
    self.errorInfo = @"似乎断开了与互联网的连接";
    self.loadingGif = [UIImage bt_animatedGIFNamed:@"bt_loading_icon" bundle:[NSBundle bundleForClass:[self class]]];
    self.errorImg = [BTLoadingConfig imageBundleName:@"bt_loading_error"];
    self.emptyImg = [BTLoadingConfig imageBundleName:@"bt_loading_empty"];
    [self initDefaultView];
    [self initNotification];
    return self;
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)initDefaultView{
    self.customLoadingViewBlock = ^BTLoadingSubView * _Nonnull{
        BTLoadingSubView * subView = [[BTLoadingSubView alloc] init];
        subView.contentLabel.text = BTLoadingConfig.share.loadingStr;
        subView.contentImgView.image = BTLoadingConfig.share.loadingGif;
        subView.reloadBtn.hidden = YES;
        subView.backgroundColor = [UIColor bt_R:240 G:242 B:245];
        return subView;
    };
    
    self.customEmptyViewBlock = ^BTLoadingSubView * _Nonnull{
        BTLoadingSubView * subView = [[BTLoadingSubView alloc] init];
        subView.contentLabel.text = BTLoadingConfig.share.emptyStr;
        subView.contentImgView.image = BTLoadingConfig.share.emptyImg;
        subView.backgroundColor = [UIColor bt_R:240 G:242 B:245];
        return subView;
    };
    
    self.customErrorViewBlock = ^BTLoadingSubView * _Nonnull{
        BTLoadingSubView * subView = [[BTLoadingSubView alloc] init];
        subView.contentLabel.text = BTLoadingConfig.share.errorInfo;
        subView.contentImgView.image = BTLoadingConfig.share.errorImg;
        subView.backgroundColor = [UIColor bt_R:240 G:242 B:245];
        return subView;
    };
    
}



- (void)addDelegate:(id)delegate{
    [self.delegates addObject:delegate];
}
- (void)removeDelegate:(id)delegate{
    [self.delegates removeObject:delegate];
}

#pragma mark 键盘监听
//当键盘消失的时候调用
- (void)keyboardWillHide:(NSNotification *)notif {
    _keyboardHeight=0;
    for (id del in self.delegates) {
        if ([del respondsToSelector:@selector(BTLoadingKeyboardHeightChange)]) {
            [del BTLoadingKeyboardHeightChange];
        }
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary * userInfo = [aNotification userInfo];
    NSValue * aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat h = keyboardRect.size.height;
    if (h==self.keyboardHeight) {
        return;
    }
    _keyboardHeight=h;
    for (id del in self.delegates) {
        if ([del respondsToSelector:@selector(BTLoadingKeyboardHeightChange)]) {
            [del BTLoadingKeyboardHeightChange];
        }
    }
}


+ (UIImage*)imageBundleName:(NSString*)name{
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    UIImage * img = [UIImage imageNamed:[NSString stringWithFormat:@"BTLoadingBundle.bundle/%@",name] inBundle:bundle compatibleWithTraitCollection:nil];
    return img;
}


@end



@implementation BTToastStyleItem

+ (instancetype)defaultItem{
    BTToastStyleItem * item = [BTToastStyleItem new];
    item.backgroudColor = [UIColor bt_RGBASame:0 A:0.85];
    item.textColor = UIColor.whiteColor;
    item.textFont = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    item.errorImg = [BTLoadingConfig imageBundleName:@"bt_toast_error"];
    item.warningsImg = [BTLoadingConfig imageBundleName:@"bt_toast_warning"];
    item.successImg = [BTLoadingConfig imageBundleName:@"bt_toast_success"];
    item.backgroundCorner = 5;
    return item;
}

+ (instancetype)defaultProgressItem{
    BTToastStyleItem * item = [BTToastStyleItem new];
    item.backgroudColor = [UIColor bt_RGBASame:0 A:0.85];
    item.textColor = UIColor.whiteColor;
    item.textFont = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    item.backgroundCorner = 8;
    item.progressColor = UIColor.whiteColor;
    return item;
}



@end
