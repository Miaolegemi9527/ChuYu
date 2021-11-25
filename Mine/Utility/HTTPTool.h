//
//  HTTPTool.h
//  Mine
//
//  Created by 廖毅 on 15/12/14.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+HUD.h"

//block传值1
//定义一个block 异步请求一般用NSData block作为参数 block等号前面在这写
//typedef 专门声明一个类型
typedef void(^block) (NSData *);

@interface HTTPTool : NSObject

//网络判断
-(BOOL)isNetWork;

//首页 根据传入的时间获取数据
-(void)requestDataByTime:(NSString *)dateStr;
//Image详情 根据传入的ID获取相应的数据
-(void)requestDataByalbumId:(NSInteger)albumId;
//Iamge上下拉刷新 根据传入的ID和偏移量获取相应的数据
-(void)requestDataByalbumIdOffset:(NSInteger)albumIdOffset;


//block传值2
//获取首页 日期 图片+文字
-(void)requestHomeContentByDateController:(UIViewController *)controller InfoBlock:(block)HomeContentBlock;
//文章
-(void)requestArticleByDateController:(UIViewController *)controller InfoBlock:(block)ArticleBlock;
//Image
-(void)requestImageSayByDateController:(UIViewController *)controller InfoBlock:(block)imageSayBlock;
//Image详情
-(void)requestImageSay2ByDateController:(UIViewController *)controller InfoBlock:(block)imageSay2Block;

//Time
-(void)requestTimeByDateController:(UIViewController *)controller InfoBlock:(block)TimeBlock;
//Time详情

//TimeTabel
-(void)requestTimeTabelDataByType:(NSInteger)type;//根据传入的类型请求数据
-(void)requestTimeTabelDataByStart:(NSInteger)start;//根据开始位置（个数）刷新
-(void)requestTimeTabelByDateController:(UIViewController *)controller InfoBlock:(block)TimeTableBlock;
//TimeArticle
-(void)requestTimeArticleDataByContentid:(NSString *)ContentidStr;
-(void)requestTimeArticleByDateController:(UIViewController *)controller InfoBlock:(block)TimeArticleBlock;


//电台Radio
//电台列表下拉刷新
-(void)requestDataByLimitAndStart:(NSInteger)LimitAndStart;
//默认及下拉刷新 上拉刷新 根据传入start获取相应的数据
-(void)requestRadioListViewByDateController:(UIViewController *)controller RadioListBlock:(block)RadioListBlock;
//电台详情
-(void)requestDataByRadioDetailStart:(NSInteger)Start;
//默认及下拉刷新 上拉刷新 根据传入的start获取相应的数据
-(void)requestRadioDetailViewByDateController:(UIViewController *)controller RadioDetailBlock:(block)RadioListBlock;
//根据电台id获取歌单
-(void)requestDataByRadioid:(NSString *)Radioid;


@end
