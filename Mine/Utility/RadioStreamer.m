//
//  RadioStreamer.m
//  Mine
//
//  Created by 廖毅 on 15/12/25.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioStreamer.h"
//设置锁屏封面
#import <MediaPlayer/MediaPlayer.h>
#import "RadioDetailModel.h"

@interface RadioStreamer ()
@property(nonatomic,retain)AVPlayer *audioPlayer;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,assign) CGFloat duration;

//设置锁屏封面
//电台数组
@property(nonatomic,strong) NSMutableArray *rsRadioArray;
//当前播放的下标
@property(nonatomic,assign) NSInteger rsCurrentIndex;
@property(nonatomic,strong) RadioDetailModel *rsModel;

@end

@implementation RadioStreamer

//单例
+(instancetype)shareManager
{
    static RadioStreamer *streamer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        streamer = [[RadioStreamer alloc] init];
        
    });
    return streamer;
}
//添加播放完成的通知为单例(重写streamer的初始化方法 写到里面去)
-(id)init
{
    if (self = [super init]) {
        //添加播放完成的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishNotificationAction) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
-(void)finishNotificationAction
{
    NSLog(@"%@",self.radioDelegate);
    //先判断代理 是否存在 可用
    if (self.radioDelegate && [self.radioDelegate respondsToSelector:@selector(audioStreamerDidFinishPlaying)]) {
        [self.radioDelegate audioStreamerDidFinishPlaying];
    }
    NSLog(@"播放完了OK");
}
//懒加载
-(AVPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        self.audioPlayer = [[AVPlayer alloc]init];
    }
    return _audioPlayer;
}
-(void)pause
{
    [self.audioPlayer pause];
    self.isPlaying = NO;
    //是为了在暂停是释放掉定时器的内存,节省内存
    [self.timer invalidate];
    self.timer = nil;
    
    //锁屏界面的进度条暂停/播放
    [self backgroundAudio];
}
-(void)play
{
    //后台播放音频
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    UIBackgroundTaskIdentifier bgTask = 0;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        NSLog(@"后台播放");
        [self play2];
        //设置锁屏状态，显示的歌曲信息
        [self rsConfigNowPlayingInfoCenter];
        UIApplication *app = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
        if (bgTask != UIBackgroundTaskInvalid) {
            [app endBackgroundTask:bgTask];
        }
        bgTask = newTask;
    }else{
        NSLog(@"前台播放");
        [self play2];
    }
    
    //锁屏界面的进度条暂停/播放
    [self backgroundAudio];
}
-(void)play2
{
    [self.audioPlayer play];
    self.isPlaying = YES;
    //判断是否存在定时器,如果没有就创建
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleTimerAction) userInfo:nil repeats:YES];
    }
    //获取总时间
    self.duration = CMTimeGetSeconds(self.audioPlayer.currentItem.duration);
}
//锁屏界面的进度条暂停/播放
-(void)backgroundAudio
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    [dict setObject:[NSNumber numberWithDouble:[self.audioPlayer currentTime].value/[self.audioPlayer currentTime].timescale] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

-(void)handleTimerAction
{
    //判断代理是否为空,代理能否响应其对应的方法
    if (self.radioDelegate && [self.radioDelegate respondsToSelector:@selector(audioStreamerPlayingWithPregress:)]) {
        //把当前播放的时间转化为对应的秒 CMTime. value/timescale = seconds
        [self.radioDelegate audioStreamerPlayingWithPregress:[self.audioPlayer currentTime].value/[self.audioPlayer currentTime].timescale];
    }
}
//设置音频的url
-(void)setAudioMusicWithUrl:(NSString *)urlString
{
    if (self.audioPlayer.currentItem) {
        [self.audioPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    }
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:urlString]];
    [self.audioPlayer replaceCurrentItemWithPlayerItem:item];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
//总时间
-(CGFloat)time
{
    return self.duration;
}
//当前播放时间
-(CGFloat)currentTime
{
    return [self.audioPlayer currentTime].value/[self.audioPlayer currentTime].timescale;//单位为秒
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    switch ([change[@"new"] integerValue]) {
        case AVPlayerItemStatusFailed:
            NSLog(@"播放失败");
            break;
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"可以播放了");
            
            [self play];
            //先判断代理 是否存在 可用 开始播放时调用的方法 设置播放按钮状态图片为播放
            if (self.radioDelegate && [self.radioDelegate respondsToSelector:@selector(playNow)]) {
                [self.radioDelegate playNow];
            }
            break;
            
        case AVPlayerItemStatusUnknown:
            NSLog(@"播放出错");
            break;
        default:
            break;
    }
}
-(void)setVolume:(float)volume
{
    self.audioPlayer.volume = volume;
}
-(float)volume
{
    return self.audioPlayer.volume;
}
//判断其当前的播放的url与传递的url是否相同
-(BOOL)isPlayingCurrentAudioWithUrl:(NSString *)urlString
{
    NSString *currentStr = ((AVURLAsset *)self.audioPlayer.currentItem.asset).URL.absoluteString ;
    return [currentStr isEqualToString:urlString];
}
//跳转到指定的位置开始播放
-(void)seekToTime:(float)time
{
    //设置当前播放的时间
    [self.audioPlayer seekToTime:CMTimeMakeWithSeconds(time, [self.audioPlayer currentTime].timescale)];
}

//返回播放的状态
-(BOOL)playState
{
    return self.isPlaying;
}


//设置锁屏封面
//获得电台数组
-(void)rsConfigureWithArray:(NSMutableArray *)array
{
    self.rsRadioArray = array;
}
//获得正在播放的下标
-(void)rsConfigureWithIndex:(NSInteger)index
{
    self.rsCurrentIndex = index;
}
//设置锁屏状态，显示的歌曲信息
-(void)rsConfigNowPlayingInfoCenter{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        self.rsModel = [self.rsRadioArray objectAtIndex:self.rsCurrentIndex];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //歌曲名称
        [dict setObject:self.rsModel.titleStr forKey:MPMediaItemPropertyTitle];
        //演唱者
        [dict setObject:@"初语" forKey:MPMediaItemPropertyArtist];
        //专辑名
        [dict setObject:@"人生若只如初见" forKey:MPMediaItemPropertyAlbumTitle];
        //专辑缩略图
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.rsModel.coverimgStr]]];
        if (!image) {
            image = [UIImage imageNamed:@"holder_big.jpg"];
        }
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        //音乐总时长
        [dict setObject:[NSNumber numberWithDouble:self.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        [dict setObject:[NSNumber numberWithDouble:[self.audioPlayer currentTime].value/[self.audioPlayer currentTime].timescale] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //设置锁屏状态下屏幕显示播放音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

@end
