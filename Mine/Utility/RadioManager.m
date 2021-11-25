//
//  RadioManager.m
//  Mine
//
//  Created by 廖毅 on 15/12/26.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioManager.h"
#import <AVFoundation/AVFoundation.h>
#import "RadioStreamer.h"
//设置锁屏状态，显示的歌曲信息
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "RadioDetailModel.h"


@interface RadioManager ()
//电台数组
@property(nonatomic,strong) NSMutableArray *array;
//当前播放的下标
@property(nonatomic,assign) NSInteger currentIndex;
//设置锁屏状态，显示的歌曲信息
@property(nonatomic,strong) RadioDetailModel *model;

@end

@implementation RadioManager

//单例
+(instancetype)shareManager
{
    static RadioManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RadioManager alloc] init];
    });
    return manager;
}

//初始化方法
-(id)init
{
    if (self = [super init]) {
        //加个观察者,接收是否播放结束
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishNotificationAction) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
//播放完了 通知方法 下一曲
-(void)finishNotificationAction
{
    NSLog(@"播放完了2 进入下一曲...");
    NSInteger temp = [self currentIndex]+1;
    if (temp > [self countOfModels]-1) {
        temp = 0;
    }
    self.model = [self modelAtIndex:temp];
    [[RadioStreamer shareManager] setAudioMusicWithUrl:self.model.musicUrlStr];
    
    //在非播放页面缓冲完播放后锁屏封面信息切换
    [[RadioStreamer shareManager] rsConfigureWithArray:self.array];
    [[RadioStreamer shareManager] rsConfigureWithIndex:temp];
    
    //设置锁屏状态，显示的歌曲信息
    [self configNowPlayingInfoCenter];
    
}
//上一曲
-(void)playPreviousTrack
{
    NSLog(@"...上一曲");
    NSInteger temp = [self currentIndex];
    if (temp > 0) {
        temp--;
    }
    self.model = [self modelAtIndex:temp];
    [[RadioStreamer shareManager] setAudioMusicWithUrl:self.model.musicUrlStr];
    
    //在非播放页面缓冲完播放后锁屏封面信息切换
    [[RadioStreamer shareManager] rsConfigureWithArray:self.array];
    [[RadioStreamer shareManager] rsConfigureWithIndex:temp];

    //设置锁屏状态，显示的歌曲信息
    [self configNowPlayingInfoCenter];
}
//设置锁屏状态，显示的歌曲信息
-(void)configNowPlayingInfoCenter{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        //NSDictionary *info = [self.radioArray objectAtIndex:self.currentIndex];

        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //歌曲名称
        [dict setObject:self.model.titleStr forKey:MPMediaItemPropertyTitle];
        //演唱者
        [dict setObject:@"初语" forKey:MPMediaItemPropertyArtist];
        //专辑名
        [dict setObject:@"人生若只如初见" forKey:MPMediaItemPropertyAlbumTitle];
        //专辑缩略图
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.coverimgStr]]];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        //音乐总时长
        [dict setObject:[NSNumber numberWithDouble:[RadioStreamer shareManager].time] forKey:MPMediaItemPropertyPlaybackDuration];
        [dict setObject:[NSNumber numberWithDouble:[RadioStreamer shareManager].currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //设置锁屏状态下屏幕显示播放音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}


//获得正在播放的数组
-(void)configureWithArray:(NSMutableArray *)array
{
    self.array = array;
}
//付出正在播放的数组
-(NSMutableArray *)showArray
{
    return self.array;
}

//获得当前播放的下标
-(void)configureWithIndex:(NSInteger)index
{
    self.currentIndex = index;
}
//返回下标
-(NSInteger)showIndex
{
    return self.currentIndex;
}

//根据指定的下标返回对应的model
-(RadioDetailModel *)modelAtIndex:(NSInteger)index
{
    self.currentIndex = index;
    return self.array[index];
}
//返回数据的总个数
-(NSInteger)countOfModels
{
    return self.array.count;
}


@end
