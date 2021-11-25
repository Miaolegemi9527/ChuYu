//
//  HomeCollectionViewCell.m
//  Mine
//
//  Created by lanou on 16/1/13.
//  Copyright © 2016年 9527. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()

//一、属性
//每张图背景
//@property(nonatomic,retain)UIView *backgroundView;
//日、月、年
@property(nonatomic,retain)UILabel *dayLabel;
@property(nonatomic,retain)UILabel *moothLabel;
@property(nonatomic,retain)UILabel *yearLabel;
//作者
@property(nonatomic,retain)UILabel *authorL;
//作品名
@property(nonatomic,retain)UILabel *workNameL;
//logo
@property(nonatomic,retain)UIImageView *logoImageView;
//底部文字
@property(nonatomic,retain)UILabel *homeTextLabel;

@end

@implementation HomeCollectionViewCell

//重写初始化方法

//二、重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}
//三、写布局方法
-(void)setUpView
{
    
    //背景色
    //日夜间模式
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        self.window.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.window.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    //self.backgroundColor = [UIColor whiteColor];
    //日、月、年
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake1(15, 5, WIDTH-230, 35)];
    _dayLabel.textColor = [UIColor colorWithRed:153/255.0 green:156/255.0 blue:156/255.0 alpha:1];
    _dayLabel.font = [UIFont boldSystemFontOfSize:32];
    [self addSubview:_dayLabel];
    
    self.moothLabel = [[UILabel alloc] initWithFrame:CGRectMake2(15, CGRectGetMaxY(self.dayLabel.frame), WIDTH-230, 20)];
    [self addSubview:_moothLabel];
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake2(15, CGRectGetMaxY(self.moothLabel.frame), WIDTH-230, 20)];
    _yearLabel.textColor = [UIColor colorWithRed:63/255.0 green:68/255.0 blue:71/255.0 alpha:1];
    [self addSubview:_yearLabel];
    //作者
    self.authorL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.yearLabel.frame)+10*SCALE_X, CGRectGetMaxY(self.moothLabel.frame)-15*SCALE_Y, WW-CGRectGetMaxX(self.yearLabel.frame)-15*SCALE_X, 15*SCALE_Y)];
    _authorL.textAlignment = NSTextAlignmentRight;
    _authorL.textColor = [UIColor grayColor];
    _authorL.font = [UIFont systemFontOfSize:12];
    _authorL.numberOfLines = 0;
    [self addSubview:_authorL];
    //作品名
    self.workNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.yearLabel.frame)+10*SCALE_X, CGRectGetMidY(self.authorL.frame)+11*SCALE_Y, WW-CGRectGetMaxX(self.yearLabel.frame)-15*SCALE_X, 15*SCALE_Y)];
    self.workNameL.textAlignment = NSTextAlignmentRight;
    self.workNameL.textColor = [UIColor grayColor];
    self.workNameL.font = [UIFont boldSystemFontOfSize:12];
    self.workNameL.numberOfLines = 0;
    [self addSubview:self.workNameL];
    
    //self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake2(0, CGRectGetMaxY(self.yearLabel.frame)+10, self.frame.size.width, (self.frame.size.width)*0.678*SCALE_Y)];
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake2(0, CGRectGetMaxY(self.yearLabel.frame)+10*SCALE_Y, WIDTH, WIDTH*0.618)];
    
    
    _imageV.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageV];
    //底部文字
    self.homeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*SCALE_X, CGRectGetMaxY(self.imageV.frame)+5, CGRectGetMaxX(self.imageV.frame)-10*SCALE_X, self.frame.size.height-10*SCALE_Y-(CGRectGetMaxY(self.imageV.frame)))];
    //_homeTextLabel.backgroundColor = [UIColor orangeColor];
    _homeTextLabel.textColor = [UIColor colorWithRed:90 / 255.0 green:91 / 255.0 blue:92 / 255.0 alpha:1];
    _homeTextLabel.numberOfLines = 0;
    _homeTextLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_homeTextLabel];
    
//    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake3(CGRectGetMaxX(self.imageV.frame)-30, CGRectGetMaxY(self.imageV.frame)+5, 20, 75)];
//    _logoImageView.center = CGPointMake(self.logoImageView.center.x, CGRectGetMidY(self.homeTextLabel.frame));
//    _logoImageView.image = [UIImage imageNamed:@"logo3"];
//    [self addSubview:_logoImageView];
    
}
//赋值
-(void)configureWithHome2:(HomeModel2 *)home2
{
    //日期
    NSArray *marketTimeArray = [home2.strMarketTime componentsSeparatedByString:@"-"];
    NSString *yearStr = marketTimeArray[0];
    NSString *monthStr = marketTimeArray[1];
    NSString *dayStr = marketTimeArray[2];
    
    switch ([monthStr intValue]) {
        case 1:
            monthStr = @"January";
            break;
        case 2:
            monthStr = @"February";
            break;
        case 3:
            monthStr = @"March";
            break;
        case 4:
            monthStr = @"April";
            break;
        case 5:
            monthStr = @"May";
            break;
        case 6:
            monthStr = @"June";
            break;
        case 7:
            monthStr = @"July";
            break;
        case 8:
            monthStr = @"August";
            break;
        case 9:
            monthStr = @"September";
            break;
        case 10:
            monthStr = @"October";
            break;
        case 11:
            monthStr = @"November";
            break;
        case 12:
            monthStr = @"December";
            break;
            
        default:
            break;
    }
    
    self.dayLabel.text = dayStr;
    self.moothLabel.text = monthStr;
    self.yearLabel.text = yearStr;
    //图片
//    [self.imageV sd_setImageWithURL:[NSURL URLWithString:home2.strThumbnailUrl] placeholderImage:[UIImage imageNamed:@"bg2.jpg"]];
    self.homeTextLabel.text = home2.strContent;
    //作者
    NSArray *authorArray = [home2.strAuthor componentsSeparatedByString:@"&"];
    NSString *titleStr = authorArray[0];
    NSString *authorStr = authorArray[1];
    self.workNameL.text = [NSString stringWithFormat:@"%@",titleStr];
    self.authorL.text = [NSString stringWithFormat:@"%@",authorStr];
    
    //宽窄屏切换 刷新视图
    [self reloadBigAndSmallView];
}
////宽窄屏切换 刷新视图
-(void)reloadBigAndSmallView
{
    self.authorL.frame = CGRectMake(CGRectGetMaxX(self.yearLabel.frame)+10*SCALE_X, CGRectGetMaxY(self.moothLabel.frame)-15*SCALE_Y, WW-CGRectGetMaxX(self.yearLabel.frame)-15*SCALE_X, 15*SCALE_Y);
    self.workNameL.frame = CGRectMake(CGRectGetMaxX(self.yearLabel.frame)+10*SCALE_X, CGRectGetMidY(self.authorL.frame)+11*SCALE_Y, WW-CGRectGetMaxX(self.yearLabel.frame)-15*SCALE_X, 15*SCALE_Y);
    
    self.imageV.frame = CGRectMake2(0, CGRectGetMaxY(self.yearLabel.frame)+10*SCALE_Y, WIDTH, WIDTH*0.618);
    
    self.homeTextLabel.frame = CGRectMake(10*SCALE_X, CGRectGetMaxY(self.imageV.frame)+5, CGRectGetMaxX(self.workNameL.frame)-10*SCALE_X, self.frame.size.height-10*SCALE_Y-(CGRectGetMaxY(self.imageV.frame)));
//    self.logoImageView.frame = CGRectMake3(CGRectGetMaxX(self.workNameL.frame)-30, CGRectGetMaxY(self.imageV.frame)+5, 20, 75);
//    _logoImageView.center = CGPointMake(self.logoImageView.center.x, CGRectGetMidY(self.homeTextLabel.frame));

}


@end
