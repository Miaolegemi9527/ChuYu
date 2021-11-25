//
//  TimeArticleModel.h
//  Mine
//
//  Created by 廖毅 on 15/12/22.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeArticleModel : NSObject

@property(nonatomic,retain)NSString *titleStr;
@property(nonatomic,retain)NSString *textStr;
@property(nonatomic,retain)NSString *picStr;
@property(nonatomic,retain)NSString *urlStr;

@property(nonatomic,retain)NSString *descStr;
@property(nonatomic,retain)NSString *unameStr;
@property(nonatomic,retain)NSString *iconStr;

@property(nonatomic,retain)NSString *articleStr;

//赋值
+(instancetype)timeArticleWithDictionary:(NSDictionary *)dict;

@end
