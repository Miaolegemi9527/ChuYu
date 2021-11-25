//
//  ArticleWebViewController.m
//  Mine
//
//  Created by lanou on 16/1/3.
//  Copyright © 2016年 9527. All rights reserved.
//

#import "ArticleWebViewController.h"
#import "ArticleModel.h"

@interface ArticleWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property(nonatomic,retain)ArticleModel *article;
//双击返回手势
@property(nonatomic,retain)UITapGestureRecognizer *backToHomePageTapGR;
@property(nonatomic,retain)UIWebView *articleWebView;
@property(nonatomic,retain)NSURLRequest *request;
//上次滑动的位置
@property(nonatomic,assign) NSInteger lastPosition;
//背景色代码字符串
@property(nonatomic,strong)NSString *webColorStr;
//背景色
@property(nonatomic,strong)UIColor *bgColor;

@end

@implementation ArticleWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //左边返回图标
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake4(0, 0, 32, 32);
    backButton.layer.cornerRadius = 16;
    backButton.layer.masksToBounds = YES;
    [backButton setImage:[UIImage imageNamed:@"holder"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backing) forControlEvents:UIControlEventTouchUpInside];
    // button 加在view上防止变形
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [leftView addSubview:backButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = item;
    
    self.articleWebView = [[UIWebView alloc] initWithFrame:CGRectMake2(0, 0, WIDTH, HEIGHT-64)];
    //_timeArticleWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.articleWebView];
    //签协议UIWebViewDelegate
    _articleWebView.delegate = self;
    //签协议UIScrollViewDelegate
    _articleWebView.scrollView.delegate = self;
    //禁止显示滚动条、禁止反弹
    self.articleWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.articleWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.articleWebView.scrollView.bounces = NO;
    //整体自适应
    //[self.timeArticleWebView setScalesPageToFit:YES];
    
    //背景色
    [self backgroundColor];
    
    UITapGestureRecognizer *backTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backing)];
    backTapGR.numberOfTapsRequired = 1;
    [self.articleWebView.scrollView addGestureRecognizer:backTapGR];
    
    
    //TFHpple解析html
    NSString *dayStr = [StringFromDate stringFromDateBeforeToday:self.day];
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.wufazhuce.com/article/%@",dayStr]]];
    //解析html数据
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    //根据标签来进行过滤
    NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//div"];
    //开始整理数据
    NSMutableString *htmlStr = [NSMutableString string];
    for (TFHppleElement *tempElement in dataArray) {
        if ([[tempElement objectForKey:@"class"] isEqualToString:@"text-detail"]) {
            //NSLog(@"%@",tempElement.raw);
            if (tempElement.raw) {
                [htmlStr appendString:tempElement.raw];
            }
            
        }
    }
    //NSLog(@"%@",htmlStr);
    [self.articleWebView loadHTMLString:htmlStr baseURL:nil];

}
-(void)backing
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//判断滑动方向
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    //上拉
    if (currentPostion - _lastPosition > 5  && currentPostion > 0) {
        _lastPosition = currentPostion;
        self.navigationController.navigationBarHidden = YES;
        [self prefersStatusBarHidden];
        self.articleWebView.frame = CGRectMake2(0, 0, WIDTH, HEIGHT);
    }
    else if ((_lastPosition - currentPostion > 5) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-5))
    {
        _lastPosition = currentPostion;
        //显示导航栏
        self.navigationController.navigationBarHidden = NO;
        [self prefersStatusBarHidden];
        self.articleWebView.frame = CGRectMake2(0, 0, WIDTH, HEIGHT-64);
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    //背景色
    //背景
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"w"])
    {
        self.bgColor = [UIColor whiteColor];//白色背景
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#ffffff'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"g"])
    {
        self.bgColor = [UIColor colorWithRed:165/255.0 green:198/255.0 blue:166/255.0 alpha:1];//绿色
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#a5c6a6'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"g1"])
    {
        self.bgColor = [UIColor colorWithRed:87/255.0 green:112/255.0 blue:87/255.0 alpha:1];//深绿色
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#577057'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"y1"])
    {
        self.bgColor = [UIColor colorWithRed:203/255.0 green:202/255.0 blue:173/255.0 alpha:1];//米黄色1
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#cbcaad'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"y2"])
    {
        self.bgColor = [UIColor colorWithRed:215/255.0 green:198/255.0 blue:165/255.0 alpha:1];//米黄色2
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#d7c6a5'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"y3"])
    {
        self.bgColor = [UIColor colorWithRed:222/255.0 green:197/255.0 blue:195/255.0 alpha:1];//米黄色3
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#dec5c3'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"b"])
    {
        self.bgColor = [UIColor colorWithRed:41/255.0 green:46/255.0 blue:43/255.0 alpha:1];//黑色
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#292e2b'"];
    }
    else
    {
        
    }
    webView.scrollView.backgroundColor = self.bgColor;
    webView.backgroundColor = self.bgColor;
    self.navigationController.navigationBar.barTintColor = self.bgColor;
    self.view.backgroundColor = self.bgColor;
    
}
//点击当前网页链接不跳转
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击了链接
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        //不请求
        return NO;
    }
    return YES;
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
//背景色
-(void)backgroundColor
{
    //背景色
    //背景
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"w"])
    {
        self.bgColor = [UIColor whiteColor];//白色背景
        [self.articleWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#ffffff'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"g"])
    {
        self.bgColor = [UIColor colorWithRed:165/255.0 green:198/255.0 blue:166/255.0 alpha:1];//绿色
        [self.articleWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#a5c6a6'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"g1"])
    {
        self.bgColor = [UIColor colorWithRed:87/255.0 green:112/255.0 blue:87/255.0 alpha:1];//深绿色
        [self.articleWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#577057'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"y1"])
    {
        self.bgColor = [UIColor colorWithRed:203/255.0 green:202/255.0 blue:173/255.0 alpha:1];//米黄色1
        [self.articleWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#cbcaad'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"y2"])
    {
        self.bgColor = [UIColor colorWithRed:215/255.0 green:198/255.0 blue:165/255.0 alpha:1];//米黄色2
        [self.articleWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#d7c6a5'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"y3"])
    {
        self.bgColor = [UIColor colorWithRed:222/255.0 green:197/255.0 blue:195/255.0 alpha:1];//米黄色3
        [self.articleWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#dec5c3'"];
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"C"] isEqualToString:@"b"])
    {
        self.bgColor = [UIColor colorWithRed:41/255.0 green:46/255.0 blue:43/255.0 alpha:1];//黑色
        [self.articleWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#292e2b'"];
    }
    else
    {
        //日夜间模式
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
            
            self.bgColor = [UIColor whiteColor];
            [self.articleWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#333333'"];
        }
        else
        {
            
            self.bgColor = [UIColor colorWithRed:41/255.0 green:46/255.0 blue:43/255.0 alpha:1];//黑色
            [self.articleWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#333333'"];
        }
    }
    self.articleWebView.scrollView.backgroundColor = self.bgColor;
    self.articleWebView.backgroundColor = self.bgColor;
    self.navigationController.navigationBar.barTintColor = self.bgColor;
    self.view.backgroundColor = self.bgColor;
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
