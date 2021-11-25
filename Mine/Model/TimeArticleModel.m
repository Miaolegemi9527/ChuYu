//
//  TimeArticleModel.m
//  Mine
//
//  Created by 廖毅 on 15/12/22.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "TimeArticleModel.h"

@implementation TimeArticleModel

+(instancetype)timeArticleWithDictionary:(NSDictionary *)dict
{
    TimeArticleModel *timeArticle = [[TimeArticleModel alloc] init];
    timeArticle.titleStr = dict[@"title"];
    timeArticle.textStr = dict[@"text"];
    timeArticle.picStr = dict[@"pic"];
    timeArticle.urlStr = dict[@"url"];
    timeArticle.descStr = dict[@"desc"];
    timeArticle.unameStr = dict[@"uname"];
    timeArticle.iconStr = dict[@"icon"];
    timeArticle.articleStr = dict[@"write"];
    return timeArticle;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
