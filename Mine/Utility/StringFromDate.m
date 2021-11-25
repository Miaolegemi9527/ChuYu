//
//  StringFromDate.m
//  Mine
//
//  Created by 廖毅 on 15/12/15.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "StringFromDate.h"

// 1天的长度
static const NSTimeInterval oneDay = 24 * 60 * 60;

@implementation StringFromDate

//将当前时间转成字符串 格式yyyy-MM-dd
+(NSString *)stringFromDateFromCurrent
{
    //1获取日期
    NSDate *currentDate = [NSDate date];
    //2创建格式化类对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //3设置样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //4转换 NSDate转换成字符串
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    return currentDateString;
}
//将时间转成字符串 格式yyyy-MM-dd
+(NSString *)stringFromDateFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringfromDate = [dateFormatter stringFromDate:date];
    return stringfromDate;
}
//获取今天之前的相应天数
+(NSString *)stringFromDateBeforeToday:(NSInteger)day
{
//    NSDate *currentDate = [NSDate date];
//    NSString *theDayBeforeTodayStr;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
//    return theDayBeforeTodayStr;
    
    NSString *stringDate = @"";
    NSDate *now = [NSDate date];
    NSDate *theDate;
    if (day != 0) {
        theDate = [now initWithTimeIntervalSinceNow:(-oneDay * day)];
    } else
    {
        theDate = now;
    }
    stringDate = [StringFromDate stringFromDateFromDate:theDate];
    return stringDate;

    
}

@end
