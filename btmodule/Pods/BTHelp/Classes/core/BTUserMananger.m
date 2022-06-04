//
//  AccountMananger.m
//  Base
//
//  Created by whbt_mac on 15/9/17.
//  Copyright (c) 2015年 StoneMover. All rights reserved.
//

#import "BTUserMananger.h"

//指针和内容都不允许改变,如果写成 const NSString * str的形式,则只表示指针不可修改
NSString * const KEY_IS_FIRST_OPEN_APP =@"BT_KEY_IS_FIRST_OPEN_APP";

NSString * const KEY_ACCOUNT_CACHE =@"BT_KEY_ACCOUNT_CACHE";

NSString * const KEY_AUTO_LOGIN =@"BT_KEY_AUTO_LOGIN";

NSString * const KEY_REMERBER_PWD=@"BT_KEY_REMERBER_PWD";

NSString * const KEY_PWD=@"BT_KEY_PWD";

NSString * const KEY_USER_INFO=@"BT_KEY_USER_INFO";

NSString * const KEY_IS_NO_WIFI_DOWNLOAD=@"KEY_IS_NO_WIFI_DOWNLOAD";


@interface BTUserMananger()

@property (nonatomic, strong) NSUserDefaults * userDefaults;

@property (nonatomic, strong) Class userModelClass;

@end



@implementation BTUserMananger

+ (nonnull BTUserMananger *)share{
    static BTUserMananger * mananger=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mananger = [[super allocWithZone:NULL] init];
    });
    return mananger;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
   return [BTUserMananger share] ;
}


- (id)copyWithZone:(NSZone *)zone {
    return [BTUserMananger share];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [BTUserMananger share];
}



- (void)registerUserModel:(Class)userModelClass{
    if (self.userModelClass) {
        return;
    }
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * str = [self.userDefaults stringForKey:@"BT_USERMANANGER_INIT"];
    if (!str) {
        //程序第一次打开，设置部分默认值
        [self.userDefaults setObject:@"BT_USERMANANGER_INIT" forKey:@"BT_USERMANANGER_INIT"];
        self.isFirstOpenApp = YES;
    }
    
    
    self.isFirstOpenApp = [self.userDefaults boolForKey:KEY_IS_FIRST_OPEN_APP];
    self.isAllowNoWifiDownload = [self.userDefaults boolForKey:KEY_IS_NO_WIFI_DOWNLOAD];
    self.accountCache = [self.userDefaults objectForKey:KEY_ACCOUNT_CACHE];
    self.isAutoLogin = [self.userDefaults boolForKey:KEY_AUTO_LOGIN];
    self.isRemerberPwd = [self.userDefaults boolForKey:KEY_REMERBER_PWD];
    
    self.userModelClass = userModelClass;
    self.model = [userModelClass modelWithDict:[self.userDefaults dictionaryForKey:KEY_USER_INFO]];
}


-(void)setIsFirstOpenApp:(BOOL)isFirstOpenApp{
    _isFirstOpenApp=isFirstOpenApp;
    [self.userDefaults setBool:isFirstOpenApp forKey:KEY_IS_FIRST_OPEN_APP];
    [self.userDefaults synchronize];
}

-(void)setAccountCache:(NSString *)accountCache{
    _accountCache=accountCache;
    [self.userDefaults setValue:accountCache forKey:KEY_ACCOUNT_CACHE];
    [self.userDefaults synchronize];
}

-(void)setIsAutoLogin:(BOOL)isAutoLogin{
    _isAutoLogin=isAutoLogin;
    [self.userDefaults setBool:isAutoLogin forKey:KEY_AUTO_LOGIN];
    [self.userDefaults synchronize];
}

-(void)setIsRemerberPwd:(BOOL)isRemerberPwd{
    _isRemerberPwd=isRemerberPwd;
    [self.userDefaults setBool:isRemerberPwd forKey:KEY_REMERBER_PWD];
    [self.userDefaults synchronize];
}

- (void)updateUserInfo{
    NSDictionary * dic=[self.model autoDataToDictionary];
    [self.userDefaults setObject:dic forKey:KEY_USER_INFO];
    [self.userDefaults synchronize];
}


-(void)clearUserData{
//    self.isAllowNoWifiDownload=NO;
//    self.isAutoLogin=NO;
//    self.isRemerberPwd=NO;
    
    NSDictionary * dic = [[NSDictionary alloc]init];
    [self.userDefaults setObject:dic forKey:KEY_USER_INFO];
    [self.userDefaults synchronize];
    self.model = [self.userModelClass modelWithDict:dic];
}


-(BOOL)isLogin{
    if (self.model&&[self.model getUserId]&&[self.model getUserId].length>0) {
        return YES;
    }
    return NO;
}


- (BOOL)isLoginPush:(UINavigationController*)rootVc{
    return [self isLoginPush:rootVc isAnim:YES];
}

- (BOOL)isLoginPush:(UINavigationController*)rootVc isAnim:(BOOL)isAnim{
    BOOL islogin = [self isLogin];
    if (self.loginVcName && !self.isLogin) {
        Class cls = NSClassFromString(self.loginVcName);
        UIViewController *vc = [[cls alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            [rootVc pushViewController:vc animated:isAnim];
        }
    }
    return islogin;
}

- (BOOL)isLoginPresent:(UIViewController*)rootVc{
    return [self isLoginPresent:rootVc isAnim:YES];
}

- (BOOL)isLoginPresent:(UIViewController*)rootVc isAnim:(BOOL)isAnim{
    BOOL islogin = [self isLogin];
    if (self.loginVcName && !self.isLogin) {
        Class cls = NSClassFromString(self.loginVcName);
        UIViewController *vc = [[cls alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            [rootVc presentViewController:rootVc animated:isAnim completion:nil];
        }
    }
    return islogin;
}

- (NSUserDefaults*)userDefaults{
    return _userDefaults;
}

@end

@implementation BTUserModel

-(void)initSelf{
    [super initSelf];
}

- (NSString * _Nullable)getUserName{
    return @"";
}

- (NSString * _Nullable)getUserToken{
    return @"";
}

- (NSString * _Nullable)getUserId{
    return @"";
}

@end
