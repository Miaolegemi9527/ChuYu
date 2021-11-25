//
//  RadioModel.h
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioModel : NSObject

//三张大图
@property(nonatomic,strong)NSString *carouselImgStr;
@property(nonatomic,strong)NSString *carouselUrlStr;
//三张小兔
@property(nonatomic,strong)NSString *hotlistCoverimgStr;
@property(nonatomic,strong)NSString *hotlistRadioidStr;
@property(nonatomic,strong)NSString *hotlistTitleStr;

//电台id
@property(nonatomic,strong)NSString *alllistRadioidStr;
//电台图
@property(nonatomic,strong)NSString *alllistCoverimgStr;
//电台名
@property(nonatomic,strong)NSString *alllistTitleStr;
//简介
@property(nonatomic,strong)NSString *alllistDescStr;
//作者
@property(nonatomic,strong)NSDictionary *alllistUserinfoDict;

//赋值
//电台
+(instancetype)radioModelAlllistWithDictionary:(NSDictionary *)Alllistdict;
//三张大图
+(instancetype)radioModelCarouselWithDictionary:(NSDictionary *)CarouselDict;
//三张小兔
+(instancetype)radioModelHotlistWithDictionary:(NSDictionary *)HotlistDict;

@end
