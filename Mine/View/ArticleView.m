//
//  ArticleView.m
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "ArticleView.h"

@interface ArticleView ()


//文章
@property(nonatomic,retain)UILabel *articleLabel;
//日期
@property(nonatomic,retain)UILabel *timeLabel;
//标题
@property(nonatomic,retain)UILabel *titleL;
//标题
//底部分割线
@property(nonatomic,retain)UILabel *lineLabel;
//作者
@property(nonatomic,retain)UILabel *authorLabel;
//字数
@property(nonatomic,retain)UILabel *wordCountLabel;
//简介
@property(nonatomic,retain)UILabel *sAuthLabel;
//上次滑动的位置
@property(nonatomic,assign) NSInteger lastPosition;
//字体大小
@property(nonatomic,assign)NSInteger fontSize;

@end

@implementation ArticleView

//二、重写初始化方法]
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpArticleView];
    }
    return self;
}
//三、写布局方法]
-(void)setUpArticleView
{
    self.articleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake1(5, 0, WIDTH-10, HEIGHT)];
    _articleScrollView.backgroundColor = [UIColor clearColor];
    //_articleScrollView.showsVerticalScrollIndicator = NO;//隐藏右侧指示条
    [self addSubview:_articleScrollView];
    //日期
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake1(5, 10, WIDTH-20, 20)];
    _timeLabel.font = [UIFont boldSystemFontOfSize:12];
    _timeLabel.textColor = [UIColor grayColor];
    [self.articleScrollView addSubview:_timeLabel];
    _timeLabel.backgroundColor = [UIColor clearColor];
    //题目
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake1(5, 45, WIDTH-20, 20)];
    _titleL.textAlignment = NSTextAlignmentCenter;
    _titleL.font = [UIFont boldSystemFontOfSize:18];
    [self.articleScrollView addSubview:_titleL];
    _titleL.backgroundColor = [UIColor clearColor];
    //字数
    self.wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake2(5, CGRectGetMaxY(self.titleL.frame)+20, WIDTH-30, 10)];
    _wordCountLabel.font = [UIFont boldSystemFontOfSize:12];
    _wordCountLabel.textAlignment = NSTextAlignmentRight;
    _wordCountLabel.textColor = [UIColor grayColor];
    [self.articleScrollView addSubview:_wordCountLabel];
    _wordCountLabel.backgroundColor = [UIColor clearColor];

    
    //作者
    self.authorLabel  = [[UILabel alloc] initWithFrame:CGRectMake2(5, CGRectGetMaxY(self.titleL.frame)+15, WIDTH-20, 15)];
    _authorLabel.font = [UIFont systemFontOfSize:16];
    //_authorLabel.textAlignment = NSTextAlignmentCenter;
    _authorLabel.textColor = [UIColor grayColor];
    [self.articleScrollView addSubview:_authorLabel];
    _authorLabel.backgroundColor = [UIColor clearColor];
    //简介
    self.sAuthLabel = [[UILabel alloc] initWithFrame:CGRectMake2(5, CGRectGetMaxY(self.authorLabel.frame)+15, WIDTH-20, 15)];
    _sAuthLabel.font = [UIFont boldSystemFontOfSize:12];
    _sAuthLabel.numberOfLines = 0;
    [self.articleScrollView addSubview:_sAuthLabel];
    _sAuthLabel.backgroundColor = [UIColor clearColor];
    
    //文章
    self.articleLabel = [[UILabel alloc] initWithFrame:CGRectMake2(5, CGRectGetMaxY(self.titleL.frame)+40, WIDTH-20, 500)];
    _articleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    //self.fontSize = 14;
    //_articleLabel.backgroundColor = [UIColor orangeColor];
    _articleLabel.numberOfLines = 0;
    [self.articleScrollView addSubview:self.articleLabel];
    //分割线
    self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake2(5, CGRectGetMaxY(self.articleLabel.frame)+20, WIDTH-10, 0.5)];
    _lineLabel.backgroundColor = [UIColor grayColor];
    [self.articleScrollView addSubview:_lineLabel];
}
//赋值
-(void)configureWithArticle:(ArticleModel *)article
{
    //字体大小
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"F"]) {
        self.fontSize = 14;
    }
    else
    {
        self.fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"F"] integerValue];
    }
    self.timeLabel.text = article.timeString;//日期 有时不对应 注销不要
    self.titleL.text = article.titleString;
    self.wordCountLabel.text = [NSString stringWithFormat:@"字数：%ld",article.wordCount];
    self.articleLabel.text = article.articleString;
    //NSLog(@"article=%@",article.articleString);
    _articleLabel.frame = CGRectMake2(5, CGRectGetMaxY(self.titleL.frame)+40, WIDTH-20, 500);
    _articleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    _articleLabel.numberOfLines = 0;
    [self.articleLabel sizeToFit];
    //分割线
    self.lineLabel.frame = CGRectMake2(5, CGRectGetMaxY(self.articleLabel.frame)+10, WIDTH-10, 0.5);
    self.authorLabel.text = article.authorString;
    self.authorLabel.frame = CGRectMake2(5, CGRectGetMaxY(self.lineLabel.frame)+15, WIDTH-20, 15);
    self.sAuthLabel.text = article.sAuthString;//作者简介
    _sAuthLabel.frame = CGRectMake2(5, CGRectGetMaxY(self.authorLabel.frame)+10, WIDTH-20, 15);
    [_sAuthLabel sizeToFit];
    //ScrollView可滚动范围
    self.articleScrollView.contentSize = CGSizeMake(0, (CGRectGetMaxY(self.sAuthLabel.frame)+10));
}
-(void)setFont:(CGFloat)font
{
    self.articleLabel.font = [UIFont systemFontOfSize:font];
    //self.fontSize = font;
    [[NSUserDefaults standardUserDefaults] setInteger:font forKey:@"F"];
}
-(void)setColor:(UIColor *)color Color2:(UIColor *)color2
{
    self.timeLabel.textColor = color;
    self.titleL.textColor = color2;
    self.authorLabel.textColor = color2;
    self.sAuthLabel.textColor = color;
    self.wordCountLabel.textColor = color;
    self.articleLabel.textColor = color;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
