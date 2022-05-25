//
//  NSDate+BTDate.h
//  live
//
//  Created by stonemover on 2019/5/8.
//  Copyright © 2019 stonemover. All rights reserved.
//


/***
 
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S：毫秒
 
 扩展方法生成的对象都是在格林尼治时间基础上加了时区的秒数差值
 所以使用扩展对象获取时间戳的时候需要减去时区差值，才为格林尼治时间戳，直接调用bt_timeIntervalSince1970获取
 
 用字符串转日期的时候formatter的timeZone不会自动加上相差的秒数，只能自己加上时区的间隔秒数后生成新的date才正确
 用日期转字符串的时候formatter的timeZone起作用且为手机本地时区，会将date对象自动加上与格林尼治时区的差值
 如果formatter的timeZone为UTC（格林尼治时区）则差值为0不会改变date，date显示的是多少转出来的就是多少
 
 **/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (BTDate)

/// 获取当前对象的年份，仅支持校正时区差值后的对象调用
- (NSString*)bt_year;

/// 获取当前对象的月份，仅支持校正时区差值后的对象调用
- (NSString*)bt_month;

/// 获取当前对象的为几号，仅支持校正时区差值后的对象调用
- (NSString*)bt_day;

/// 获取当前对象的小时，仅支持校正时区差值后的对象调用
- (NSString*)bt_hour;

/// 获取当前对象的分钟，仅支持校正时区差值后的对象调用
- (NSString*)bt_minute;

/// 获取当前对象的秒数，仅支持校正时区差值后的对象调用
- (NSString*)bt_second;

/// 英文的周几字符串
- (NSString*)bt_weekDay;

/// 数字周几，0是周日
- (NSInteger)bt_weekDayNum;


/// 传入头部字符串如周和星期，如果传回周会返回周一、周二..周日等字符串，传星期会返回星期一、星期二..星期天字符串
/// @param head 需要拼接的字符串，比如周、星期
- (NSString*)bt_weekDayNumStrWithHead:(NSString*)head;


/// 计算年龄,生成当前date类,传入年月日即可
/// @param year 出生年
/// @param month 出生月
/// @param day 出生日
- (NSInteger)bt_calculateAge:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/// 计算当前对象距离当前时间的年龄，使用bt_initLocalDate初始化当前时间
- (NSInteger)bt_calculateAgeFromNow;


/// 当前对象是否是未来时间
- (BOOL)bt_isFutureTime;

/// 得到距离系统当前时间的显示时间,比如一小时前,三分钟前,时间格式:yyyy-MM-dd HH:mm:ss,仅支持校正时区差值后的对象调用
- (NSString*)bt_dateFromNowStr;

/// 获取日期字符串,仅支持校正时区差值后的对象调用
- (NSString*)bt_dateStr:(NSString*)formater;

/// 是否是同年、同月、同日、同时、同分
- (BOOL)bt_isSameYearToDate:(NSDate*)date;

- (BOOL)bt_isSameMonthToDate:(NSDate*)date;

- (BOOL)bt_isSameDayToDate:(NSDate*)date;

- (BOOL)bt_isSameHourToDate:(NSDate*)date;

- (BOOL)bt_isSameMinuteToDate:(NSDate*)date;

#pragma mark 根据出传入日期以及格式化样式获取date


/// 根据时区获取对应的date，以下获取方法都会自动校正时区，中国时区会比调用系统方法生成的对象多出8个小时
+ (instancetype)bt_initLocalDate;

/// 会自动增加时区差值秒数
+ (instancetype)bt_dateWithTimeIntervalSince1970:(NSTimeInterval)secs;

/// 传入2010-01-01 这个字符串获取date，会自动增加时区差值
+ (NSDate*)bt_dateYMD:(NSString*)dateStr;

/// 传入2010-01-01 13:04:34 这个字符串获取date，会自动增加时区差值
+ (NSDate*)bt_dateYMDHMS:(NSString*)dateStr;

/// 传入2010-01-01 13:04 这个字符串获取date，会自动增加时区差值
+ (NSDate*)bt_dateYMDHM:(NSString*)dateStr;

/// 传入日期,以及格式化样式获取date，会自动增加时区差值
+ (NSDate*)bt_dateFromStr:(NSString*)dateStr formatter:(NSString*)formatterStr;

/// 传入日期,以及格式化样式获取date，不会自动增加时区差值
+ (NSDate*)bt_dateFromStrWithOutTimeZone:(NSString*)dateStr formatter:(NSString*)formatterStr;

/// 获取时区时差秒数
+ (NSInteger)bt_timeZoneSeconods;


/// 仅限校正时区后的对象使用，会减去时区相差的秒数，得到格林尼治时间的时间戳
- (NSTimeInterval)bt_timeIntervalSince1970;


/// 获取当前对象月份天数
- (NSInteger)bt_monthDay;

/// 获取季度天数
- (NSInteger)bt_seasonDay;

/// 获取当前对象年份天数
- (NSInteger)bt_yearDay;

/// 获取当前为第几季
- (NSInteger)bt_nowSeason;

/// 获取当前为第几周
- (NSInteger)bt_nowWeekNum;

/// 获取两个时间相差几天
- (NSInteger)bt_calculateDayToDate:(NSDate*)date;

@end

NS_ASSUME_NONNULL_END
