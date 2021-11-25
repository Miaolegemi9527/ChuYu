//
//  TimeArticleView.m
//  Mine
//
//  Created by 廖毅 on 15/12/22.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "TimeArticleView.h"

@interface TimeArticleView ()

@property(nonatomic,retain)UIScrollView *timeArticleScrollView;

@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *authorLabel;
@property(nonatomic,retain)UILabel *articleInfoLabel;
@property(nonatomic,retain)UIImageView *imageV;
@property(nonatomic,retain)UILabel *timeArticleLabel;
//@property(nonatomic,retain)UILabel *aboutTheAuthorLabel;

@end

@implementation TimeArticleView

//二、重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpTimeArticleView];
    }
    return self;
}
//三、写布局方法
-(void)setUpTimeArticleView
{
    self.timeArticleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake1(0, 0, WIDTH, HEIGHT)];
    _timeArticleScrollView.backgroundColor = [UIColor whiteColor];
    _timeArticleScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.timeArticleScrollView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(10, 10, WIDTH-20, 20)];
    //_titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.numberOfLines = 0;
    [self.titleLabel sizeToFit];
    //_titleLabel.backgroundColor = [UIColor orangeColor];
    [self.timeArticleScrollView addSubview:self.titleLabel];
    
    self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake2(10, CGRectGetMaxY(self.titleLabel.frame)+10, WIDTH-20, 20)];
    _authorLabel.backgroundColor = [UIColor purpleColor];
    _authorLabel.font = [UIFont systemFontOfSize:12];
    _authorLabel.numberOfLines = 0;
    [self.authorLabel sizeToFit];
    [self.timeArticleScrollView addSubview:self.authorLabel];
    
    self.articleInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake2(10, CGRectGetMaxY(self.authorLabel.frame)+10, WIDTH-20, 20)];
    //_articleInfoLabel.backgroundColor = [UIColor brownColor];
    _articleInfoLabel.textColor = [UIColor grayColor];
    _articleInfoLabel.font = [UIFont systemFontOfSize:12];
    _articleInfoLabel.numberOfLines = 0;
    [self.articleInfoLabel sizeToFit];
    [self.timeArticleScrollView addSubview:self.articleInfoLabel];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake2(10, CGRectGetMaxY(self.articleInfoLabel.frame)+10, WIDTH-20, (WIDTH-20)*0.777)];
    //_imageV.backgroundColor = [UIColor redColor];
    [self.timeArticleScrollView addSubview:self.imageV];
    
    self.timeArticleLabel = [[UILabel alloc] initWithFrame:CGRectMake2(10, CGRectGetMaxY(self.imageV.frame), WIDTH-20, 300)];
    //_timeArticleLabel.backgroundColor = [UIColor greenColor];
    _timeArticleLabel.font = [UIFont systemFontOfSize:14];
    _timeArticleLabel.numberOfLines = 0;
    [self.timeArticleLabel sizeToFit];
    [self.timeArticleScrollView addSubview:self.timeArticleLabel];
    
}

//赋值
-(void)configureWithTimeArticle:(TimeArticleModel *)timeArticle
{
    self.titleLabel.text = timeArticle.titleStr;
    self.titleLabel.frame = CGRectMake1(10, 10, WIDTH-20, 20);
    [self.titleLabel sizeToFit];
    self.articleInfoLabel.text = timeArticle.textStr;
    self.articleInfoLabel.frame = CGRectMake2(10, CGRectGetMaxY(self.authorLabel.frame)+10, WIDTH-20, 20);
    [self.articleInfoLabel sizeToFit];
    if (timeArticle.picStr.length > 0) {
        //[self.imageV sd_setImageWithURL:[NSURL URLWithString:timeArticle.picStr]];
         //self.imageV.frame = CGRectMake(10, CGRectGetMaxY(self.articleInfoLabel.frame)+10, WIDTH-20, (WIDTH-20)*0.777);
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:timeArticle.picStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self compressImage:(WIDTH-20)*SCALE_X image:image];
            self.timeArticleLabel.text = timeArticle.articleStr;
            self.timeArticleLabel.frame = CGRectMake2(10, CGRectGetMaxY(self.imageV.frame)+10, WIDTH-20, 300);
            _timeArticleLabel.numberOfLines = 0;
            [self.timeArticleLabel sizeToFit];
            self.timeArticleScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.timeArticleLabel.frame));
        }];
    }
    else
    {
        self.imageV.frame = CGRectMake2(10, CGRectGetMaxY(self.articleInfoLabel.frame)+10, 0, 0);
        self.timeArticleLabel.text = timeArticle.articleStr;
        self.timeArticleLabel.frame = CGRectMake2(10, CGRectGetMaxY(self.imageV.frame)+10, WIDTH-20, 300);
        _timeArticleLabel.numberOfLines = 0;
        [self.timeArticleLabel sizeToFit];
        self.timeArticleScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.timeArticleLabel.frame));
    }
//    self.timeArticleLabel.text = timeArticle.articleStr;
//    self.timeArticleLabel.frame = CGRectMake(10, CGRectGetMaxY(self.imageV.frame)+10, WIDTH-20, 300);
//    _timeArticleLabel.numberOfLines = 0;
//    [self.timeArticleLabel sizeToFit];
//    //ScrollView可滚动范围
//    self.timeArticleScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.timeArticleLabel.frame)+5);
}
//等比缩放
-(void)compressImage:(CGFloat)wi image:(UIImage *)image
{
    CGSize s = image.size;
    //等比缩放
    float w = wi;
    float h = (w * s.height)/s.width;
    //重置imageview的尺寸
    self.imageV.frame = CGRectMake1(5, CGRectGetMaxY(self.articleInfoLabel.frame)+5, w, h);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
