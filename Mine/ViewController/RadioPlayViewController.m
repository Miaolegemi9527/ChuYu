//
//  RadioPlayViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/25.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RadioPlayView.h"
#import "RadioStreamer.h"
#import "RadioDetailModel.h"
#import "RadioManager.h"
//设置锁屏封面
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

@interface RadioPlayViewController ()<RadioDelegate>

@property(nonatomic,strong) RadioDetailModel *radio;
@property(nonatomic,strong) RadioPlayView *radioPV;
//
@property(nonatomic,strong) UIButton *forwardButton;
@property(nonatomic,strong) UIButton *rewindButton;
@property(nonatomic,strong) UIButton *playPauseButton;
@property(nonatomic,strong) UISlider *volumeSlider;
@property(nonatomic,strong) UISlider *musicSlider;
@property(nonatomic,strong) UILabel *currentTimeLabel;
@property(nonatomic,strong) UILabel *remainTimeLabel;
//背景毛玻璃
@property(nonatomic,retain)UIVisualEffectView *effectView;
//背景
@property(nonatomic,retain)UIImageView *bgView;
//锁屏封面
@property(nonatomic,retain)UIImage *coverImage;
//缓冲完开始播放按播放暂停按钮才有效
@property(nonatomic,assign)BOOL okToPlay;

@end

@implementation RadioPlayViewController

-(void)viewWillAppear:(BOOL)animated
{
    //日夜模式切换
    [self dayOrNight];
}

-(void)loadView
{
    //初始化self.view
    self.view = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //交互打开
    self.view.userInteractionEnabled = YES;
    
    //背景
    self.bgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_bgView];
    //设置毛玻璃效果
    self.effectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _effectView.frame = CGRectMake1(0, 0, WIDTH, HEIGHT);
    [self.bgView addSubview:_effectView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    musicButton.frame = CGRectMake4(0, 0, 32, 32);
    musicButton.layer.cornerRadius = 16;
    musicButton.layer.masksToBounds = YES;
    [musicButton setImage:[UIImage imageNamed:@"holder"] forState:UIControlStateNormal];
    [musicButton addTarget:self action:@selector(backToDetail) forControlEvents:UIControlEventTouchUpInside];
    // button 加在view上防止变形
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [leftView addSubview:musicButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = item;
    
    [RadioStreamer shareManager].radioDelegate = self;
    
    self.radioPV = [[RadioPlayView alloc] initWithFrame:CGRectMake1(0, 64, WIDTH, WIDTH-90)];
    self.radioPV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_radioPV];
    [self reloadChangeMusicPlayStatusButton];
    
    [self reloadView];

}
-(void)reloadChangeMusicPlayStatusButton
{
#pragma mark --音乐进度滑块
        self.musicSlider = [[UISlider alloc]initWithFrame:CGRectMake2(0, CGRectGetMaxY(_radioPV.frame)+15, WIDTH, 30)];
        [self.musicSlider setThumbImage:[UIImage imageNamed:@"thumb@2x"] forState:UIControlStateNormal];
        self.musicSlider.minimumTrackTintColor = [UIColor colorWithRed:244/255.0 green:0/255.0 blue:89/255.0 alpha:1];
        self.musicSlider.maximumTrackTintColor = [UIColor grayColor];
        [self.view addSubview:self.musicSlider];
        
#pragma mark --当前播放时间
        self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake2(10, CGRectGetMaxY(self.musicSlider.frame)+10, 90, 20)];
        self.currentTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.currentTimeLabel.font = [UIFont systemFontOfSize:14];
        _currentTimeLabel.textColor = [UIColor colorWithRed:244/225.0 green:0 blue:89/255.0 alpha:1.0];
        [self.view addSubview:self.currentTimeLabel];
        
#pragma mark --剩余播放时间
        self.remainTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake2(WIDTH-100, CGRectGetMinY(self.currentTimeLabel.frame), 90, 20)];
        self.remainTimeLabel.textAlignment = NSTextAlignmentRight;
        self.remainTimeLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:self.remainTimeLabel];
    
#pragma mark --上一首
    self.rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rewindButton.frame = CGRectMake2((WIDTH-20*3)/4, CGRectGetMaxY(_remainTimeLabel.frame)+80, 20, 20);
    [self.rewindButton setImage:[UIImage imageNamed:@"rewind"] forState:UIControlStateNormal];
    [self.rewindButton setImage:[UIImage imageNamed:@"rewind_h"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:self.rewindButton];
    
#pragma mark --播放或暂停
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playPauseButton.frame = CGRectMake2((WIDTH-20*3)/4*2+20, CGRectGetMinY(self.rewindButton.frame), 20, 20);
    [self.view addSubview:self.playPauseButton];
    
#pragma mark --下一首
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forwardButton.frame = CGRectMake2((WIDTH-20*3)/4*3+20*2, CGRectGetMinY(self.rewindButton.frame), 20, 20);
    [self.forwardButton setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    [self.forwardButton setImage:[UIImage imageNamed:@"forward_h"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:self.forwardButton];
    
#pragma mark --音量
    self.volumeSlider = [[UISlider alloc]initWithFrame:CGRectMake2(50, CGRectGetMaxY(self.playPauseButton.frame)+40, (WIDTH-100), 15)];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"volumn_slider_thumb@2x"] forState:UIControlStateNormal];
    self.volumeSlider.maximumValue = 1;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"volume"]) {
        self.volumeSlider.value = 0.5;
    }else{
        self.volumeSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"volume"];
    }
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    self.volumeSlider.minimumTrackTintColor = [UIColor blackColor];
    self.volumeSlider.minimumValueImage = [UIImage imageNamed:@"volumelow@2x"];
    self.volumeSlider.maximumValueImage = [UIImage imageNamed:@"volumehigh@2x"];
    [self.view addSubview:self.volumeSlider];
    
    //上一首
    [self.rewindButton addTarget:self action:@selector(playRewind) forControlEvents:UIControlEventTouchUpInside];
    //下一首
    [self.forwardButton addTarget:self action:@selector(playFoward) forControlEvents:UIControlEventTouchUpInside];
    //播放暂停
    [self.playPauseButton addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    //音量大小
    [self.volumeSlider addTarget:self action:@selector(volumeAction) forControlEvents:UIControlEventValueChanged];
    //音乐进度
    [self.musicSlider addTarget:self action:@selector(musicAction) forControlEvents:UIControlEventValueChanged];

}

//返回
-(void)backToDetail
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//定时器执行的方法
-(void)audioStreamerPlayingWithPregress:(float)progressValue
{
    //当前播放时间
    self.currentTimeLabel.text = [self timeWithInterval:progressValue andSign:YES];
    //剩余播放时间
    CGFloat time = [[RadioStreamer shareManager] time];
    self.remainTimeLabel.text = [self timeWithInterval:(time - progressValue) andSign:NO];
    //旋转图片
    self.radioPV.coverimgView.transform = CGAffineTransformRotate(self.radioPV.coverimgView.transform, 0.01);
    //进度条更新
    self.musicSlider.value = progressValue;
    self.musicSlider.maximumValue = [[RadioStreamer shareManager] time];

}

//获取数据
-(void)reloadView
{
    self.radio = self.radioArray[_currentIndex];
    if ([[RadioStreamer shareManager] isPlayingCurrentAudioWithUrl:_radio.musicUrlStr] == NO) {
        [[RadioStreamer shareManager] setAudioMusicWithUrl:_radio.musicUrlStr];
    }
    [_radioPV configureRadio:self.radio];
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:_radio.coverimgStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.coverImage = image;
    }];
    
    //self.musicSlider.value = 0;
    //self.currentTimeLabel.text = @"+0:00";
    
    
    //当前播放时间
    self.currentTimeLabel.text = [self timeWithInterval:[RadioStreamer shareManager].currentTime andSign:YES];
    //进度条
    self.musicSlider.maximumValue = [[RadioStreamer shareManager] time];
    self.musicSlider.value = [RadioStreamer shareManager].currentTime;
    //剩余播放时间
    self.remainTimeLabel.text = [self timeWithInterval:([RadioStreamer shareManager].time - [RadioStreamer shareManager].currentTime) andSign:NO];
    //播放暂停
    if ([[RadioStreamer shareManager] isPlaying] == YES) {
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause_h"] forState:UIControlStateHighlighted];
    }else
    {
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playPauseButton setImage:[UIImage imageNamed:@"play_h"] forState:UIControlStateHighlighted];
    }
    
    [[RadioManager shareManager] configureWithArray:self.radioArray];
    [[RadioManager shareManager] configureWithIndex:self.currentIndex];
    //在非播放页面缓冲完播放后锁屏封面信息切换
    [[RadioStreamer shareManager] rsConfigureWithArray:self.radioArray];
    [[RadioStreamer shareManager] rsConfigureWithIndex:self.currentIndex];
    
    
}

//开始播放的代理方法 设置按钮状态
-(void)playNow
{
    //缓冲完开始播放按播放暂停按钮才有效
    self.okToPlay = YES;
    [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.playPauseButton setImage:[UIImage imageNamed:@"pause_h"] forState:UIControlStateHighlighted];
    //设置锁屏状态，显示的歌曲信息
    [self configNowPlayingInfoCenter];
}

//时间的转化
-(NSString *)timeWithInterval:(float)time andSign:(BOOL)sign
{
    //剩余时间
    int minute = time/60;
    int second = (int)time%60;
    if (!sign) {
        return [NSString stringWithFormat:@"-%d:%02d",minute,second];
    }
    return [NSString stringWithFormat:@"+%d:%02d",minute,second];
}
//上一首
-(void)playRewind
{
    //先暂停
    //[[RadioStreamer shareManager] pause];
    
    //缓冲完开始播放按播放暂停按钮才有效
    self.okToPlay = NO;
    
    if (self.currentIndex > 0) {
        self.currentIndex --;
    }
    [self reloadView];
    
}
//下一首
-(void)playFoward
{
    //先暂停
    //[[RadioStreamer shareManager] pause];
    
    //缓冲完开始播放按播放暂停按钮才有效
    self.okToPlay = NO;
    
    if (self.currentIndex < self.radioArray.count-1) {
        self.currentIndex ++;
    }
    [self reloadView];

}
//播放暂停
-(void)playOrPause
{
    if ([[RadioStreamer shareManager] isPlaying]) {
        //暂停
        [[RadioStreamer shareManager] pause];
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.playPauseButton setImage:[UIImage imageNamed:@"play_h"] forState:UIControlStateHighlighted];
    }
    else
    {
        if (self.okToPlay) {
            //播放
            [[RadioStreamer shareManager] play];
            [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            [self.playPauseButton setImage:[UIImage imageNamed:@"pause_h"] forState:UIControlStateHighlighted];
        }
    }
    //锁屏界面的进度条暂停/播放
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    [dict setObject:[NSNumber numberWithDouble:self.musicSlider.value] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}
//改音量
-(void)volumeAction
{
    [[RadioStreamer shareManager] setVolume:self.volumeSlider.value];
    //保存音量
    NSUserDefaults *volumeDe = [NSUserDefaults standardUserDefaults];
    [volumeDe setObject:[NSString stringWithFormat:@"%f",self.volumeSlider.value] forKey:@"volume"];
}
//改进度
-(void)musicAction
{
    //先暂停
    [[RadioStreamer shareManager] pause];
    [[RadioStreamer shareManager] seekToTime:self.musicSlider.value];
    //播放
    [[RadioStreamer shareManager] play];

}
//播放完成自动下一曲 播放完成的代理方法
-(void)audioStreamerDidFinishPlaying
{
    NSLog(@"播放完了");
    [self playFoward];
}

//日夜模式切换
-(void)dayOrNight
{
    //日夜间模式
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _effectView.frame = CGRectMake1(0, 0, WIDTH, HEIGHT);
        [self.bgView addSubview:_effectView];
        self.navigationController.navigationBar.translucent = YES;
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _effectView.frame = CGRectMake1(0, 0, WIDTH, HEIGHT);
        [self.bgView addSubview:_effectView];
        self.navigationController.navigationBar.translucent = YES;
    }
}

//后台播放 Remote控制 在播放视图的ViewController里加上这两个函数:
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        
        if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
        }
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack){
            [self playFoward];
        }else if (event.subtype == UIEventSubtypeRemoteControlPause){
            [self playOrPause];
        }else if (event.subtype == UIEventSubtypeRemoteControlPlay){
            [self playOrPause];
        }else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack){
            [self playRewind];
        }
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
//锁屏封面 一般在每次切换歌曲或者更新信息的时候要调用这个方法


//设置锁屏状态，显示的歌曲信息
-(void)configNowPlayingInfoCenter{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //歌曲名称
        [dict setObject:self.radio.titleStr forKey:MPMediaItemPropertyTitle];
        //演唱者
        [dict setObject:@"好奈不见" forKey:MPMediaItemPropertyArtist];
        //专辑名
        [dict setObject:@"甚是想念" forKey:MPMediaItemPropertyAlbumTitle];
        //专辑缩略图
        if (!self.coverImage) {
            self.coverImage = [UIImage imageNamed:@"holder_big.jpg"];
        }
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:self.coverImage];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        //音乐总时长
        [dict setObject:[NSNumber numberWithDouble:[RadioStreamer shareManager].time] forKey:MPMediaItemPropertyPlaybackDuration];
        [dict setObject:[NSNumber numberWithDouble:self.musicSlider.value] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经播放时间
        //设置锁屏状态下屏幕显示播放音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
