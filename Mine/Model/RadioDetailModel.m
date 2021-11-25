//
//  RadioDetailModel.m
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioDetailModel.h"

@implementation RadioDetailModel

+(instancetype)radioDetailModelWithDictionary:(NSDictionary *)Dict
{
    RadioDetailModel *radioDetail = [[RadioDetailModel alloc] init];
    radioDetail.coverimgStr = Dict[@"coverimg"];
    radioDetail.musicUrlStr = Dict[@"musicUrl"];
    radioDetail.tingidStr = Dict[@"tingid"];
    radioDetail.titleStr = Dict[@"title"];
    return radioDetail;
}

@end
