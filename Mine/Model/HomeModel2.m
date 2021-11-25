//
//  HomeModel2.m
//  Mine
//
//  Created by 廖毅 on 15/12/15.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "HomeModel2.h"

@implementation HomeModel2

+(instancetype)homeModel2WithDictionary:(NSDictionary *)dict
{
    HomeModel2 *home2 = [[HomeModel2 alloc] init];
    home2.strLastUpdateDate = dict[@"strLastUpdateDate"];
    home2.strThumbnailUrl = dict[@"strThumbnailUrl"];
    home2.strAuthor = dict[@"strAuthor"];
    home2.strContent = dict[@"strContent"];
    home2.strMarketTime = dict[@"strMarketTime"];
    return home2;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
