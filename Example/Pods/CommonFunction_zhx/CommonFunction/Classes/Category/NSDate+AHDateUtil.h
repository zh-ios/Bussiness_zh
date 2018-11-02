
//
//  UIView+enlargeHitArea.h
//  ZHProject
//
//  Created by autohome on 2018/3/7.
//  Copyright © 2018年 autohome. All rights reserved.
//  日期处理工具类
#import <Foundation/Foundation.h>


@interface NSDate (AHDateUtil)

#pragma mark- Decomposing dates
@property (readonly) NSInteger year;    //某一日期的年份
@property (readonly) NSInteger month;   //某一日期的月份
@property (readonly) NSInteger day;     //某一日期的日
@property (readonly) NSInteger hour;    //某一日期的小时
@property (readonly) NSInteger minute;  //某一日期的分钟
@property (readonly) NSInteger seconds; //某一日期的秒
@property (readonly) NSInteger week;    //某一日期是这一年份中的第几周
@property (readonly) NSInteger weekday; //某一日期是周几 1 是 monday...

- (NSDate *)monthsAgo:(NSInteger)months;       //几个月前
- (NSDate *)monthsLater:(NSInteger)months;     //几个月后

- (NSDate *)daysAgo:(NSInteger)days;           //几天前
- (NSDate *)daysLater:(NSInteger)days;         //几天后

- (NSDate *)hoursAgo:(NSInteger)hours;         //几小时前
- (NSDate *)hoursLater:(NSInteger)hours;       //几小时后

- (NSDate *)minutesAgo:(NSInteger)minutes;     //几分钟前
- (NSDate *)minutesLater:(NSInteger)minutes;   //几分钟后

/*!
 @method
 @abstract          根据时间戳字符串生成一个日期
 @discussion        根据时间戳字符串生成一个日期
 @param string      时间戳字符串
 @return            日期
 */
+ (NSDate *)dateWithTimeIntervalString:(NSString *)string;

/*!
 @method
 @abstract          根据时间差值矫正时间
 @discussion        根据时间差值矫正时间
 @param interval    （服务器时间 - 本地时间）
 @return            矫正后的时间
 */
+ (NSDate *)dateWithDifferenceInterval:(NSTimeInterval)interval;

/*!
 @method
 @abstract   当前时间距给定时间的时间间隔
 @discussion 带差值的时间间隔计算
 @param standardDate 基准时间
        standardDate example："2015-6-9" | "2015-6-9 8:4:46" | "2015/6/9" | "2015/6/9 8:4:46" | "2015年7月8日" | "2015年7月8日 8时6分57秒"
 @param span    时间差值    （正常可传0，当计算服务器的时间差值时，可传递服务器时间差）(正数：standardDate后移|负数：standardDate提前)
 @return @{@"day" : @"", @"hour" : @"", @"minute" : @"", @"second" : @""} (时间差值的字典)
 */
+ (NSDictionary *)timeIntervalSinceDate:(NSString *)standardDate
                               withSpan:(NSTimeInterval)span;

/*!
 @method
 @abstract          生成一个日期
 @discussion        生成一个日期
 @param year        年
 @param month       月
 @param day         日
 @return            日期
 */
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day;

/*!
 @method
 @abstract          生成一个日期
 @discussion        生成一个日期
 @param year        年
 @param month       月
 @param day         日
 @param hour        时
 @param minute      分
 @param second      秒
 @return            日期
 */
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

/*!
 @method
 @abstract          计算某年某月的天数
 @discussion        计算某年某月的天数
 @param month       月
 @param year        年
 @return            这一个月的天数
 */
+ (NSInteger)daysOfMonth:(NSInteger)month
                  ofYear:(NSInteger)year;
+ (NSInteger)daysOfMonth:(NSInteger)month; //同上，“年”默认今年

/*!
 @method
 @abstract          计算某个日期当月天数
 @discussion        计算某个日期当月天数
 @param date        日期
 @return            日期对应当月天数
 */
+ (NSInteger)daysOfMonthWithDate:(NSDate *)date;

/*!
 @method
 @abstract          字符串转日期
 @discussion        字符串转日期
 @param dateString  日期字符串
        dateString example："2015-6-9" | "2015-6-9 8:4:46" | "2015/6/9" | "2015/6/9 8:4:46" | "2015年7月8日" | "2015年7月8日 8时6分57秒"
 @return            日期
 */
+ (NSDate *)dateWithString:(NSString *)dateString;

/*!
 @method
 @abstract              日期转字符串
 @discussion            日期转字符串
 @param formatString    返回的日期字符串格式
        formatString example："yyyy/MM/dd HH:mm:ss" | "yyyy/MM/dd" | "HH:mm:ss" | "yyyy年MM月dd日 HH时mm分ss秒" 等
 @return                日期字符串
 */
- (NSString *)dateTimeStringWithFormat:(NSString *)formatString;

#pragma mark- Comparing dates
/*!
 @method
 @abstract              比较两个日期是否是同一天
 @discussion            忽略掉具体时间
 @param aDate           被比较的日期
 @return                YES：是同一天 | NO：不是同一天
 */
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;

/*!
 @method
 @abstract              比较两个日期是否处在同一周
 @discussion            比较两个日期是否处在同一周
 @param aDate           被比较的日期
 @return                YES：是处在同一周 | NO：不处在同一周
 */
- (BOOL)isSameWeekAsDate:(NSDate *)aDate;

/*!
 @method
 @abstract              比较两个日期是否处在同一月
 @discussion            比较两个日期是否处在同一月
 @param aDate           被比较的日期
 @return                YES：是处在同一月 | NO：不处在同一月
 */
- (BOOL)isSameMonthAsDate:(NSDate *)aDate;

/*!
 @method
 @abstract              比较两个日期是否处在同一年
 @discussion            比较两个日期是否处在同一年
 @param aDate           被比较的日期
 @return                YES：是处在同一年 | NO：不处在同一年
 */
- (BOOL)isSameYearAsDate:(NSDate *)aDate;

/*!
 @method
 @abstract              比较是否比某个日期早
 @discussion            比较是否比某个日期早
 @param aDate           被比较的日期
 @return                YES：比aDate早 | NO：不比aDate早
 */
- (BOOL)isEarlierThanDate:(NSDate *)aDate;

/*!
 @method
 @abstract              比较是否比某个日期晚
 @discussion            比较是否比某个日期晚
 @param aDate           被比较的日期
 @return                YES：比aDate晚 | NO：不比aDate晚
 */
- (BOOL)isLaterThanDate:(NSDate *)aDate;

/*!
 @method
 @abstract              判断某个日期是否是闰年
 @discussion            判断某个日期是否是闰年
 @return                YES：是闰年 | NO：不是闰年
 */
- (BOOL)isLeapYear;

/*!
 @method
 @abstract              获取当前日期明天的日期
 @discussion            获取当前日期明天的日期
 */
+ (NSDate *)tomorrow;

/*!
 @method
 @abstract              获取当前日期昨天的日期
 @discussion            获取当前日期昨天的日期
 */
+ (NSDate *)yesterday;

- (BOOL)isTypicallyWeekend; //判断某一天是否是周末  （周一至周五视为工作日）
- (BOOL)isTypicallyWorkday; //判断某一天是否是工作日（周一至周五视为工作日）


/*!
 @method
 @abstract   NSDate 转化 NSString
 @discussion NSDate 转化 NSString
 */
+ (NSString *)changeFromDateToString:(NSDate *)senderDate ForMat:(NSString *)formatStr;

/*!
 @method
 @abstract   NSString 转化 NSDate
 @discussion NSString 转化 NSDate
 */
+ (NSDate *)changeFromStringToDate:(NSString *)senderString ForMat:(NSString *)formatStr;

+ (NSDictionary *)theLeftFromNetTimeSinceNow:(NSString *)endDate;

/**
 *  获取服务器时间
 *
 *  @param interval 服务器时间 - 本地时间
 *
 *  @return 根据服务器时间与本地时间的时间差来获取服务器时间
 */
+ (NSDate *)serverDateWidthInterval:(NSTimeInterval)interval;


@end
