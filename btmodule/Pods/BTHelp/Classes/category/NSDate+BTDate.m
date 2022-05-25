//
//  NSDate+BTDate.m
//  live
//
//  Created by stonemover on 2019/5/8.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "NSDate+BTDate.h"

@implementation NSDate (BTDate)

- (NSString*)bt_year{
    return [self bt_dateStr:@"yyyy"];
}

- (NSString*)bt_month{
    return [self bt_dateStr:@"MM"];
}

- (NSString*)bt_day{
    return [self bt_dateStr:@"dd"];
}

- (NSString*)bt_hour{
    return [self bt_dateStr:@"HH"];
}

- (NSString*)bt_minute{
    return [self bt_dateStr:@"mm"];
}

- (NSString*)bt_second{
    return [self bt_dateStr:@"ss"];
}

- (NSString*)bt_weekDay{
    return [self bt_dateStr:@"EEEE"];
}

- (NSInteger)bt_weekDayNum{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:self];
    return [comps weekday] - 1;
}

- (NSString*)bt_weekDayNumStrWithHead:(NSString*)head{
    NSInteger index = [self bt_weekDayNum];
    NSArray * weekDayStrArray = nil;
    if ([head isEqualToString:@"周"]) {
        weekDayStrArray =  @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }else{
        weekDayStrArray =  @[@"天",@"一",@"二",@"三",@"四",@"五",@"六"];
    }
    NSString * weekStr = weekDayStrArray[index];
    return [NSString stringWithFormat:@"%@%@",head,weekStr];
}

- (NSInteger)bt_calculateAge:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    NSInteger age =[self bt_year].integerValue-year;
    if (month>[self bt_month].integerValue) {
        age--;
    }else if (month==[self bt_month].integerValue){
        if (day>[self bt_day].integerValue) {
            age--;
        }
    }
    
    return age;
}

- (NSInteger)bt_calculateAgeFromNow{
    NSDate * dateNow = [NSDate bt_initLocalDate];
    return [self bt_calculateAge:dateNow.bt_year.integerValue month:dateNow.bt_month.integerValue day:dateNow.bt_day.integerValue];
}

- (BOOL)bt_isFutureTime{
    NSDate *localeDate = [NSDate bt_initLocalDate];
    if (self.timeIntervalSince1970 > localeDate.timeIntervalSince1970) {
        return YES;
    }
    return NO;
}


- (NSString*)bt_dateFromNowStr{
    
    NSDate * dateNow = [NSDate bt_initLocalDate];
    if ([self bt_isSameDayToDate:dateNow]) {
        return [self bt_dateStr:@"HH:mm"];
    }
    
    if (![self bt_isSameYearToDate:dateNow]) {
        return [self bt_dateStr:@"yyyy-MM-dd"];
    }
    
    return [self bt_dateStr:@"MM-dd HH:mm"];
}

- (NSString*)bt_dateStr:(NSString*)formater{
    NSDateFormatter * formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    formatter.dateFormat=formater;
    NSString * str = [formatter stringFromDate:self];
    return str;
}

- (BOOL)bt_isSameYearToDate:(NSDate*)date{
    NSString * strSelf = [self bt_dateStr:@"yyyy"];
    NSString * strDate = [date bt_dateStr:@"yyyy"];
    return [strSelf isEqualToString:strDate];
}

- (BOOL)bt_isSameMonthToDate:(NSDate*)date{
    NSString * strSelf = [self bt_dateStr:@"yyyy-MM"];
    NSString * strDate = [date bt_dateStr:@"yyyy-MM"];
    return [strSelf isEqualToString:strDate];
}

- (BOOL)bt_isSameDayToDate:(NSDate*)date{
    NSString * strSelf = [self bt_dateStr:@"yyyy-MM-dd"];
    NSString * strDate = [date bt_dateStr:@"yyyy-MM-dd"];
    return [strSelf isEqualToString:strDate];
}

- (BOOL)bt_isSameHourToDate:(NSDate*)date{
    NSString * strSelf = [self bt_dateStr:@"yyyy-MM-dd HH"];
    NSString * strDate = [date bt_dateStr:@"yyyy-MM-dd HH"];
    return [strSelf isEqualToString:strDate];
}

- (BOOL)bt_isSameMinuteToDate:(NSDate*)date{
    NSString * strSelf = [self bt_dateStr:@"yyyy-MM-dd HH:mm"];
    NSString * strDate = [date bt_dateStr:@"yyyy-MM-dd HH:mm"];
    return [strSelf isEqualToString:strDate];
}

+ (instancetype)bt_initLocalDate{
    NSDate * date = [[NSDate alloc] init];
    NSDate * localeDate = [date dateByAddingTimeInterval:[self bt_timeZoneSeconods]];
    return localeDate;
}

+ (instancetype)bt_dateWithTimeIntervalSince1970:(NSTimeInterval)secs{
    return [NSDate dateWithTimeIntervalSince1970:secs + [self bt_timeZoneSeconods]];
}

+ (NSDate*)bt_dateYMD:(NSString*)dateStr{
    return [self bt_dateFromStr:dateStr formatter:@"yyyy-MM-dd"];
}



+ (NSDate*)bt_dateYMDHMS:(NSString*)dateStr{
    return [self bt_dateFromStr:dateStr formatter:@"yyyy-MM-dd HH:mm:ss"];
}


+ (NSDate*)bt_dateYMDHM:(NSString*)dateStr{
    return [self bt_dateFromStr:dateStr formatter:@"yyyy-MM-dd HH:mm"];
}

+ (NSDate*)bt_dateFromStr:(NSString*)dateStr formatter:(NSString*)formatterStr{
    NSDateFormatter * formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat=formatterStr;
    NSDate * date = [formatter dateFromString:dateStr];
    NSDate * localeDate = [date dateByAddingTimeInterval: [self bt_timeZoneSeconods]];
    return localeDate;
}

+ (NSDate*)bt_dateFromStrWithOutTimeZone:(NSString*)dateStr formatter:(NSString*)formatterStr{
    NSDateFormatter * formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat=formatterStr;
    NSDate * date = [formatter dateFromString:dateStr];
    return date;
}


+ (NSInteger)bt_timeZoneSeconods{
    NSDate * date = [[NSDate alloc] init];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return interval;
}

- (NSTimeInterval)bt_timeIntervalSince1970{
    return self.timeIntervalSince1970 - [NSDate bt_timeZoneSeconods];
}


- (NSInteger)bt_monthDay{
    NSCalendar * calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

- (NSInteger)bt_seasonDay{
    NSInteger totalDay = 0;
    
    NSInteger season = [self bt_nowSeason];
    NSInteger basic = (season - 1) * 3;
    for (int i = 0; i<3; i++) {
        NSInteger month = i + 1 + basic;
        NSDate * date = [NSDate bt_dateYMD:[NSString stringWithFormat:@"%@-%02ld-01",self.bt_year,(long)month]];
        totalDay += date.bt_yearDay;
    }
    
    return totalDay;
}


- (NSInteger)bt_yearDay{
    NSCalendar * calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
    return range.length;
}


- (NSInteger)bt_nowSeason{
    NSString * month = [self bt_dateStr:@"MM"];
    NSInteger season = month.integerValue / 3 + 1;
    return season;
}

- (NSInteger)bt_nowWeekNum{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitWeekdayOrdinal;
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:self];
    return [comps weekdayOrdinal];
}


- (NSInteger)bt_calculateDayToDate:(NSDate*)date{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;
    NSDateComponents * delta = [calendar components:unit fromDate:self toDate:date options:0];
    return delta.day;
}

@end
