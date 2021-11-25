//
//  ImageSayCollectionViewCell.m
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "ImageSayCollectionViewCell.h"

@interface ImageSayCollectionViewCell ()<SDWebImageManagerDelegate>

@property(nonatomic,retain)UILabel *titleL;
//@property(nonatomic,retain)UILabel *createTimeLabel;
@property(nonatomic,retain)UILabel *introLabel;
//右边的imagev
@property(nonatomic,strong) UIImageView *rightImageV;

@end

@implementation ImageSayCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createThisPageUI];
    }
    return self;
}
-(void)createThisPageUI
{
    self.titleL = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleL];
    
//    self.createTimeLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:_createTimeLabel];
    
    self.imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageV];
    
    self.introLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.introLabel];
    
    self.rightImageV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.rightImageV];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleL.frame = CGRectMake1(0, 5, WIDTH-60, 20);
    _titleL.font = [UIFont boldSystemFontOfSize:14];
    _titleL.numberOfLines = 0;
    _titleL.textColor = [UIColor grayColor];
    [_titleL sizeToFit];
//    self.createTimeLabel.frame = CGRectMake2(0, CGRectGetMaxY(self.titleL.frame)+5, WIDTH-60, 15);
//    _createTimeLabel.font = [UIFont systemFontOfSize:12];
//    _createTimeLabel.textColor = [UIColor grayColor];
    [self.imageV setFrame:CGRectMake2(0, CGRectGetMaxY(self.titleL.frame)+10, WIDTH-60, 175)];
    _imageV.layer.cornerRadius = 5;
    _imageV.layer.masksToBounds = YES;
    
    self.introLabel.frame = CGRectMake2(0, CGRectGetMaxY(self.imageV.frame)+10, WIDTH-60, 10);
    _introLabel.textColor = [UIColor grayColor];
    _introLabel.font = [UIFont systemFontOfSize:12];
    _introLabel.numberOfLines = 0;
    [_introLabel sizeToFit];
    
}

//等比缩放
-(void)compressImage:(CGFloat)wi image:(UIImage *)image
{
    if (image) {
        CGSize s = image.size;
        //等比缩放
        float w = wi;
        float h = (w * s.height)/s.width;
        //重置imageview的尺寸
        _imageV.frame = CGRectMake(0, CGRectGetMaxY(self.titleL.frame)+10, w, h);
    }
}

-(void)configureImageSayCollectionCellWithImageSayModel:(ImageSayModel *)imageSay
{
    self.titleL.text = imageSay.titleString;
    self.titleL.frame = CGRectMake1(0, 5, WIDTH-60, 20);
    //[_titleL sizeToFit];
    
    //时间戳转时间
    //转换格式 创建格式化类对象
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//    NSString *timeString = imageSay.createTime;
//    NSString *timeStr = [timeString substringToIndex:10];//时间戳一般为10位
//    NSTimeInterval time = [timeStr doubleValue];
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
//    NSString *confromTimeString = [formatter stringFromDate:confromTimesp];
//    self.createTimeLabel.text = confromTimeString;
    
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageSay.imgString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self compressImage:(WIDTH-60)*SCALE_X image:image];
    }];
    self.introLabel.text = imageSay.introString;
    _introLabel.frame = CGRectMake2(0, CGRectGetMaxY(self.imageV.frame)+10, WIDTH-60, 10);


    
}

@end
