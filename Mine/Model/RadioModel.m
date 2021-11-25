//
//  RadioModel.m
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioModel.h"

@implementation RadioModel

//电台列表
+(instancetype)radioModelAlllistWithDictionary:(NSDictionary *)Alllistdict
{
    RadioModel *radio = [[RadioModel alloc] init];
    radio.alllistRadioidStr = Alllistdict[@"radioid"];
    radio.alllistCoverimgStr = Alllistdict[@"coverimg"];
    radio.alllistTitleStr = Alllistdict[@"title"];
    radio.alllistDescStr = Alllistdict[@"desc"];
    radio.alllistUserinfoDict = Alllistdict[@"userinfo"];
    return radio;
}
//三张大图
+(instancetype)radioModelCarouselWithDictionary:(NSDictionary *)CarouselDict
{
    RadioModel *radio = [[RadioModel alloc] init];
    radio.carouselImgStr = CarouselDict[@"img"];
    radio.carouselUrlStr = CarouselDict[@"url"];
    return radio;
}
//三张小兔
+(instancetype)radioModelHotlistWithDictionary:(NSDictionary *)HotlistDict
{
    RadioModel *radio = [[RadioModel alloc] init];
    radio.hotlistCoverimgStr = HotlistDict[@"coverimg"];
    radio.hotlistRadioidStr = HotlistDict[@"radioid"];
    radio.hotlistTitleStr = HotlistDict[@"title"];
    return radio;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
