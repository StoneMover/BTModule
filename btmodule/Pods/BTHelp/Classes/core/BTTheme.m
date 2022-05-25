//
//  BTTheme.m
//  BTHelpExample
//
//  Created by kds on 2022/4/6.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "BTTheme.h"
#import "UIColor+BTColor.h"

@implementation NSObject (BTTheme)

- (void)bt_themeRefresh{
    
}

@end

@interface BTTheme()

@property (nonatomic, strong) NSPointerArray * registerArray;

@property (nonatomic, assign) NSInteger compactIndex;

@property (nonatomic, strong) NSMutableDictionary * colorDict;

@end

@implementation BTTheme


+ (instancetype)share{
    static BTTheme * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BTTheme new];
    }) ;
    return instance;
}

+ (nullable UIImage*)imageWithName:(NSString*)imageName{
    return [BTTheme.share imageWithName:imageName];
}

+ (nullable UIColor*)colorWithName:(NSString*)colorName{
    return [BTTheme.share colorWithName:colorName];
}

+ (UIColor*)mainColor{
    UIColor * color = [BTTheme.share colorWithName:@"bt_main_color"];
    if (color == nil) {
        color = UIColor.redColor;
    }
    
    return color;
}

+ (UIColor*)mainActionColor{
    UIColor * color = [BTTheme.share colorWithName:@"bt_main_action_color"];
    if (color == nil) {
        color = [self mainColor];
    }
    
    return color;
}


- (instancetype)init{
    self = [super init];
    self.registerArray = [NSPointerArray weakObjectsPointerArray];
    self.colorDict = [NSMutableDictionary new];
    return self;
}


- (void)initThemeDict:(NSDictionary*)dict{
    _nowTheme = @"default";
    [self.colorDict removeAllObjects];
    NSArray * allKey = dict.allKeys;
    
    for (int i = 0; i < allKey.count; i++) {
        NSString * key = allKey[i];
        NSDictionary * dictTheme = [dict objectForKey:key];
        [self createColorArrayWithDict:dictTheme theme:key];
    }
}

- (void)createColorArrayWithDict:(NSDictionary*)dict theme:(NSString*)theme{
    NSArray * allKey = dict.allKeys;
    for (int i = 0; i < allKey.count; i++) {
        NSString * key = allKey[i];
        NSString * colorValue = [dict objectForKey:key];
        UIColor * color = [UIColor bt_colorWithHexString:colorValue];
        [self.colorDict setObject:color forKey:[theme stringByAppendingString:key]];
    }
}

- (BOOL)isDefualtTheme{
    return [_nowTheme isEqualToString:@"default"];
}


- (void)registerRefreshWithObj:(NSObject*)obj{
    if (![obj respondsToSelector:@selector(bt_themeRefresh)]) {
        return;
    }
    self.compactIndex++;
    if (self.compactIndex > 5) {
        self.compactIndex = 0;
        //这里不添加会导致compact无效
        [self.registerArray addPointer:nil];
        [self.registerArray compact];
    }
    
    [self.registerArray addPointer:(__bridge void *)obj];
}

- (UIImage *)imageWithName:(NSString *)imageName{
    if ([self isDefualtTheme]) {
        return [UIImage imageNamed:imageName];
    }
    
    NSString * imageNameResult = [imageName stringByAppendingFormat:@"_%@",_nowTheme];;
    
    UIImage * img = [UIImage imageNamed:imageNameResult];
    
    if (!img) {
        return [UIImage imageNamed:imageName];
    }
    
    return img;
}

- (UIColor *)colorWithName:(NSString *)colorName{
    UIColor * defaultThemeColor = [self.colorDict objectForKey:[self.nowTheme stringByAppendingString:colorName]];
    if (defaultThemeColor == nil) {
        defaultThemeColor = [self.colorDict objectForKey:[@"default" stringByAppendingString:colorName]];
    }
    return defaultThemeColor;
    
}

- (void)changeTheme:(NSString *)theme{
    if ([_nowTheme isEqualToString:theme]) {
        return;
    }
    
    _nowTheme = theme;
    for (NSObject * obj in self.registerArray) {
        [UIView animateWithDuration:0.5 animations:^{
            [obj bt_themeRefresh];
        }];
        
    }
}

- (void)addThemeColor:(NSString*)theme color:(UIColor*)color colorName:(NSString*)colorName{
    [self.colorDict setObject:color forKey:[theme stringByAppendingString:colorName]];
}

@end




