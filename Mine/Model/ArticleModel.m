//
//  ArticleModel.m
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "ArticleModel.h"


@implementation ArticleModel

+(instancetype)articleModelWithDictionary:(NSDictionary *)dict
{
    NSString *articleStr = dict[@"strContent"];
    NSRange range1 = [articleStr rangeOfString:@"<br><br>"];
    NSRange range2 = [articleStr rangeOfString:@"<br>"];
    NSRange range3 = [articleStr rangeOfString:@"<i>"];
    NSRange range4 = [articleStr rangeOfString:@"</i>"];
    if (range1.length > 0) {
        articleStr = [articleStr stringByReplacingOccurrencesOfString:@"<br><br>" withString:@"\n\n"];
    }
    if (range2.length > 0)
    {
        articleStr = [articleStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    }
    if (range3.length > 0) {
        articleStr = [articleStr stringByReplacingOccurrencesOfString:@"<i>" withString:@"《"];
    }
    if (range4.length > 0) {
        articleStr = [articleStr stringByReplacingOccurrencesOfString:@"</i>" withString:@"》"];
    }
    NSInteger wordC = articleStr.length;
    ArticleModel *article = [[ArticleModel alloc] init];
    if (articleStr.length == 0) {
        article.articleString = dict[@"content"];
        article.wordCount = article.articleString.length;
    }else
    {
        article.articleString = articleStr;
        article.wordCount = wordC;
    }
    article.titleString = dict[@"strContTitle"];
    article.authorString = dict[@"strContAuthor"];
    article.timeString = dict[@"strContMarketTime"];
    article.sAuthString = dict[@"sAuth"];
    
    return article;
}


//处理赋不到的值 不然会崩
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
