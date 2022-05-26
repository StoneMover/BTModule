//
//  BTAreaListVC.h
//  btmodule
//
//  Created by kds on 2022/5/26.
//

#import <BTCore/BTViewController.h>
#import "BTAreaModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTAreaListVC : BTPageLoadViewController

@property (nonatomic, copy) BTVcSuccessBlock block;

@end

NS_ASSUME_NONNULL_END
