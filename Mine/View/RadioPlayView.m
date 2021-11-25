//
//  RadioPlayView.m
//  Mine
//
//  Created by 廖毅 on 15/12/25.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioPlayView.h"

@implementation RadioPlayView

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatPage];
    }
    return self;
}

//布局方法
-(void)creatPage
{
#pragma mark 旋转图片
    [self reloadCoverImage];
    
#pragma mark 歌曲名字和歌手
    [self reloadMusicNameAndSinger];
    
}
//歌曲信息赋值
-(void)configureRadio:(RadioDetailModel *)radio
{
    [self.coverimgView sd_setImageWithURL:[NSURL URLWithString:radio.coverimgStr] placeholderImage:[UIImage imageNamed:@"holder_big.jpg"]];
    self.nameLabel.text = radio.titleStr;
}

-(void)reloadCoverImage
{
#pragma mark --旋转图片
    self.coverimgView = [[UIImageView alloc]initWithFrame:CGRectMake4((WIDTH-(WIDTH-120))/2, 15, WIDTH-120, WIDTH-120)];
    [self addSubview:self.coverimgView];
    self.coverimgView.layer.cornerRadius = (WIDTH-120)/2*SCALE_Y;
    self.coverimgView.layer.masksToBounds = YES;
    self.coverimgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.coverimgView.layer.borderWidth = 2;
   
}
-(void)reloadMusicNameAndSinger
{
#pragma mark --音乐名字
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake2(0, CGRectGetMaxY(self.coverimgView.frame)+100, WIDTH, 30)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLabel.numberOfLines = 0;
    [self addSubview:self.nameLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
