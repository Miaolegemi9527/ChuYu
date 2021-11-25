//
//  RadioManager.h
//  Mine
//
//  Created by 廖毅 on 15/12/26.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RadioDetailModel.h"

@interface RadioManager : NSObject
//单例
+(instancetype)shareManager;
//获得电台数组
-(void)configureWithArray:(NSMutableArray *)array;
//返回电台数组
-(NSMutableArray *)showArray;

//获得正在播放的下标
-(void)configureWithIndex:(NSInteger)index;
//返回正在播放的下标
-(NSInteger)showIndex;

//根据指定的下标返回对应的model
-(RadioDetailModel *)modelAtIndex:(NSInteger)index;
//返回数据的总个数
-(NSInteger)countOfModels;

//播放完了 通知方法 下一曲
-(void)finishNotificationAction;
//上一曲
-(void)playPreviousTrack;

@end
