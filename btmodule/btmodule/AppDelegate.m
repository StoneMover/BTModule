//
//  AppDelegate.m
//  btmodule
//
//  Created by kds on 2022/5/25.
//

#import "AppDelegate.h"
#import <BTCore/BTViewController.h>
#import <BTHelp/UIImage+BTImage.h>
#import "HomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化主题
    NSString * path = [NSBundle.mainBundle pathForResource:@"BTThemeColor.plist" ofType:nil];
    NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    [BTTheme.share initThemeDict:dict];
    
    BTNavConfig.share.defaultVCBgColor = UIColor.bt_bg_color;
    BTNavConfig.share.defaultNavLineColor = UIColor.bt_divider_color;
    
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *app = [UINavigationBarAppearance new];
        [app configureWithDefaultBackground];
        
        app.backgroundColor = BTNavConfig.share.defaultVCBgColor;
        app.backgroundImage = [UIImage bt_imageWithColor:UIColor.whiteColor size:CGSizeMake(BTUtils.SCREEN_W, BTUtils.NAV_HEIGHT)];
        app.shadowColor = BTNavConfig.share.defaultNavLineColor;
        
        [UINavigationBar appearance].scrollEdgeAppearance = app;
        [UINavigationBar appearance].standardAppearance = app;
    }
    
    HomeVC * vc = [HomeVC new];
    BTNavigationController * nav = [[BTNavigationController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}




@end
