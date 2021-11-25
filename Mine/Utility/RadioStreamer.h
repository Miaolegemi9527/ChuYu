//
//  RadioStreamer.h
//  Mine
//
//  Created by 廖毅 on 15/12/25.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol RadioDelegate <NSObject>

//用于刷新播放条进度,当前播放时间,剩余时间,图片的偏移量(旋转图片)
-(void)audioStreamerPlayingWithPregress:(float)progressValue;
-(void)audioStreamerDidFinishPlaying;

//开始播放调用的方法 设置播放按钮图片
-(void)playNow;

@end
//音乐播放模式
typedef NS_ENUM(NSInteger, musicPlayingModel)
{
    musicPlayingModelLoop,
    musicPlayingModelRandom,
    musicPlayingModelRepeat,
    musicPlayingModelNone
};

@interface RadioStreamer : NSObject

//单例
+(instancetype)shareManager;
@property(nonatomic,assign)NSInteger musicPlayingModel;
@property(nonatomic,assign)BOOL isPlaying;
@property(nonatomic,assign)float volume;
@property(nonatomic,weak)id<RadioDelegate>radioDelegate;
-(void)pause;
-(void)play;

//设置音频的url
-(void)setAudioMusicWithUrl:(NSString *)urlString;

-(BOOL)isPlayingCurrentAudioWithUrl:(NSString *)urlString;
//总时间
-(CGFloat)time;
//当前播放时间
-(CGFloat)currentTime;

//跳转到指定的位置开始播放
-(void)seekToTime:(float)time;
//返回播放的状态
-(BOOL)playState;

-(AVPlayer *)audioPlayer;

//设置锁屏封面
//获得电台数组
-(void)rsConfigureWithArray:(NSMutableArray *)array;
//获得正在播放的下标
-(void)rsConfigureWithIndex:(NSInteger)index;


@end
