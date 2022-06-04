//
//  NSString+BTString.h
//  BTHelpExample
//
//  Created by apple on 2020/6/28.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BTString)

//返回156*****8016电话
- (NSString*)bt_phoneEncrypt;

//是否全部为数字
- (BOOL)bt_isStrAllNumber;

///是否为手机号码，只会判断是否全部为数字，并且长度为11位
- (BOOL)bt_isPhoneNumber;

//该字符串中有多少数字
- (NSInteger)bt_countNumInStr;

//该字符串中有多少字母字符，包括大小写
- (NSInteger)bt_countLetterInStr;

//该字符串中有多少大写字母
- (NSInteger)bt_countUppercaseLetterInStr;

//该字符串中有多少小写字母
- (NSInteger)bt_countLowercaseLetterInStr;

//该字符串中有多少非字母、数字字符
- (NSInteger)bt_countOtherInStr;

//是否为浮点型数据
- (BOOL)bt_isPureFloat;

//加密&解密
- (NSString*)bt_base64Decode;

- (NSString*)bt_base64Encode;

- (NSString*)bt_md5;

///计算文字高度,传入文字的固定高度、字体、行间距参数
- (CGFloat)bt_calculateStrHeight:(CGFloat)width font:(UIFont*)font;

- (CGFloat)bt_calculateStrHeight:(CGFloat)width font:(UIFont*)font lineSpeace:(CGFloat)lineSpeace;

///计算文字宽度，传入文字的固定高度
- (CGFloat)bt_calculateStrWidth:(CGFloat)height font:(UIFont*)font;

//将字典转为字符串
- (nullable NSDictionary *)bt_toDict;

- (nullable NSArray<NSDictionary *> *)bt_toArray;

//获取domain（ip）
- (nullable NSString*)bt_host;

- (NSDictionary*)bt_urlParameters;

+ (NSString*)bt_randomStr;

+ (NSString *)bt_randomStrWithLenth:(NSInteger)lenth;

+ (NSString *)bt_randomNumStrWithLenth:(NSInteger)lenth;

+ (NSString *)bt_randomCapitalStrWithLenth:(NSInteger)lenth;

+ (NSString *)bt_randomLowercaseStrWithLenth:(NSInteger)lenth;

+ (NSString *)bt_randomStrWithLenth:(NSInteger)lenth isNumber:(BOOL)isNumber isCapital:(BOOL)isCapital isLowercase:(BOOL)isLowercase;

+ (NSString *)bt_integer:(NSInteger)integerValue;

+ (NSString *)bt_float:(CGFloat)floatValue;

///获取随机的整数，包含from和to
+ (NSString *)bt_randomNum:(NSInteger)from to:(NSInteger)to;

/// startIndex: 多少个字符串前可以看到,last多少个字符串后可以看到
- (NSString *)bt_subWithClearStrWithStartIndex:(NSInteger)startIndex last:(NSInteger)last;


@end

NS_ASSUME_NONNULL_END
