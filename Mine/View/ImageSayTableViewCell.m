//
//  ImageSayTableViewCell.m
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "ImageSayTableViewCell.h"
//加载网络图片 第三方
//#import "UIImageView+WebCache.h"

@interface ImageSayTableViewCell ()


@property(nonatomic,retain)UILabel *postTextLabel;
@property(nonatomic,retain)UILabel *tagsLabel;


@end

@implementation ImageSayTableViewCell



//用懒加载的方式初始化
//懒加载 重写每个控件的get方法 只有在用的时候会初始化 只初始化一次 不用不初始化 大大减少系统内存的占用量
-(UILabel *)tagsLabel
{
    if (!_tagsLabel) {
        self.tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake1(10, 5, WIDTH-20, 10)];
        //_tagsLabel.textAlignment = NSTextAlignmentRight;
        _tagsLabel.numberOfLines = 0;
        _tagsLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_tagsLabel];
    }
    return _tagsLabel;
}
-(UIImageView *)imageV
{
    if (!_imageV) {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake2(10, CGRectGetMaxY(self.tagsLabel.frame)+10, WIDTH-20, 180)];
        //_imageV.layer.borderColor = [UIColor grayColor].CGColor;
        //_imageV.layer.borderWidth = 1;
        _imageV.layer.cornerRadius = 5;
        _imageV.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageV];
    }
    return _imageV;
}
-(UILabel *)postTextLabel
{
    if (!_postTextLabel) {
        self.postTextLabel = [[UILabel alloc] initWithFrame:CGRectMake2(10, CGRectGetMaxY(self.imageV.frame)+10, WIDTH-20, 10)];
        _postTextLabel.font = [UIFont systemFontOfSize:12];
        _postTextLabel.numberOfLines = 0;
        _postTextLabel.textColor = [UIColor grayColor];
        [_postTextLabel sizeToFit];
        [self.contentView addSubview:_postTextLabel];
    }
    return _postTextLabel;
}
//赋值
-(void)configureImageSayCellWithImageSayModel:(ImageSayModel2 *)imageSay
{
    //保存照片的数组初始化
    //self.mImageArray = [NSMutableArray array];
    self.tagsLabel.text = imageSay.tagsString;
    _tagsLabel.frame = CGRectMake1(10, 5, WIDTH-20, 5);
    [_tagsLabel sizeToFit];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageSay.bigUrlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self compressImage:(WIDTH-20)*SCALE_X image:image];
        _postTextLabel.frame = CGRectMake2(10, CGRectGetMaxY(self.imageV.frame)+10, WIDTH-20, 10);
        }];
    self.postTextLabel.text = imageSay.postTextString;
    [_postTextLabel sizeToFit];
}
//等比缩放
-(void)compressImage:(CGFloat)wi image:(UIImage *)image
{
    CGSize s = image.size;
    //等比缩放
    float w = wi;
    float h = (w * s.height)/s.width;
    //重置imageview的尺寸
    [_imageV setFrame:CGRectMake(10*SCALE_X, CGRectGetMaxY(self.tagsLabel.frame)+10, w, h)];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
