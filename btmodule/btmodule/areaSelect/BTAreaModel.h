//
//  BTAreaModel.h
//  btmodule
//
//  Created by kds on 2022/5/26.
//

#import <BTHelp/BTModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTAreaModel : BTModel

@property (nonatomic, strong) NSString * countryCh;

@property (nonatomic, strong) NSString * country;

@property (nonatomic, strong) NSString * countryId;

@property (nonatomic, assign) NSInteger countryNum;

@property (nonatomic, strong) NSString * startStr;

@property (nonatomic, strong) NSString * pinYinStr;

@end


@interface BTAreaGroupModel : BTModel

@property (nonatomic, strong) NSString * pinYinStr;

@property (nonatomic, strong) NSString * startStr;

@property (nonatomic, strong) NSMutableArray * subArray;

@end

NS_ASSUME_NONNULL_END
