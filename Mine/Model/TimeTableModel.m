//
//  TimeTableModel.m
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "TimeTableModel.h"

@implementation TimeTableModel

+(instancetype)timeTableWithDictionary:(NSDictionary *)dict
{
    TimeTableModel *time = [[TimeTableModel alloc] init];
    time.typeId = [dict[@"typeid"] integerValue];
    time.typenameStr = dict[@"typename"];
    time.contentStr = dict[@"content"];
    time.coverimgStr = dict[@"coverimg"];
    time.idStr = dict[@"id"];
    time.nameStr = dict[@"name"];
    time.titleStr = dict[@"title"];
    return time;
}

@end
