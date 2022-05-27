//
//  BTAreaListVC.h
//  btmodule
//
//  Created by kds on 2022/5/26.
//  地区手机号选择功能，后面可以加上搜索功能


#import <BTCore/BTViewController.h>
#import "BTAreaModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTAreaListVC : BTPageLoadViewController

@property (nonatomic, copy) BTVcSuccessBlock block;

@end

NS_ASSUME_NONNULL_END
