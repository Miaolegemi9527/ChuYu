//
//  TimeModel.m
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "TimeModel.h"


@implementation TimeModel

+(instancetype)timeModelWithDictionary:(NSDictionary *)dict
{
    TimeModel *time = [[TimeModel alloc] init];
    time.coveringStr = dict[@"coverimg"];
    time.ennameStr = dict[@"enname"];
    time.nameStr = dict[@"name"];
    time.type = [dict[@"type"] integerValue];
    return time;
}

@end
