//
//  AppDelegate.m
//  btmodule
//
//  Created by kds on 2022/5/25.
//

#import "AppDelegate.h"
#import <BTCore/BTViewController.h>
#import "HomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    HomeVC * vc = [HomeVC new];
    BTNavigationController * nav = [[BTNavigationController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}




@end
