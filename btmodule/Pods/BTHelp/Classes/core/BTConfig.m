//
//  BTConfig.m
//  BTHelpExample
//
//  Created by kds on 2022/4/14.
//  Copyright © 2022 stonemover. All rights reserved.
//

#import "BTConfig.h"
#import "UIFont+BTFont.h"
#import "UIColor+BTColor.h"

@implementation BTNavConfig

+ (nonnull BTNavConfig*)share{
    static BTNavConfig * config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[super allocWithZone:NULL] init];
    });
    return config;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
   return [BTNavConfig share] ;
}


- (id)copyWithZone:(NSZone *)zone {
    return [BTNavConfig share];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [BTNavConfig share];
}


- (instancetype)init{
    self = [super init];
    
    self.defaultNavTitleFont = [UIFont BTAutoFontWithSize:18 weight:UIFontWeightBold];
    self.defaultNavTitleColor = UIColor.bt_text_color;
    self.defaultNavLeftBarItemFont = [UIFont BTAutoFontWithSize:15 weight:UIFontWeightBold];
    self.defaultNavLeftBarItemColor = UIColor.bt_text_color1;
    self.defaultNavRightBarItemFont = [UIFont BTAutoFontWithSize:15 weight:UIFontWeightBold];
    self.defaultNavRightBarItemColor = UIColor.bt_text_color1;
    
    self.defaultNavLineColor = UIColor.bt_divider_color;
    self.defaultVCBgColor = UIColor.bt_bg_color;
    
    self.navItemPadding = 5;
    
    self.navItemPaddingBlock = ^BOOL(NSLayoutConstraint *constraint) {
        //375宽度屏幕左边距是8，右边距是-16
        if (fabs(constraint.constant)==8) {
            return YES;
        }
        
        if (fabs(constraint.constant)==16) {
            return YES;
        }
        
        
        //414宽度屏幕锁边距是12，右边距是-20
        if (fabs(constraint.constant)==12) {
            return YES;
        }
        
        if (fabs(constraint.constant) == 20) {
            return YES;
        }
        
        return NO;
    };
    
    return self;
}

@end



@implementation BTEnvModel


- (instancetype)initWithType:(BTDebugType)type url:(NSString*)url{
    self = [super init];
    self.type = type;
    self.url = url;

    switch (type) {
        case BTDebugTypeDev:
            self.identify = BTDebugTypeDevId;
            break;
        case BTDebugTypeTest:
            self.identify = BTDebugTypeTestId;
            break;
        case BTDebugTypeProduct:
            self.identify = BTDebugTypeProductId;
            break;

        default:
            break;
    }

    return self;
}

- (instancetype)initCustomeTypeWithIdentify:(NSString*)identify url:(NSString*)url{
    self = [super init];
    self.type = BTDebugTypeCustome;
    self.identify = identify;
    self.url = url;
    return self;
}

@end


@interface BTEnvMananger()

@property (nonatomic, strong) NSMutableArray * dataArray;

@end


@implementation BTEnvMananger

+ (nonnull BTEnvMananger *)share{
    static BTEnvMananger * mananger=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mananger = [[super allocWithZone:NULL] init];
    });
    return mananger;
}

+ (nullable BTEnvModel *)nowModel{
    for (BTEnvModel * model in BTEnvMananger.share.dataArray) {
        if (model.isSelect) {
            return model;
        }
    }

    return nil;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
   return [BTEnvMananger share] ;
}


- (id)copyWithZone:(NSZone *)zone {
    return [BTEnvMananger share];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [BTEnvMananger share];
}

- (instancetype)init{
    self = [super init];
    self.dataArray = [NSMutableArray new];
    [self initLocalData];
    return self;
}

- (void)initWithArray:(NSArray*)array{
    [self initWithArray:array selectIndex:0];
}

- (void)initWithArray:(NSArray *)array selectIndex:(NSInteger)index{
    if (self.dataArray.count != 0) {
        return;
    }

    [self.dataArray addObjectsFromArray:array];
    BTEnvModel * model = array[index];
    [self selectWithId:model.identify];
}

- (void)initLocalData{
    NSArray * array = [NSUserDefaults.standardUserDefaults objectForKey:@"BT_ENV_DATA"];
    if (array == nil || array.count == 0) {
        return;
    }

    for (NSDictionary * dict in array) {
        [self.dataArray addObject:[BTEnvModel modelWithDict:dict]];
    }

}

- (BOOL)isExist:(NSString*)identify{
    for (BTEnvModel * model in self.dataArray) {
        if ([model.identify isEqualToString:identify]) {
            return YES;
        }
    }

    return NO;
}

- (void)save{
    NSMutableArray * dictArray = [NSMutableArray new];
    for (BTEnvModel * model in self.dataArray) {
        [dictArray addObject:[model autoDataToDictionary]];
    }

    [NSUserDefaults.standardUserDefaults setObject:dictArray forKey:@"BT_ENV_DATA"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)addModel:(BTEnvModel*)model{
    if ([self isExist:model.identify]) {
        return;
    }

    [self.dataArray addObject:model];
    [self save];
}

- (void)deleteModel:(BTEnvModel*)model{
    for (BTEnvModel * m in self.dataArray) {
        if ([m.identify isEqualToString:model.identify]) {
            [self.dataArray removeObject:m];
            [self save];
            return;
        }
    }
}

- (void)selectWithId:(NSString*)identify{
    for (BTEnvModel * m in self.dataArray) {
        if ([m.identify isEqualToString:identify]) {
            m.isSelect = 1;
        }else{
            m.isSelect = 0;
        }
    }
    [NSNotificationCenter.defaultCenter postNotificationName:@"BT_ENV_CHANGE" object:nil];
    [self save];
}

- (void)clear{
    [self.dataArray removeAllObjects];
    [self save];
}

- (NSArray*)allEnv{
    return self.dataArray;
}

@end
