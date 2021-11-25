//
//  HomeViewController2.m
//  Mine
//
//  Created by lanou on 16/1/13.
//  Copyright © 2016年 9527. All rights reserved.
//

#import "HomeViewController2.h"
#import "HomeCollectionViewCell.h"
#import "HomeCVFlowLayout.h"
#import "HomeModel2.h"
//时间转化工具
#import "StringFromDate.h"
#import "ArticleViewController.h"
//开场动画后转换根视图
#import "ImageSayCollViewController.h"
#import "RadioViewController.h"
#import "TimeViewController.h"
#import "AppDelegate.h"
//长按图片保存
#import "SDWebImageManager.h"


@interface HomeViewController2 ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)UICollectionView *homeCV;
@property(nonatomic,retain)HomeModel2 *home2;
//点击首页图文进入文章手势
@property(nonatomic,retain)UITapGestureRecognizer *articleTapGR;
//向上清扫进入文字手势
@property(nonatomic,retain)UISwipeGestureRecognizer *articleSwipe;
//网络判断或加载判断 若data为空即没有网络
@property(nonatomic,retain)NSData *data;
//集合 重复数据判断
@property(nonatomic,retain)NSMutableSet *homeModelSet;
//保存home2Model的数组
@property(nonatomic,retain)NSMutableArray *homeModelArray;
//上次滑动的位置
@property(nonatomic,assign) NSInteger lastPosition;
//根据日期请求网络
@property(nonatomic,assign)NSInteger date;
@property(nonatomic,strong)NSMutableArray *dateArray;
@property(nonatomic,strong)NSMutableSet *dateSet;

@property(nonatomic,retain)HomeCollectionViewCell *cell;
@property(nonatomic,retain)HomeCVFlowLayout *layout;
//根据日期请求文章
@property(nonatomic,assign)int articleDate;
//长按图片图片保存
@property(nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation HomeViewController2

-(void)viewWillAppear:(BOOL)animated
{
    //日夜间模式
    [self dayOrNight];
    //宽窄模式切换
    [self bigOrSmall];
    if (!self.home2 && [[[HTTPTool alloc] init] isNetWork]) {
        [self hideLoadingView];
        [self homeContentHttpRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //重新指定根视图
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:self];
    homeNC.tabBarItem.title = @"Say";
    ImageSayCollViewController *imageSayCVC = [[ImageSayCollViewController alloc] init];
    UINavigationController *imageSayCNC = [[UINavigationController alloc] initWithRootViewController:imageSayCVC];
    imageSayCNC.tabBarItem.title = @"Image";
    RadioViewController *radioVC = [[RadioViewController alloc] init];
    UINavigationController *radioNC = [[UINavigationController alloc] initWithRootViewController:radioVC];
    radioNC.tabBarItem.title = @"Radio";
    TimeViewController *timeVC = [[TimeViewController alloc] init];
    UINavigationController *timeNC = [[UINavigationController alloc] initWithRootViewController:timeVC];
    timeNC.tabBarItem.title = @"Time";
    //统一设置导航栏颜色和透明
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1]];
    }
    else
    {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:70/255.0 alpha:1]];
    }
    [[UINavigationBar appearance] setTranslucent:NO];
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    tabbarController.viewControllers = [NSArray arrayWithObjects:homeNC,timeNC,imageSayCNC,radioNC, nil];
    //隐藏tabbar顶部黑线
    [tabbarController.tabBar setBackgroundImage:[[UIImage alloc] init]];
    [tabbarController.tabBar setShadowImage:[[UIImage alloc] init]];
    //设置tabbar选中背景色
    //tabbarController.tabBar.tintColor = [UIColor clearColor];
    //设置侧滑栏
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.view2 = tabbarController;//把tabbarController添加到View2上
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *app2 = app.delegate;
    app2.window.rootViewController = settingVC;
    
    //数组集合初始化
    self.homeModelSet = [NSMutableSet set];
    self.homeModelArray = [NSMutableArray array];
    //控件初始化
    self.layout = [[HomeCVFlowLayout alloc] init];
    self.homeCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH*SCALE_X, HH) collectionViewLayout:self.layout];
    _homeCV.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    _homeCV.showsHorizontalScrollIndicator = NO;
    _homeCV.showsVerticalScrollIndicator = NO;
    self.homeCV.delegate = self;
    self.homeCV.dataSource = self;
    [self.view addSubview:_homeCV];
    [self.homeCV registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    
    //网络请求
    self.articleDate = 0;//根据日期请求文章
    self.date = 0;
    [self homeContentHttpRequest];
    
    //加载刷新
    self.homeCV.mj_footer = [My_MJRefreshNormalRighter footerWithRefreshingBlock:^{
        if ([[[HTTPTool alloc] init] isNetWork]) {
            self.date += 1;
            [self homeContentHttpRequest];
        }
        else
        {
            [self.homeCV.mj_footer endRefreshing];
            //NSLog(@"播放/暂停");
        }
    }];
    
    //日夜模式切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayOrNight) name:@"dayAndNight" object:nil];
    //宽窄屏切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bigOrSmall) name:@"bigAndSmall" object:nil];
}
//网络请求
//首页图片+文字
-(void)homeContentHttpRequest
{
    __block HomeViewController2 *homeVC = self;
    //网络请求
    HTTPTool *tool = [[HTTPTool alloc] init];
    [tool requestDataByTime:[StringFromDate stringFromDateBeforeToday:self.date]];
    [tool requestHomeContentByDateController:self InfoBlock:^(NSData *data) {
        
        [homeVC hideLoadingView];
        
        if (data) {
            //如果请求的数据不为空
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *hpEntityDict = dict[@"hpEntity"];
            self.home2 = [HomeModel2 homeModel2WithDictionary:hpEntityDict];
            if (![self.homeModelSet containsObject:self.home2.strMarketTime]) {
                [self.homeModelArray addObject:self.home2];
                [self.homeModelSet addObject:self.home2.strMarketTime];
            }
            [self performSelectorOnMainThread:@selector(backToMainThread) withObject:nil waitUntilDone:NO];
        }else{}
    }];
}
//CELL的数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.homeModelArray.count;
}
//CELL视图
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    self.home2 = self.homeModelArray[indexPath.row];
    [self.cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.home2.strThumbnailUrl] placeholderImage:[UIImage imageNamed:@"bg2.jpg"]];
    [self.cell configureWithHome2:self.home2];
    
    //长按图片触发保存手势
    UILongPressGestureRecognizer *longPGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageAction1:)];
    longPGR.minimumPressDuration = 1;
    self.cell.imageV.userInteractionEnabled = YES;
    [self.cell.imageV addGestureRecognizer:longPGR];

    
    //日夜间模式
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        self.cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.cell.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
    }
    //宽窄屏圆直角切换
    [self bigOrSmall];
    return self.cell;
}
-(void)saveImageAction1:(UILongPressGestureRecognizer *)LPGR
{
    if (LPGR.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [LPGR locationInView:self.homeCV];
        NSIndexPath *indexPath = [self.homeCV indexPathForItemAtPoint:point];
        if (indexPath == nil) return;
        //NSLog(@"长按了%ld",indexPath.row);
        self.indexPath = indexPath;
        //长按保存图片菜单
        [self saveImageAction2];
    }
}
//保存图片
- (void)saveImageAction2{
    
    /**
     *  将图片保存到iPhone本地相册
     *  UIImage *image            图片对象
     *  id completionTarget       响应方法对象
     *  SEL completionSelector    方法
     *  void *contextInfo
     */
    NSLog(@"长按%ld",self.indexPath.row);
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"(=・ω・=)" message:@"保存图片" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //取消保存
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //下载图片
        self.home2= self.homeModelArray[self.indexPath.row];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.home2.strThumbnailUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //处理下载进度
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //图片下载完成在这里进行相关操作，如加到数组或者显示到imageview上
            //保存图片
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:confirmAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"O(∩_∩)O" message:@"已保存到相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"(°□°；)" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
    }
}

//CELL的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽窄屏切换
    int xxx = (int)XX;
    int xxx2 = (int)(15*SCALE_X);
    if (xxx == xxx2) {
        return CGSizeMake((WIDTH-30)*SCALE_X, HH-28);
    }
    else
    {
        return CGSizeMake(WIDTH*SCALE_X, HH-28);
    }
}
//CELL点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleViewController *articleVC = [[ArticleViewController alloc] init];
    articleVC.day = self.articleDate;
    UINavigationController *articleNC = [[UINavigationController alloc] initWithRootViewController:articleVC];
    [self presentViewController:articleNC animated:YES completion:nil];
}
-(void)backToMainThread
{
    [self.homeCV.mj_footer endRefreshing];
    [self.homeCV reloadData];
}
//根据日期请求文章
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.articleDate = scrollView.contentOffset.x/(WIDTH*SCALE_X);
    //NSLog(@"%d",_articleDate);
    
    //通知收起侧滑栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSlider" object:nil userInfo:nil];
}
//日夜模式切换
-(void)dayOrNight
{
    //日夜间模式
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        self.homeCV.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        //self.homeCV.backgroundColor = [UIColor orangeColor];
        self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        
        self.cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.homeCV.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:70/255.0 alpha:0.5];
        self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:70/255.0 alpha:1.0];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:70/255.0 alpha:1];
        
        self.cell.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
    }
}
//宽窄屏切换
-(void)bigOrSmall
{
    [UIView animateWithDuration:1.0 animations:^{
        self.homeCV.frame = CGRectMake(0, 0, WIDTH*SCALE_X, HH);
        //宽窄屏圆直角切换
        int xxx = (int)XX;
        int xxx2 = (int)(15*SCALE_X);
        if (xxx == xxx2) {
            self.cell.layer.cornerRadius = 5;
        }
        else
        {
            self.cell.layer.cornerRadius = 0;
        }
        self.cell.layer.masksToBounds = YES;
    }];
    [self.layout bigOrSmall];
    [self.cell reloadBigAndSmallView];
    
    self.tabBarController.tabBar.hidden = NO;

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
