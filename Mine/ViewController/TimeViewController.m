//
//  TimeViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "TimeViewController.h"
#import "TimeModel.h"
#import "TimeCollectionViewCell.h"
#import "TimeTableViewController.h"

@interface TimeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)UICollectionViewFlowLayout *layout;
@property(nonatomic,retain)UICollectionView *timeCollectionView;
@property(nonatomic,retain)TimeModel *time;
@property(nonatomic,retain)NSMutableArray *timeArray;
//避免重复
@property(nonatomic,strong)NSMutableSet *timeSet;
//上次滑动的位置
@property(nonatomic,assign) NSInteger lastPosition;
//日夜模式
@property(nonatomic,retain)TimeCollectionViewCell *cell;


@end

@implementation TimeViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    //日夜模式切换
    [self dayOrNight];
    //宽窄屏切换
    [self bigOrSmall];
    
    if (!self.time && [[[HTTPTool alloc] init] isNetWork]) {
        [self hideLoadingView];
        [self TimeHttpRequest];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UILabel *itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(50, 0, 100, 30)];
//    itemTitleLabel.text = @"Time";
//    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
//    itemTitleLabel.textColor = [UIColor grayColor];
//    itemTitleLabel.font = [UIFont systemFontOfSize:18];
//    self.navigationItem.titleView = itemTitleLabel;
    
    //数组初始化
    self.timeArray = [NSMutableArray array];
    
    self.timeSet = [NSMutableSet set];
    //控件初始化
    [self setUpTimeView];
    //网络请求
    [self TimeHttpRequest];
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 下拉刷新进入刷新状态后会自动调用这个block
        if ([[[HTTPTool alloc] init] isNetWork] && self.timeArray.count == 0) {
            [self TimeHttpRequest];
        }
        else
        {
            [self.timeCollectionView.mj_header endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.timeCollectionView.mj_header = header;
    
    //日夜模式切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayOrNight) name:@"dayAndNight" object:nil];
    //宽窄屏切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bigOrSmall) name:@"bigAndSmall" object:nil];

}
-(void)setUpTimeView
{
    //控件初始化
    //创建布局类Layout
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    //设置最小行间距
    _layout.minimumLineSpacing = 5*SCALE_Y;
    //设置最小列间距
    //_layout.minimumInteritemSpacing = 5;
    //设置垂直滚动
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置距离屏幕上左下右多少
    _layout.sectionInset = UIEdgeInsetsMake(0, 10*SCALE_X, 0, 10*SCALE_X);
    
    self.timeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(XX, 0, WW, HH) collectionViewLayout:_layout];
    //日夜间模式
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        _timeCollectionView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        _timeCollectionView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    
    _timeCollectionView.showsVerticalScrollIndicator = NO;
    _timeCollectionView.dataSource = self;
    _timeCollectionView.delegate = self;
    [self.timeCollectionView registerClass:[TimeCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    [self.view addSubview:self.timeCollectionView];


}
//网络解析
-(void)TimeHttpRequest
{
    __block TimeViewController *timeTVC = self;
    HTTPTool *tool = [[HTTPTool alloc] init];
    [tool requestTimeByDateController:self InfoBlock:^(NSData *TimeData) {
        
        if (TimeData) {
            [timeTVC hideLoadingView];
            //[timeTVC.timeCollectionView reloadData];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:TimeData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDictionary = dict[@"data"];
            NSArray *listArray = dataDictionary[@"list"];
            for (NSDictionary *dict2 in listArray) {
                self.time = [TimeModel timeModelWithDictionary:dict2];
                
                if (![self.timeSet containsObject:self.time.ennameStr]) {
                    [self.timeArray addObject:_time];
                    [self.timeSet addObject:self.time.ennameStr];
                }
                
                
            }
            [self performSelectorOnMainThread:@selector(backToMainThread) withObject:nil waitUntilDone:NO];
        }
        else
        {
            
        }
    }];
    
}
-(void)backToMainThread
{
    [self.timeCollectionView.mj_header endRefreshing];
    [self.timeCollectionView reloadData];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    [_cell configureTimeTabelCellWithTimeModel:self.timeArray[indexPath.row]];
    //cell.backgroundColor = [UIColor orangeColor];
    _cell.center = CGPointMake(self.timeCollectionView.center.x-XX, _cell.center.y);
    //NSLog(@"cell.h=%lf",cell.h);
    return _cell;
    
}
//返回小方块item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.timeArray.count;
}
//设置每一个小方块(item)的大小 代理 1签协议
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200*SCALE_X, 170*SCALE_Y);
}
//点击执行的方法 小方块点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.time = self.timeArray[indexPath.row];
    TimeTableViewController *timeTVC = [[TimeTableViewController alloc] init];
    timeTVC.type = _time.type;
    timeTVC.enTitleStr = _time.ennameStr;
    UINavigationController *timeTNC = [[UINavigationController alloc] initWithRootViewController:timeTVC];
    [self presentViewController:timeTNC animated:YES completion:^{
    }];
}
//判断滑动方向
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    //上拉
    if (currentPostion - _lastPosition > 5  && currentPostion > 0) {
        _lastPosition = currentPostion;
        
        //隐藏tabbar
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.tabBarController.tabBar.hidden = YES;
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:0.5 animations:^{
            self.timeCollectionView.frame = CGRectMake(XX, 0, WW, HEIGHT*SCALE_Y);
            //上拉去掉倒角
            self.timeCollectionView.layer.cornerRadius = 0;
            self.timeCollectionView.layer.masksToBounds = YES;
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
            self.timeCollectionView.frame = CGRectMake(XX, 0, WW, HH);
            int xxx = (int)XX;
            int xxx2 = (int)(15*SCALE_X);
            if (xxx == xxx2) {
                self.timeCollectionView.layer.cornerRadius = 5;
            }
            else
            {
                self.timeCollectionView.layer.cornerRadius = 0;
            }
            self.timeCollectionView.layer.masksToBounds = YES;
        }];
    }
    
    //通知收起侧滑栏
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSlider" object:nil userInfo:nil];
    
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
        _timeCollectionView.backgroundColor = [UIColor whiteColor];
        color = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    }
    else
    {
        _timeCollectionView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
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
        self.timeCollectionView.frame = CGRectMake(XX, 0, WW, HH);
        //宽窄屏圆直角切换
        int xxx = (int)XX;
        int xxx2 = (int)(15*SCALE_X);
        if (xxx == xxx2) {
            self.timeCollectionView.layer.cornerRadius = 5;
        }
        else
        {
            self.timeCollectionView.layer.cornerRadius = 0;
        }
        self.timeCollectionView.layer.masksToBounds = YES;
    }];
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
