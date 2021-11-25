//
//  ArticleModel.h
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject

//文章
@property(nonatomic,strong)NSString *articleString;
//日期
@property(nonatomic,retain)NSString *timeString;
//标题
@property(nonatomic,retain)NSString *titleString;
//作者
@property(nonatomic,retain)NSString *authorString;
//字数
@property(nonatomic,assign)NSInteger wordCount;
//作者简介
@property(nonatomic,strong)NSString *sAuthString;

//赋值
+(instancetype)articleModelWithDictionary:(NSDictionary *)dict;

@end
