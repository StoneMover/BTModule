//
//  EmojHelp.h
//  mingZhong
//
//  Created by apple on 2021/3/29.
//

#import <Foundation/Foundation.h>
#import <BTHelp/BTHelp.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmojHelp : NSObject

+ (instancetype)share;

@property (nonatomic, strong, readonly) NSArray * emojNames;

@property (nonatomic, strong, readonly) NSArray * imgNames;

//行
@property (nonatomic, assign, readonly) NSInteger row;

//列
@property (nonatomic, assign, readonly) NSInteger column;

- (NSString*)getImgName:(NSString*)emoj;

- (BOOL)isEmojStr:(NSString*)eomjStr;

+ (NSMutableAttributedString*)emojData:(NSString*)str;

@end


@interface EmojModel : BTModel

@property (nonatomic, strong) NSString * emojName;

@property (nonatomic, strong) NSString * imgName;

@property (nonatomic, assign) NSInteger location;

@end



NS_ASSUME_NONNULL_END
