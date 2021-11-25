//
//  StringFromDate.h
//  Mine
//
//  Created by 廖毅 on 15/12/15.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringFromDate : NSObject

//将当前时间转成字符串 格式yyyy-MM-dd
+(NSString *)stringFromDateFromCurrent;
//将时间转成字符串 格式yyyy-MM-dd
+(NSString *)stringFromDateFromDate:(NSDate *)date;
//获取今天之前的相应天数
+(NSString *)stringFromDateBeforeToday:(NSInteger)day;

@end
