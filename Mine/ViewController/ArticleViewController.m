//
//  ArticleViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/15.
//  Copyright © 2015年 9527. All rights reserved.
//

#define SPACE_Y 16*SCALE_Y
#define SPACE_Y2 15*SCALE_Y

#import "ArticleViewController.h"
#import "ArticleModel.h"
#import "ArticleView.h"
//网页版文章模块
#import "ArticleWebViewController.h"


@interface ArticleViewController ()

@property(nonatomic,retain)ArticleView *articleView;
@property(nonatomic,retain)ArticleModel *article;
//双击返回手势
@property(nonatomic,retain)UITapGestureRecognizer *backToHomePageTapGR;
//接收解析后数据的字典
@property(nonatomic,strong)NSMutableDictionary *articleHtmlDict;
//单击收起字体设置按钮手势
@property(nonatomic,retain)UITapGestureRecognizer *buttonHiddenTapGR;
//左划随机下一篇手势
@property(nonatomic,retain)UISwipeGestureRecognizer *nextPageSwipGR;
//提示
@property(nonatomic,strong) UIAlertController *alert;
@property(nonatomic,assign) NSInteger fontSize;
@property(nonatomic,strong) UITapGestureRecognizer *setTap;
@property(nonatomic,assign) BOOL isAppear;
//上次滑动的位置 滑动隐藏状态栏
@property(nonatomic,assign) NSInteger lastPosition;
//九个按钮
@property(nonatomic,retain)UIButton *button1;
@property(nonatomic,retain)UIButton *button2;
@property(nonatomic,retain)UIButton *button3;
@property(nonatomic,retain)UIButton *button4;
@property(nonatomic,retain)UIButton *button5;
@property(nonatomic,retain)UIButton *button6;
@property(nonatomic,retain)UIButton *button7;
@property(nonatomic,retain)UIButton *button8;
@property(nonatomic,retain)UIButton *button9;
//换源
@property(nonatomic,retain)UIButton *button10;
//弹出/隐藏九个设置按钮
@property(nonatomic,assign)BOOL buttonOutIn;

@property(nonatomic,retain)UIColor *bgColor;
@property(nonatomic,retain)UIColor *textColor1;
@property(nonatomic,retain)UIColor *textColor2;


@end

@implementation ArticleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左边返回图标
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake6(0, 0, 32, 32);
    backButton.layer.cornerRadius = 16;
    backButton.layer.masksToBounds = YES;
    [backButton setImage:[UIImage imageNamed:@"holder.jpg"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backing) forControlEvents:UIControlEventTouchUpInside];
    // button 加在view上防止变形
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [leftView addSubview:backButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = item;
    
//    UILabel *itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(50, 0, 100, 30)];
//    itemTitleLabel.text = @"Article";
//    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
//    itemTitleLabel.textColor = [UIColor grayColor];
//    itemTitleLabel.font = [UIFont systemFontOfSize:18];
//    self.navigationItem.titleView = itemTitleLabel;
    
    //右边字体大小设置图标
    UIButton *fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fontButton.frame = CGRectMake6(0, 0, 32, 32);
    fontButton.layer.cornerRadius = 16;
    fontButton.layer.masksToBounds = YES;
    [fontButton setTitle:@"A" forState:UIControlStateNormal];
    [fontButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    fontButton.layer.borderWidth = 1;
    fontButton.layer.borderColor = [UIColor grayColor].CGColor;
    [fontButton addTarget:self action:@selector(buttonOutInAction) forControlEvents:UIControlEventTouchUpInside];
    // button 加在view上防止变形
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [rightView addSubview:fontButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //双击返回手势
    self.backToHomePageTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backing)];
    _backToHomePageTapGR.numberOfTapsRequired = 2;
    //单击收起字体设置手势
    self.buttonHiddenTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonHiddenTapGRAction)];
    _buttonHiddenTapGR.numberOfTapsRequired = 1;
    //左划随机下一篇手势
    self.nextPageSwipGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPageSwipGRAction)];
    _nextPageSwipGR.direction = UISwipeGestureRecognizerDirectionLeft;
 
    //控件初始化
    [self setUpArticleView];
    //网络请求
    [self articleHttpRequest];
    //九个设置按钮初始化
    [self setUpButton];
    //添加单击收起字体设置手势
    [self.articleView addGestureRecognizer:self.buttonHiddenTapGR];
    
    [self fontAndBGColor];

    
}
//控件初始化
-(void)setUpArticleView
{
    self.articleView = [[ArticleView alloc] initWithFrame:CGRectMake1(0, 0, WIDTH, HEIGHT-64)];
    _articleView.backgroundColor = [UIColor colorWithRed:254/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    //添加手势
    [_articleView addGestureRecognizer:self.backToHomePageTapGR];
    [_articleView addGestureRecognizer:self.buttonHiddenTapGR];
    [_articleView addGestureRecognizer:self.nextPageSwipGR];
    [self.view addSubview:_articleView];
    self.articleView.articleScrollView.delegate = (id)self;
}

//请求网络加载数据
-(void)articleHttpRequest
{
    
    __block ArticleViewController *articleVC = self;
    HTTPTool *tool = [[HTTPTool alloc] init];
    [tool requestDataByTime:[StringFromDate stringFromDateBeforeToday:self.day]];
    NSLog(@"date=%@",[StringFromDate stringFromDateBeforeToday:self.day]);
    [tool requestArticleByDateController:self InfoBlock:^(NSData *articleData) {
        
        [articleVC hideLoadingView];
        
        if (articleData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:articleData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *contentEntityDict = dict[@"contentEntity"];
            self.article = [ArticleModel articleModelWithDictionary:contentEntityDict];
            //NSLog(@"%ld",self.article.articleString.length);
            if (self.article.articleString.length == 0) {
                [self tfhppleHtml];
                self.article = [ArticleModel articleModelWithDictionary:self.articleHtmlDict];
            }
            [self performSelectorOnMainThread:@selector(backToMainThread) withObject:nil waitUntilDone:NO];
        }
        else
        {
            
        }
        
    }];
}
//TFHpple解析html
-(void)tfhppleHtml
{
    //接收解析后数据的字典
    self.articleHtmlDict = [NSMutableDictionary dictionary];
    //TFHpple解析html
    NSString *dayStr = [StringFromDate stringFromDateBeforeToday:self.day];
    NSLog(@"date2=%@",dayStr);
    //日期
    [_articleHtmlDict setObject:dayStr forKey:@"strContMarketTime"];
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.wufazhuce.com/article/%@",dayStr]]];
    //解析html数据
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    //根据标签来进行过滤
    NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//div"];
    //开始整理数据
    for (TFHppleElement *tempAElement in dataArray) {
        if ([[tempAElement objectForKey:@"class"] isEqualToString:@"text-detail"]) {
            NSArray *titleArray = [tempAElement searchWithXPathQuery:@"//p"];
            for (TFHppleElement *tempAElement in titleArray) {
                //NSLog(@"%@",tempAElement.text);
                if ([[tempAElement objectForKey:@"class"] isEqualToString:@"text-title"]) {
                    //题目
                    NSLog(@"title=%@",tempAElement.text);
                    [_articleHtmlDict setObject:tempAElement.text forKey:@"strContTitle"];
                }
                if ([[tempAElement objectForKey:@"class"] isEqualToString:@"text-author"]) {
                    //作者
                    //NSLog(@"text-author=%@",tempAElement.text);
                    [_articleHtmlDict setObject:tempAElement.text forKey:@"strContAuthor"];
                }
            }
        }
        //内容、作者简介
        if ([[tempAElement objectForKey:@"class"] isEqualToString:@"text-content"]) {
            NSArray *articleArray = [tempAElement searchWithXPathQuery:@"//p"];
            //文章内容
            for (TFHppleElement *tempAElement in articleArray) {
                NSLog(@"content=%@",tempAElement.raw);
                if (tempAElement.raw) {
                    
                    NSString *string = tempAElement.raw;
                    NSRange range1 = [string rangeOfString:@"<p>"];
                    NSRange range2 = [string rangeOfString:@"<br>"];
                    NSRange range3 = [string rangeOfString:@"</p>"];
                    NSRange range4 = [string rangeOfString:@"<br/>"];
                    if (range1.length > 0) {
                        string = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n"];
                    }if (range2.length > 0) {
                        string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n\n"];
                    }if (range3.length > 0) {
                        string = [string stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
                    }if (range4.length > 0) {
                        string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
                    }
                    
                    [_articleHtmlDict setObject:string forKey:@"content"];
                }
            }
            //本文选自XXX
            NSArray *whereArray = [tempAElement searchWithXPathQuery:@"//em"];
            for (TFHppleElement *tempAElement in whereArray) {
                NSLog(@"where=%@",tempAElement.text);
            }
            //作者简介
            NSArray *authorInfoArray = [tempAElement searchWithXPathQuery:@"//strong"];
            for (TFHppleElement *tempAElement in authorInfoArray) {
                //NSLog(@"authorInfo=%@",tempAElement.text);
                [_articleHtmlDict setObject:tempAElement.text forKey:@"sAuth"];
            }
        }
    }
}
//回到主线程 更新UI界面 控件赋值
-(void)backToMainThread
{
    [self.articleView configureWithArticle:self.article];
}

//字体大小及背景色
-(void)fontAndBGColor
{
    //字体大小
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"F"]) {
        self.fontSize = 14;
    }
    else
    {
        self.fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"F"] integerValue];
    }
    //背景
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"w"])
    {
        [self button3Action];//白色背景
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"g"])
    {
        [self button4Action];//绿色
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"g1"])
    {
        [self button5Action];//深绿色
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"y1"])
    {
        [self button6Action];//米黄色1
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"y2"])
    {
        [self button7Action];//米黄色2
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"y3"])
    {
        [self button8Action];//米黄色3
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"b"])
    {
        [self button9Action];//黑色
    }else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
            self.articleView.backgroundColor = [UIColor whiteColor];
            self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            self.view.backgroundColor = [UIColor whiteColor];
            UIColor *color = [UIColor grayColor];
            UIColor *color2 = [UIColor blackColor];
            [self.articleView setColor:color Color2:color2];
            
            //状态栏
            UIView *view = [[UIApplication sharedApplication].delegate window];
            view.backgroundColor = [UIColor whiteColor];
            
        }
        else
        {
            UIColor *color0 = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:70/255.0 alpha:1.0];
            self.articleView.backgroundColor = color0;
            self.navigationController.navigationBar.barTintColor = color0;
            self.view.backgroundColor = color0;
            UIColor *color = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
            UIColor *color2 = [UIColor colorWithRed:172 / 255.0 green:177 / 255.0 blue:180 / 255.0 alpha:1];
            [self.articleView setColor:color Color2:color2];
            
            //状态栏
            UIView *view = [[UIApplication sharedApplication].delegate window];
            view.backgroundColor = color0;
            
        }
    }
}
//九个按钮初始化
-(void)setUpButton
{
    //字体放大
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button1.frame = CGRectMake6(WIDTH+1, 15, 32, 32);
    _button1.layer.cornerRadius = SPACE_Y;
    _button1.layer.masksToBounds = YES;
    _button1.layer.borderColor = [UIColor grayColor].CGColor;
    _button1.layer.borderWidth = 0.5;
    _button1.alpha = 0;
    [_button1 setTitle:@"A+" forState:UIControlStateNormal];
    _button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:_button1];
    [self.button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //字体缩小
    _button2.frame = CGRectMake6(WIDTH+1, 15*2+32, 32, 32);
    _button2.layer.cornerRadius = SPACE_Y;
    _button2.layer.masksToBounds = YES;
    _button2.layer.borderColor = [UIColor grayColor].CGColor;
    _button2.layer.borderWidth = 0.5;
    _button2.alpha = 0;
    [_button2 setTitle:@"A-" forState:UIControlStateNormal];
    _button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:_button2];
    [self.button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    //白色
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button3.frame = CGRectMake6(WIDTH+1, 15*3+32*2, 32, 32);
    _button3.layer.cornerRadius = SPACE_Y;
    _button3.layer.masksToBounds = YES;
    _button3.layer.borderColor = [UIColor grayColor].CGColor;
    _button3.layer.borderWidth = 0.5;
    _button3.alpha = 0;
    _button3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_button3];
    [self.button3 addTarget:self action:@selector(button3Action) forControlEvents:UIControlEventTouchUpInside];
    //绿色
    self.button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button4.frame = CGRectMake6(WIDTH+1, 15*4+32*3, 32, 32);
    _button4.layer.cornerRadius = SPACE_Y;
    _button4.layer.masksToBounds = YES;
    _button4.layer.borderColor = [UIColor grayColor].CGColor;
    _button4.layer.borderWidth = 0.5;
    _button4.alpha = 0;
    _button4.backgroundColor = [UIColor colorWithRed:165/255.0 green:198/255.0 blue:166/255.0 alpha:1];
    [self.view addSubview:_button4];
    [self.button4 addTarget:self action:@selector(button4Action) forControlEvents:UIControlEventTouchUpInside];
    //深绿色
    self.button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button5.frame = CGRectMake6(WIDTH+1, 15*5+32*4, 32, 32);
    _button5.layer.cornerRadius = SPACE_Y;
    _button5.layer.masksToBounds = YES;
    _button5.layer.borderColor = [UIColor grayColor].CGColor;
    _button5.layer.borderWidth = 0.5;
    _button5.alpha = 0;
    _button5.backgroundColor = [UIColor colorWithRed:87/255.0 green:112/255.0 blue:87/255.0 alpha:1];
    [self.view addSubview:_button5];
    [self.button5 addTarget:self action:@selector(button5Action) forControlEvents:UIControlEventTouchUpInside];
    //米黄色
    self.button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button6.frame = CGRectMake6(WIDTH+1, 15*6+32*5, 32, 32);
    _button6.layer.cornerRadius = SPACE_Y;
    _button6.layer.masksToBounds = YES;
    _button6.layer.borderColor = [UIColor grayColor].CGColor;
    _button6.layer.borderWidth = 0.5;
    _button6.alpha = 0;
    _button6.backgroundColor = [UIColor colorWithRed:203/255.0 green:202/255.0 blue:173/255.0 alpha:1];
    [self.view addSubview:_button6];
    [self.button6 addTarget:self action:@selector(button6Action) forControlEvents:UIControlEventTouchUpInside];
    //米黄色2
    self.button7 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button7.frame = CGRectMake6(WIDTH+1, 15*7+32*6, 32, 32);
    _button7.layer.cornerRadius = SPACE_Y;
    _button7.layer.masksToBounds = YES;
    _button7.layer.borderColor = [UIColor grayColor].CGColor;
    _button7.layer.borderWidth = 0.5;
    _button7.alpha = 0;
    _button7.backgroundColor = [UIColor colorWithRed:215/255.0 green:198/255.0 blue:165/255.0 alpha:1];
    [self.view addSubview:_button7];
    [self.button7 addTarget:self action:@selector(button7Action) forControlEvents:UIControlEventTouchUpInside];
    //米黄色3
    self.button8 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button8.frame = CGRectMake6(WIDTH+1, 15*8+32*7, 32, 32);
    _button8.layer.cornerRadius = SPACE_Y;
    _button8.layer.masksToBounds = YES;
    _button8.layer.borderColor = [UIColor grayColor].CGColor;
    _button8.layer.borderWidth = 0.5;
    _button8.alpha = 0;
    _button8.backgroundColor = [UIColor colorWithRed:222/255.0 green:197/255.0 blue:195/255.0 alpha:1];
    [self.view addSubview:_button8];
    [self.button8 addTarget:self action:@selector(button8Action) forControlEvents:UIControlEventTouchUpInside];
    //灰黑色
    self.button9 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button9.frame = CGRectMake6(WIDTH+1, 15*9+32*8, 32, 32);
    _button9.layer.cornerRadius = SPACE_Y;
    _button9.layer.masksToBounds = YES;
    _button9.layer.borderColor = [UIColor grayColor].CGColor;
    _button9.layer.borderWidth = 0.5;
    _button9.alpha = 0;
    _button9.backgroundColor = [UIColor colorWithRed:41/255.0 green:46/255.0 blue:43/255.0 alpha:1];
    [self.view addSubview:_button9];
    [self.button9 addTarget:self action:@selector(button9Action) forControlEvents:UIControlEventTouchUpInside];
    //换源
    self.button10 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button10.frame = CGRectMake6(WIDTH+1, 15*10+32*9, 32, 32);
    _button10.layer.cornerRadius = SPACE_Y;
    _button10.layer.masksToBounds = YES;
    _button10.layer.borderColor = [UIColor grayColor].CGColor;
    _button10.layer.borderWidth = 0.5;
    _button10.alpha = 0;
    [_button10 setTitle:@"换源" forState:UIControlStateNormal];
    _button10.titleLabel.font = [UIFont systemFontOfSize:12];
    _button10.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_button10];
    [self.button10 addTarget:self action:@selector(buttonTenAction) forControlEvents:UIControlEventTouchUpInside];

    
}
-(void)buttonOutInAction
{
    if (self.buttonOutIn) {
        [self buttonIn];
    }
    else
    {
        [self buttonOut];
    }
}
//收起设置按钮
-(void)buttonIn
{
    self.buttonOutIn = NO;
    [UIView animateWithDuration:1.0 animations:^{
        self.button1.frame = CGRectMake6(WIDTH+1, 15, 32, 32);
        self.button1.alpha = 0;
    }];
    [UIView animateWithDuration:1.1 animations:^{
        self.button2.frame = CGRectMake7(WIDTH+1, CGRectGetMaxY(self.button1.frame)+SPACE_Y2, 32, 32);
        self.button2.alpha = 0;
    }];
    [UIView animateWithDuration:1.2 animations:^{
        self.button3.frame = CGRectMake7(WIDTH+1, CGRectGetMaxY(self.button2.frame)+SPACE_Y2, 32, 32);
        self.button3.alpha = 0;
    }];
    [UIView animateWithDuration:1.3 animations:^{
        self.button4.frame = CGRectMake7(WIDTH+1, CGRectGetMaxY(self.button3.frame)+SPACE_Y2, 32, 32);
        self.button4.alpha = 0;
    }];
    [UIView animateWithDuration:1.4 animations:^{
        self.button5.frame = CGRectMake7(WIDTH+1, CGRectGetMaxY(self.button4.frame)+SPACE_Y2, 32, 32);
        self.button5.alpha = 0;
    }];
    [UIView animateWithDuration:1.5 animations:^{
        self.button6.frame = CGRectMake7(WIDTH+1, CGRectGetMaxY(self.button5.frame)+SPACE_Y2, 32, 32);
        self.button6.alpha = 0;
    }];
    [UIView animateWithDuration:1.6 animations:^{
        self.button7.frame = CGRectMake7(WIDTH+1, CGRectGetMaxY(self.button6.frame)+SPACE_Y2, 32, 32);
        self.button7.alpha = 0;
    }];
    [UIView animateWithDuration:1.7 animations:^{
        self.button8.frame = CGRectMake7(WIDTH+1, CGRectGetMaxY(self.button7.frame)+SPACE_Y2, 32, 32);
        self.button8.alpha = 0;
    }];
    [UIView animateWithDuration:1.8 animations:^{
        self.button9.frame = CGRectMake7(WIDTH+1, CGRectGetMaxY(self.button8.frame)+SPACE_Y2, 32, 32);
        self.button9.alpha = 0;
    }];
    [UIView animateWithDuration:1.8 animations:^{
        self.button10.frame = CGRectMake7(WIDTH+1, CGRectGetMaxY(self.button9.frame)+SPACE_Y2, 32, 32);
        self.button10.alpha = 0;
    }];
}
//弹出设置按钮
-(void)buttonOut
{
    self.buttonOutIn = YES;
    [UIView animateWithDuration:1.0 animations:^{
        self.button1.frame = CGRectMake6(WIDTH-18-32, 15, 32, 32);
        self.button1.alpha = 0.8;
    }];
    [UIView animateWithDuration:1.1 animations:^{
        self.button2.frame = CGRectMake7((WIDTH-18-32), CGRectGetMaxY(self.button1.frame)+SPACE_Y2, 32, 32);
        self.button2.alpha = 0.8;
    }];
    [UIView animateWithDuration:1.2 animations:^{
        self.button3.frame = CGRectMake7(WIDTH-18-32, CGRectGetMaxY(self.button2.frame)+SPACE_Y2, 32, 32);
        self.button3.alpha = 0.8;
    }];
    [UIView animateWithDuration:1.3 animations:^{
        self.button4.frame = CGRectMake7(WIDTH-18-32, CGRectGetMaxY(self.button3.frame)+SPACE_Y2, 32, 32);
        self.button4.alpha = 0.8;
    }];
    [UIView animateWithDuration:1.4 animations:^{
        self.button5.frame = CGRectMake7(WIDTH-18-32, CGRectGetMaxY(self.button4.frame)+SPACE_Y2, 32, 32);
        self.button5.alpha = 0.8;
    }];
    [UIView animateWithDuration:1.5 animations:^{
        self.button6.frame = CGRectMake7(WIDTH-18-32, CGRectGetMaxY(self.button5.frame)+SPACE_Y2, 32, 32);
        self.button6.alpha = 0.8;
    }];
    [UIView animateWithDuration:1.6 animations:^{
        self.button7.frame = CGRectMake7(WIDTH-18-32, CGRectGetMaxY(self.button6.frame)+SPACE_Y2, 32, 32);
        self.button7.alpha = 0.8;
    }];
    [UIView animateWithDuration:1.7 animations:^{
        self.button8.frame = CGRectMake7(WIDTH-18-32, CGRectGetMaxY(self.button7.frame)+SPACE_Y2, 32, 32);
        self.button8.alpha = 0.8;
    }];
    [UIView animateWithDuration:1.8 animations:^{
        self.button9.frame = CGRectMake7(WIDTH-18-32, CGRectGetMaxY(self.button8.frame)+SPACE_Y2, 32, 32);
        self.button9.alpha = 0.8;
    }];
    [UIView animateWithDuration:1.8 animations:^{
        self.button10.frame = CGRectMake7(WIDTH-18-32, CGRectGetMaxY(self.button9.frame)+SPACE_Y2, 32, 32);
        self.button10.alpha = 0.8;
    }];
}
//放大字体
-(void)button1Action
{
    if (_fontSize < 22) {
        _fontSize = _fontSize + 1;
        [self.articleView setFont:_fontSize];
    }
    [self backToMainThread];
}
//缩小字体
-(void)button2Action
{
    if (_fontSize > 12) {
        _fontSize = _fontSize - 1;
        [self.articleView setFont:_fontSize];
    }
    [self backToMainThread];
    

    
}
//白色
-(void)button3Action
{
    self.bgColor = [UIColor whiteColor];
    self.textColor1 = [UIColor grayColor];
    self.textColor2 = [UIColor blackColor];
    [[NSUserDefaults standardUserDefaults] setObject:@"w" forKey:@"C"];
    [self colorChange];
}
//绿色
-(void)button4Action
{
    self.bgColor = [UIColor colorWithRed:165/255.0 green:198/255.0 blue:166/255.0 alpha:1];
    self.textColor1 = [UIColor colorWithRed:90 / 255.0 green:91 / 255.0 blue:92 / 255.0 alpha:1];
    self.textColor2 = [UIColor blackColor];
    [[NSUserDefaults standardUserDefaults] setObject:@"g" forKey:@"C"];
    [self colorChange];
}
//深绿色
-(void)button5Action
{
    self.bgColor = [UIColor colorWithRed:87/255.0 green:112/255.0 blue:87/255.0 alpha:1];
    self.textColor1 = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
    self.textColor2 = [UIColor blackColor];
    [[NSUserDefaults standardUserDefaults] setObject:@"g1" forKey:@"C"];
    [self colorChange];
}
//米黄色
-(void)button6Action
{
    self.bgColor = [UIColor colorWithRed:203/255.0 green:202/255.0 blue:173/255.0 alpha:1];
    self.textColor1 = [UIColor colorWithRed:90 / 255.0 green:91 / 255.0 blue:92 / 255.0 alpha:1];
    self.textColor2 = [UIColor blackColor];
    [[NSUserDefaults standardUserDefaults] setObject:@"y1" forKey:@"C"];
    [self colorChange];
}
//米黄色2
-(void)button7Action
{
    self.bgColor = [UIColor colorWithRed:215/255.0 green:198/255.0 blue:165/255.0 alpha:1];
    self.textColor1 = [UIColor colorWithRed:90 / 255.0 green:91 / 255.0 blue:92 / 255.0 alpha:1];
    self.textColor2 = [UIColor blackColor];
    [[NSUserDefaults standardUserDefaults] setObject:@"y2" forKey:@"C"];
    [self colorChange];
}
//米黄色3
-(void)button8Action
{
    self.bgColor = [UIColor colorWithRed:222/255.0 green:197/255.0 blue:195/255.0 alpha:1];
    self.textColor1 = [UIColor colorWithRed:90 / 255.0 green:91 / 255.0 blue:92 / 255.0 alpha:1];
    self.textColor2 = [UIColor blackColor];
    [[NSUserDefaults standardUserDefaults] setObject:@"y3" forKey:@"C"];
    [self colorChange];
}
//灰黑色
-(void)button9Action
{
    self.bgColor = [UIColor colorWithRed:41/255.0 green:46/255.0 blue:43/255.0 alpha:1];
    self.textColor1 = [UIColor colorWithRed:135 / 255.0 green:135 / 255.0 blue:135 / 255.0 alpha:1];
    self.textColor2 = [UIColor colorWithRed:172 / 255.0 green:177 / 255.0 blue:180 / 255.0 alpha:1];
    [[NSUserDefaults standardUserDefaults] setObject:@"b" forKey:@"C"];
    [self colorChange];
}
//颜色切换
-(void)colorChange
{
    self.articleView.backgroundColor = self.bgColor;
    self.navigationController.navigationBar.barTintColor = self.bgColor;
    //状态栏
    UIView *view = [[UIApplication sharedApplication].delegate window];
    view.backgroundColor = self.bgColor;
    self.view.backgroundColor = self.bgColor;
    [self.articleView setColor:self.textColor1 Color2:self.textColor2];
}

//换源
-(void)buttonTenAction
{
    ArticleWebViewController *articleWebVC = [[ArticleWebViewController alloc] init];
    UINavigationController *articleWebNC = [[UINavigationController alloc] initWithRootViewController:articleWebVC];
    articleWebVC.day = self.day;
    [self presentViewController:articleWebNC animated:YES completion:^{
        
    }];
}
//左划随机下一篇手势
-(void)nextPageSwipGRAction
{
    self.day = arc4random()%456;
    [self articleHttpRequest];
}
//点击屏幕收起设置按钮手势
-(void)buttonHiddenTapGRAction
{
    [self buttonIn];
}
-(void)backing
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//判断滑动方向 隐藏导航栏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //设置按钮若是没有收起则收起
    [self buttonHiddenTapGRAction];
    
    int currentPostion = scrollView.contentOffset.y;
    //上拉
    if (currentPostion - _lastPosition > 10  && currentPostion > 0) {
        _lastPosition = currentPostion;
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:0.6 animations:^{
            self.articleView.frame = CGRectMake1(0, 0, WIDTH, HEIGHT);
        }];
    }
    else if ((_lastPosition - currentPostion > 10) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-10))
    {
        _lastPosition = currentPostion;
        //显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:0.6 animations:^{
            self.articleView.frame = CGRectMake1(0, 0, WIDTH, HEIGHT-64);
        }];
    }
}
//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    if (self.navigationController.navigationBarHidden == YES) {
        return YES;
    }else{
        return NO;
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
