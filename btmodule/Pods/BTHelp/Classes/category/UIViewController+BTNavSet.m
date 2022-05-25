//
//  UIViewController+BTNavSet.m
//  BTHelpExample
//
//  Created by kds on 2022/4/14.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "UIViewController+BTNavSet.h"
#import "UIView+BTViewTool.h"
#import "UIImage+BTImage.h"
#import "BTUtils.h"
#import "BTTheme.h"

@implementation UIViewController (BTNavSet)

- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                            color:(UIColor*)color
                             font:(UIFont*)font
                           target:(nullable id)target
                           action:(nullable SEL)action{
    UIBarButtonItem * item=[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    return item;
}

- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                           target:(nullable id)target
                           action:(nullable SEL)action{
    return [self bt_createItemStr:title color:BTTheme.mainColor font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] target:target action:action];
}

- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                           action:(nullable SEL)action{
    return [self bt_createItemStr:title color:BTTheme.mainColor font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] target:self action:action];
}

- (UIBarButtonItem*)bt_createItemImg:(UIImage*)img
                           action:(nullable SEL)action{
    return [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:action];
}

- (UIBarButtonItem*)bt_createItemImg:(UIImage*)img
                           target:(nullable id)target
                           action:(nullable SEL)action{
    return [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:target action:action];
}


- (void)bt_initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    self.title=title;
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance * app = self.navigationItem.standardAppearance;
        if (app == nil) {
            app = [UINavigationBar.appearance.standardAppearance copy];
        }
        app.titleTextAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:color};
        self.navigationItem.scrollEdgeAppearance = app;
        self.navigationItem.standardAppearance = app;
        
        return;
    }
}
- (void)bt_initTitle:(NSString *)title color:(UIColor *)color{
    [self bt_initTitle:title color:color font:BTNavConfig.share.defaultNavTitleFont];
}
- (void)bt_initTitle:(NSString *)title{
    [self bt_initTitle:title color:BTNavConfig.share.defaultNavTitleColor font:BTNavConfig.share.defaultNavTitleFont];
}


- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    UIBarButtonItem * item=[self bt_createItemStr:title color:color font:font target:self action:@selector(bt_rightBarClick)];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem=item;
    return item;
}
- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title color:(UIColor*)color{
    return [self bt_initRightBarStr:title color:color font:BTNavConfig.share.defaultNavRightBarItemFont];
}
- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title{
    return [self bt_initRightBarStr:title color:BTNavConfig.share.defaultNavRightBarItemColor];
}
- (UIBarButtonItem*)bt_initRightBarImg:(UIImage*)img{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(bt_rightBarClick)];
    self.navigationItem.rightBarButtonItem = item;
    return item;
}
- (void)bt_rightBarClick;{
    
}


- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    UIBarButtonItem * item = [self bt_createItemStr:title color:color font:font target:self action:@selector(bt_leftBarClick)];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem = item;
    return item;
}
- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title color:(UIColor*)color{
    return [self bt_initLeftBarStr:title color:color font:BTNavConfig.share.defaultNavLeftBarItemFont];
}
- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title{
    return [self bt_initLeftBarStr:title color:BTNavConfig.share.defaultNavLeftBarItemColor];
}
- (UIBarButtonItem*)bt_initLeftBarImg:(UIImage*)img{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(bt_leftBarClick)];
    self.navigationItem.leftBarButtonItem = item;
    return item;
}
- (void)bt_leftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type str:(NSArray<NSString*>*)strs{
    NSMutableArray * btns = [NSMutableArray new];
    NSInteger index = 0;
    for (NSString * str in strs) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:[self bt_customeStrColor:type index:index] forState:UIControlStateNormal];
        btn.titleLabel.font = [self bt_customeFont:type index:index];
        [btn setTitle:str forState:UIControlStateNormal];
        [btns addObject:btn];
        index++;
    }
    return [self bt_initCustomeItem:type views:btns];
}

- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type img:(NSArray<UIImage*>*)imgs{
    NSMutableArray * btns = [NSMutableArray new];
    for (UIImage * img in imgs) {
        UIButton * btn = [UIButton new];
        [btn setImage:img forState:UIControlStateNormal];
        [btns addObject:btn];
    }
    return [self bt_initCustomeItem:type views:btns];
}

- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type views:(NSArray<UIView*>*)views{
    UIView * parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, BTUtils.NAVCONTENT_HEIGHT)];
    CGFloat startX = 0;
    for (int i=0; i<views.count; i++) {
        UIView * childView = views[i];
        startX += [self bt_customePadding:type index:i];
        CGSize size = [self bt_customeItemSize:type index:i];
        childView.frame = CGRectMake(startX, (BTUtils.NAVCONTENT_HEIGHT - size.height) / 2, size.width, size.height);
        startX += size.width;
        [parentView addSubview:childView];
        UIButton * btn = nil;
        if ([childView isKindOfClass:[UIButton class]]) {
            btn = (UIButton*)childView;
        }else{
            btn = [[UIButton alloc] initWithFrame:childView.frame];
            [childView addSubview:btn];
        }
        btn.tag = i;
        if (type == NavItemTypeRight) {
            [btn addTarget:self action:@selector(bt_customeItemRightClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if(type == NavItemTypeLeft){
            [btn addTarget:self action:@selector(bt_customeItemLeftClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    parentView.BTWidth = startX;
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:parentView];
    if (type == NavItemTypeRight) {
        self.navigationItem.rightBarButtonItem = item;
    }else if(type == NavItemTypeLeft){
        self.navigationItem.leftBarButtonItem = item;
    }
    return parentView.subviews;
}

- (CGSize)bt_customeItemSize:(NavItemType)type index:(NSInteger)index{
    return CGSizeMake(36, 44);
}
- (CGFloat)bt_customePadding:(NavItemType)type index:(NSInteger)index{
    return 0;
}

- (UIFont*)bt_customeFont:(NavItemType)type index:(NSInteger)index{
    if (type == NavItemTypeLeft) {
        return BTNavConfig.share.defaultNavLeftBarItemFont;
    }
    return BTNavConfig.share.defaultNavRightBarItemFont;
}

- (UIColor*)bt_customeStrColor:(NavItemType)type index:(NSInteger)index{
    if (type == NavItemTypeLeft) {
        return BTNavConfig.share.defaultNavLeftBarItemColor;
    }
    return BTNavConfig.share.defaultNavRightBarItemColor;
}

- (void)bt_customeItemLeftClick:(UIButton*)btn{
    [self bt_customeItemClick:NavItemTypeLeft index:btn.tag];
}

- (void)bt_customeItemRightClick:(UIButton*)btn{
    [self bt_customeItemClick:NavItemTypeRight index:btn.tag];
}

- (void)bt_customeItemClick:(NavItemType)type index:(NSInteger)index{
    
}

- (void)bt_setItemPaddingDefault{
    [self bt_setItemPadding:[self bt_NavItemPadding:NavItemTypeLeft]
            rightPadding:[self bt_NavItemPadding:NavItemTypeRight]];
}

- (void)bt_setItemPadding:(CGFloat)padding{
    [self bt_setItemPadding:padding rightPadding:padding];
}

- (void)bt_setItemPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding{
    UINavigationBar * navBar=self.navigationController.navigationBar;
    if (@available(iOS 12.0, *)) {
        UIView * contentView = nil;
        for (UIView * view in navBar.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:@"_UINavigationBarContentView"]) {
                contentView = view;
                break;
            }
        }
        
        UILayoutGuide * backButtonGuide = nil;
        UILayoutGuide * trailingBarGuide = nil;
        
        for (UILayoutGuide * guide in contentView.layoutGuides) {
//            NSLog(@"%@",guide.identifier);
            if ([guide.identifier hasPrefix:@"BackButtonGuide"]) {
                backButtonGuide = guide;
            }
            
            if ([guide.identifier hasPrefix:@"TrailingBarGuide"]) {
                trailingBarGuide = guide;
            }
            
        }
        
        if (self.navigationItem.rightBarButtonItem || self.navigationItem.rightBarButtonItems) {
            NSArray * array = [trailingBarGuide constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
            for (NSLayoutConstraint * c in array) {
                
                NSString * className = NSStringFromClass([c class]);
                if (BTNavConfig.share.navItemPaddingBlock(c) && [className isEqualToString:@"NSLayoutConstraint"]) {
//                    NSLog(@"shuai:%@",c);
                    if (c.constant > 0) {
                        c.constant=rightPadding;
                    }else{
                        c.constant=-rightPadding;
                    }
                    break;
                }
            }
        }
        
        NSArray * array = [backButtonGuide constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
        for (NSLayoutConstraint * c in array) {
//                NSLog(@"shuai:%@",c);
            NSString * className = NSStringFromClass([c class]);
            if (BTNavConfig.share.navItemPaddingBlock(c) && [className isEqualToString:@"NSLayoutConstraint"]) {
                if (c.constant > 0) {
                    c.constant=leftPadding;
                }else{
                    c.constant=-leftPadding;
                }
                break;
            }
        }
        
        
        
        return;
    }
    
    for (UIView * view in navBar.subviews) {
        for (NSLayoutConstraint *c  in view.constraints) {
//            NSLog(@"%f",c.constant);
            if (BTNavConfig.share.navItemPaddingBlock(c)) {
                if (c.constant > 0) {
                    c.constant=leftPadding;
                }else{
                    c.constant=-leftPadding;
                }
            }
        }
    }
}

- (void)bt_setNavTrans{
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance * app = self.navigationItem.standardAppearance;
        if (app == nil) {
            app = [UINavigationBar.appearance.standardAppearance copy];
        }
        [app configureWithTransparentBackground];
        app.backgroundImage = [UIImage bt_imageWithColor:UIColor.clearColor size:CGSizeMake(BTUtils.SCREEN_W, BTUtils.NAV_HEIGHT)];
        app.backgroundColor = UIColor.clearColor;
        self.navigationItem.scrollEdgeAppearance = app;
        self.navigationItem.standardAppearance = app;
        self.navigationController.navigationBar.translucent = YES;
        return;
    }
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage bt_imageWithColor:UIColor.clearColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setClipsToBounds:YES];
    self.navigationController.navigationBar.backgroundColor=UIColor.clearColor;
}

- (void)bt_setNavBgColor:(UIColor*)color{
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance * app = self.navigationItem.standardAppearance;
        if (app == nil) {
            app = [UINavigationBar.appearance.standardAppearance copy];
        }
        [app configureWithDefaultBackground];
        app.backgroundImage = [UIImage bt_imageWithColor:color size:CGSizeMake(BTUtils.SCREEN_W, BTUtils.NAV_HEIGHT)];
        app.backgroundColor = color;
        self.navigationItem.scrollEdgeAppearance = app;
        self.navigationItem.standardAppearance = app;
        return;
    }
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage bt_imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setClipsToBounds:NO];
    self.navigationController.navigationBar.backgroundColor=color;
}

- (void)bt_setNavBgImg:(UIImage*)bgImg{
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance * app = self.navigationItem.standardAppearance;
        if (app == nil) {
            app = [UINavigationBar.appearance.standardAppearance copy];
        }
        [app configureWithDefaultBackground];
        app.backgroundImage = bgImg;
        self.navigationItem.scrollEdgeAppearance = app;
        self.navigationItem.standardAppearance = app;
        return;
    }
    
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setClipsToBounds:NO];
    
}

- (void)bt_setNavLineHide{
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance * app = self.navigationItem.standardAppearance;
        if (app == nil) {
            app = [UINavigationBar.appearance.standardAppearance copy];
        }
        app.shadowColor = UIColor.clearColor;
        self.navigationItem.scrollEdgeAppearance = app;
        self.navigationItem.standardAppearance = app;
        return;
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)bt_setNavLineColor:(UIColor*)color{
    [self bt_setNavLineColor:color height:.5];
}

- (void)bt_setNavLineColor:(UIColor*)color height:(CGFloat)height{
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance * app = self.navigationItem.standardAppearance;
        if (app == nil) {
            app = [UINavigationBar.appearance.standardAppearance copy];
        }
        app.shadowColor = color;
        self.navigationItem.scrollEdgeAppearance = app;
        self.navigationItem.standardAppearance = app;
        return;
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage bt_imageWithColor:color size:CGSizeMake(BTUtils.SCREEN_W, height)]];
}

/// RTRootNav下的自动返回按钮生成方法，如果不是使用的该库则在每个VC下需要自己调用bt_initLeftBar生成返回按钮
- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{
    [self bt_setItemPaddingDefault];
    UIBarButtonItem * item = [self bt_createItemImg:[self bt_backImg] action:@selector(bt_leftBarClick)];
    return item;
}



- (CGFloat)bt_NavItemPadding:(NavItemType)type{
    return BTNavConfig.share.navItemPadding;
}


- (UIImage*)bt_backImg{
    return [UIImage bt_imageOriWithName:@"bt_nav_back"];
}

@end
