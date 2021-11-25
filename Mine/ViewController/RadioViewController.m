//
//  RadioViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioModel.h"
#import "RadioCollectionViewCell.h"
#import "RadioDetailViewController.h"
#import "SettingViewController.h"


@interface RadioViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)UICollectionViewFlowLayout *layout;
@property(nonatomic,retain)UICollectionView *radioCollectionView;
@property(nonatomic,retain)RadioModel *radio;
@property(nonatomic,retain)NSMutableArray *radioArray;

//上次滑动的位置 滑动隐藏状态栏和Tab
@property(nonatomic,assign) NSInteger lastPosition;

//上拉刷新
@property(nonatomic,assign)NSInteger limitAndStart;
//下拉刷新
@property(nonatomic,strong)NSMutableSet *radioModelSet;//存放加载的数据（model），刷新时若存在则不添加（避免重复）

@end

@implementation RadioViewController

-(void)viewWillAppear:(BOOL)animated
{
    //日夜模式切换
    [self dayOrNight];
    //宽窄屏切换
    [self bigOrSmall];
    
    if (!self.radio && [[[HTTPTool alloc] init] isNetWork]) {
        [self hideLoadingView];
        [self radioHttpRequest];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UILabel *itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(50, 0, 100, 30)];
//    itemTitleLabel.text = @"Radio";
//    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
//    itemTitleLabel.textColor = [UIColor grayColor];
//    itemTitleLabel.font = [UIFont systemFontOfSize:18];
//    self.navigationItem.titleView = itemTitleLabel;
    
    //初始化
    self.radioArray = [NSMutableArray array];
    self.radioModelSet = [NSMutableSet set];
    //控件初始化
    [self setUpRadioView];
    //网络请求
    [self radioHttpRequest];
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 下拉刷新进入刷新状态后会自动调用这个block
        if ([[[HTTPTool alloc] init] isNetWork]) {
            //self.limitAndStart = 0;
            [self radioHttpRequest];
        }
        else
        {
            [self.radioCollectionView.mj_header endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.radioCollectionView.mj_header = header;
    //上拉加载
    self.radioCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载进入加载状态后会自动调用这个block
        if ([[[HTTPTool alloc] init] isNetWork]) {
            self.limitAndStart += 9;
            [self radioUpReloadHttpRequest];
        }
        else
        {
            [self.radioCollectionView.mj_footer endRefreshing];
        }
    }];
    
    //日夜模式切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayOrNight) name:@"dayAndNight" object:nil];
    //宽窄屏切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bigOrSmall) name:@"bigAndSmall" object:nil];
    
}
-(void)setUpRadioView
{
    //控件初始化
    //创建布局类Layout
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    //设置最小行间距
    _layout.minimumLineSpacing = 20;
    //设置最小列间距
    //_layout.minimumInteritemSpacing = 5;
    //设置垂直滚动
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置距离屏幕上左下右多少
    _layout.sectionInset = UIEdgeInsetsMake(0, 15*SCALE_X, 0, 15*SCALE_X);
    
    self.radioCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(XX, 0, WW, HH) collectionViewLayout:_layout];
    _radioCollectionView.backgroundColor = [UIColor whiteColor];
    _radioCollectionView.showsVerticalScrollIndicator = NO;
    _radioCollectionView.dataSource = self;
    _radioCollectionView.delegate = self;
    [self.radioCollectionView registerClass:[RadioCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    [self.view addSubview:self.radioCollectionView];
}
//网络请求 第一次加载及下拉刷新
-(void)radioHttpRequest
{
    __block RadioViewController *radioVC = self;
    HTTPTool *tool = [[HTTPTool alloc] init];
    [tool requestDataByLimitAndStart:0];
    [tool requestRadioListViewByDateController:radioVC RadioListBlock:^(NSData *data) {
        if (data) {
            [radioVC hideLoadingView];
//            [radioVC.radioCollectionView reloadData];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            NSArray *alllistArray = dataDict[@"alllist"];
            for (NSDictionary *alllistDict in alllistArray) {
                self.radio = [RadioModel radioModelAlllistWithDictionary:alllistDict];
                if (![self.radioModelSet containsObject:self.radio.alllistTitleStr]) {
                    [self.radioArray addObject:self.radio];
                    [self.radioModelSet addObject:self.radio.alllistTitleStr];
                }
            }
            [self performSelectorOnMainThread:@selector(backToMainThread) withObject:nil waitUntilDone:NO];
        }
        else
        {
            
        }
        
    }];
}
//网络请求 上拉刷新
-(void)radioUpReloadHttpRequest
{
    __block RadioViewController *radioVC = self;
    HTTPTool *tool = [[HTTPTool alloc] init];
    [tool requestDataByLimitAndStart:self.limitAndStart];
    [tool requestRadioListViewByDateController:radioVC RadioListBlock:^(NSData *data) {
        if (data) {
            [radioVC hideLoadingView];
            //[radioVC.radioCollectionView reloadData];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            NSArray *alllistArray = dataDict[@"list"];
            for (NSDictionary *alllistDict in alllistArray) {
                self.radio = [RadioModel radioModelAlllistWithDictionary:alllistDict];
                if (![self.radioModelSet containsObject:self.radio.alllistTitleStr]) {
                    [self.radioArray addObject:self.radio];
                    [self.radioModelSet addObject:self.radio.alllistTitleStr];
                }
            }
            [self performSelectorOnMainThread:@selector(backToMainThread) withObject:nil waitUntilDone:NO];
        }
    }];

}
-(void)backToMainThread
{
    [self.radioCollectionView.mj_header endRefreshing];
    [self.radioCollectionView.mj_footer endRefreshing];
    [self.radioCollectionView reloadData];
}
//返回cell的样式
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RadioCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    [cell configureRadioCollectionViewCell:self.radioArray[indexPath.row]];
    //cell.backgroundColor = [UIColor orangeColor];
    return cell;
}
//返回cell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.radioArray.count;
}
//设置每一个小方块(item)的大小 代理 1签协议UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIDTH-65)*SCALE_X, 160*SCALE_Y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//item的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.radio = self.radioArray[indexPath.row];
    RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc] init];
    //电台id
    radioDetailVC.radioidStr = self.radio.alllistRadioidStr;
    //电台封面
    radioDetailVC.coverimgStr = self.radio.alllistCoverimgStr;
    UINavigationController *radioDetailNC = [[UINavigationController alloc] initWithRootViewController:radioDetailVC];
    [self presentViewController:radioDetailNC animated:YES completion:^{
        
    }];
}
//判断滑动方向
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int currentPostion = scrollView.contentOffset.y;
    //上拉
    if (currentPostion - _lastPosition > 5  && currentPostion > 0 && !self.radioArray.count == 0) {
        _lastPosition = currentPostion;
        //隐藏tabbar
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.tabBarController.tabBar.hidden = YES;
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:0.5 animations:^{
            self.radioCollectionView.frame = CGRectMake(XX, 0, WW, HEIGHT*SCALE_Y);
            self.radioCollectionView.layer.cornerRadius = 0;
            self.radioCollectionView.layer.masksToBounds = YES;
        }];
    }
    else if ((_lastPosition - currentPostion > 5) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-5))
    {
        _lastPosition = currentPostion;
        //显示导航栏和tabbar
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.tabBarController.tabBar.hidden = NO;
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:0.5 animations:^{
            self.radioCollectionView.frame = CGRectMake(XX, 0, WW, HH);
            int xxx = (int)XX;
            int xxx2 = (int)(15*SCALE_X);
            if (xxx == xxx2) {
                self.radioCollectionView.layer.cornerRadius = 5;
            }
            else
            {
                self.radioCollectionView.layer.cornerRadius = 0;
            }
            self.radioCollectionView.layer.masksToBounds = YES;
        }];
    }
    //通知收起侧滑栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSlider" object:nil userInfo:nil];
}
//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    if (self.navigationController.navigationBarHidden == YES) {
        //NSLog(@"隐藏");
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
        _radioCollectionView.backgroundColor = [UIColor whiteColor];
        color = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    }
    else
    {
        _radioCollectionView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        color = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:70/255.0 alpha:1.0];
    }
    self.view.backgroundColor = color;
    self.navigationController.navigationBar.barTintColor = color;
    //状态栏
    UIView *view = [[UIApplication sharedApplication].delegate window];
    view.backgroundColor = color;

}
//宽窄屏切换
-(void)bigOrSmall
{
    [UIView animateWithDuration:1.0 animations:^{
        self.radioCollectionView.frame = CGRectMake(XX, 0, WW, HH);
        //宽窄屏圆直角切换
        int xxx = (int)XX;
        int xxx2 = (int)(15*SCALE_X);
        if (xxx == xxx2) {
            self.radioCollectionView.layer.cornerRadius = 5;
        }
        else
        {
            self.radioCollectionView.layer.cornerRadius = 0;
        }
        self.radioCollectionView.layer.masksToBounds = YES;
    }];
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
