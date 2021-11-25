//
//  RadioPlayView.h
//  Mine
//
//  Created by 廖毅 on 15/12/25.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioDetailModel.h"

@interface RadioPlayView : UIView

//旋转图片
@property(nonatomic,retain)UIImageView *coverimgView;
//播放进度条
@property(nonatomic,retain)UISlider *musicSlider;
//播放的当前时间
@property(nonatomic,retain)UILabel *currentTimeLabel;
//剩余时间
@property(nonatomic,retain)UILabel *remainTimeLabel;
//音量 滑动
@property(nonatomic,retain)UISlider *volumeSlider;
//歌曲的名字
@property(nonatomic,retain)UILabel *nameLabel;
//歌手的名字
@property(nonatomic,retain)UILabel *singerLabel;
//播放 暂停
@property(nonatomic,retain)UIButton *playPauseButton;
//上一曲
@property(nonatomic,retain)UIButton *rewindButton;
//下一曲
@property(nonatomic,retain)UIButton *forwardButton;
//当前播放歌曲的下标
@property(nonatomic,assign)NSInteger currentIndex;

//歌曲信息赋值
-(void)configureRadio:(RadioDetailModel *)radio;

@end
