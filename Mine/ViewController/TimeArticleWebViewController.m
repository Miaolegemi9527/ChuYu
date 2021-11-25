//
//  TimeArticleWebViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "TimeArticleWebViewController.h"

@interface TimeArticleWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

//双击返回手势
@property(nonatomic,retain)UITapGestureRecognizer *backToHomePageTapGR;
@property(nonatomic,retain)UIWebView *timeArticleWebView;
@property(nonatomic,retain)NSURLRequest *request;
//上次滑动的位置
@property(nonatomic,assign) NSInteger lastPosition;
//网页内容高度
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,strong)NSString *htmlStr;
@end

@interface TimeArticleWebViewController ()

@end

@implementation TimeArticleWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    //日夜模式切换
    [self dayOrNight];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //self.navigationItem.title = @"Web";
    //左边返回图标
    UIButton *musicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    musicButton.frame = CGRectMake4(0, 0, 32, 32);
    musicButton.layer.cornerRadius = 16;
    musicButton.layer.masksToBounds = YES;
    [musicButton setImage:[UIImage imageNamed:@"holder"] forState:UIControlStateNormal];
    [musicButton addTarget:self action:@selector(backing) forControlEvents:UIControlEventTouchUpInside];
    // button 加在view上防止变形
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [leftView addSubview:musicButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = item;
    
    self.timeArticleWebView = [[UIWebView alloc] initWithFrame:CGRectMake2(0, 0, WIDTH, HEIGHT-64)];
    //_timeArticleWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.timeArticleWebView];
    //签协议UIWebViewDelegate
    _timeArticleWebView.delegate = self;
    //签协议UIScrollViewDelegate
    _timeArticleWebView.scrollView.delegate = self;
    //禁止显示滚动条、禁止反弹
    //self.timeArticleWebView.scrollView.showsVerticalScrollIndicator = NO;//垂直滚动条
    self.timeArticleWebView.scrollView.showsHorizontalScrollIndicator = NO;//隐藏水平滚动条
    self.timeArticleWebView.scrollView.bounces = NO;
    //整体自适应
    //[self.timeArticleWebView setScalesPageToFit:YES];

    UITapGestureRecognizer *backTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backing)];
    backTapGR.numberOfTapsRequired = 1;
    [self.timeArticleWebView.scrollView addGestureRecognizer:backTapGR];

    __block TimeArticleWebViewController *timeArticleWebVC = self;
    HTTPTool *tool = [[HTTPTool alloc] init];
    [tool requestTimeArticleDataByContentid:self.contentidStr];
    [tool requestTimeArticleByDateController:self InfoBlock:^(NSData *timeArticleData) {
        [timeArticleWebVC hideLoadingView];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:timeArticleData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDict = dict[@"data"];
        self.htmlStr = dataDict[@"html"];
        [self.timeArticleWebView loadHTMLString:self.htmlStr baseURL:nil];
    }];
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
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:0.5 animations:^{
            self.timeArticleWebView.frame = CGRectMake2(0, 0, WIDTH, HEIGHT);
        }];
    }
    else if ((_lastPosition - currentPostion > 5) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-5))
    {
        _lastPosition = currentPostion;
        //显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:0.5 animations:^{
            self.timeArticleWebView.frame = CGRectMake2(0, 0, WIDTH, HEIGHT-64);
        }];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //图片自适应
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = %d;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);",WIDTH-15]];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //获取webview内容的高度
//    self.height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    //CGRect frame = webView.frame;
//    //webView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _height);
//    NSLog(@"height=%lf",_height);
//    NSLog(@"s=%lf",self.timeArticleWebView.scrollView.contentSize.height);

    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    //背景色
    //日夜间模式
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
    }
    else
    {
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#333333'"];
        webView.scrollView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        webView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    
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

//日夜模式切换
-(void)dayOrNight
{
    //日夜间模式
    UIColor *color = [[UIColor alloc] init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        color = [UIColor whiteColor];
    }
    else
    {
        color = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    self.timeArticleWebView.backgroundColor = color;
    self.timeArticleWebView.scrollView.backgroundColor = color;
    self.view.backgroundColor = color;
    self.navigationController.navigationBar.barTintColor = color;
    //状态栏
    UIView *view = [[UIApplication sharedApplication].delegate window];
    view.backgroundColor = color;

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
