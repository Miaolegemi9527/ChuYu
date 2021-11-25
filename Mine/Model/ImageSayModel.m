//
//  ImageSayModel.m
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "ImageSayModel.h"

@implementation ImageSayModel

+(instancetype)imageSayWithDictionary:(NSDictionary *)dict
{
    ImageSayModel *imageSay = [[ImageSayModel alloc] init];
    imageSay.albumId = [dict[@"albumId"] integerValue];
    imageSay.count = [dict[@"count"] integerValue];
    imageSay.createTime = dict[@"update_at"];
    imageSay.introString = dict[@"description"];
    imageSay.imgString = dict[@"img"];
    imageSay.titleString = dict[@"title"];
    return imageSay;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
