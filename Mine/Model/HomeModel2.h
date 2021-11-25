//
//  HomeModel2.h
//  Mine
//
//  Created by 廖毅 on 15/12/15.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel2 : NSObject

@property(nonatomic,retain)NSString *strLastUpdateDate;
@property(nonatomic,retain)NSString *strThumbnailUrl;
@property(nonatomic,retain)NSString *strAuthor;
@property(nonatomic,retain)NSString *strContent;
@property(nonatomic,retain)NSString *strMarketTime;

@property(nonatomic,strong)NSString *year;
@property(nonatomic,strong)NSString *month;
@property(nonatomic,strong)NSString *day;

+(instancetype)homeModel2WithDictionary:(NSDictionary *)dict;

@end
