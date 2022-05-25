//
//  HomeVC.m
//  btmodule
//
//  Created by kds on 2022/5/25.
//

#import "HomeVC.h"

@interface HomeVC ()

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation HomeVC


#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bt_initTitle:@"BTModule"];
    self.dataArray = @[@"地区选择"];
}


#pragma mark 初始化

#pragma mark 点击事件

#pragma mark 相关方法

#pragma mark 网络请求

@end
