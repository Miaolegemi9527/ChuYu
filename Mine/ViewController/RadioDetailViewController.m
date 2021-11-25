//
//  RadioDetailViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioDetailModel.h"
#import "RadioDetailTableViewCell.h"
#import "RadioPlayViewController.h"


@interface RadioDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)RadioDetailModel *radioDetail;
@property(nonatomic,retain)NSMutableArray *radioDetailArray;
@property(nonatomic,retain)NSMutableSet *radioDetailSet;
@property(nonatomic,retain)UITableView *radioDetailTableView;
@property(nonatomic,assign)NSInteger radioDetailStart;
//下拉刷新
@property(nonatomic,assign)BOOL isUpToRefresh;
//背景
@property(nonatomic,retain)UIImageView *bgView;
//上次滑动的位置 滑动隐藏状态栏
@property(nonatomic,assign) NSInteger lastPosition;
//背景毛玻璃效果
@property(nonatomic,retain)UIVisualEffectView *effectView;

@end

@implementation RadioDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    //日夜模式切换
    [self dayOrNight];
    //宽窄屏切换
    [self bigOrSmall];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航栏
    //self.navigationController.navigationBarHidden = YES;
    //标题
//    UILabel *itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(50, 0, 100, 30)];
//    itemTitleLabel.text = @"Radio";
//    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
//    itemTitleLabel.textColor = [UIColor grayColor];
//    itemTitleLabel.font = [UIFont systemFontOfSize:18];
//    self.navigationItem.titleView = itemTitleLabel;
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
    
    //初始化
    self.radioDetailArray = [NSMutableArray array];
    self.radioDetailSet = [NSMutableSet set];
    //控件初始化
    [self setUpRadioDetailView];
    //网络请求
    [self radioDetailHttpRequest];
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 下拉刷新进入刷新状态后会自动调用这个block
        if ([[[HTTPTool alloc] init]isNetWork]) {
            self.isUpToRefresh = NO;
            [self radioDetailHttpRequest];
        }
        else
        {
            [self.radioDetailTableView.mj_header endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.radioDetailTableView.mj_header = header;
    //上拉加载
    self.radioDetailTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载进入加载状态后会自动调用这个block
        if ([[[HTTPTool alloc] init]isNetWork]) {
            self.isUpToRefresh = YES;
            self.radioDetailStart += 10;
            [self radioDetailHttpRequest];
        }
        else
        {
            [self.radioDetailTableView.mj_footer endRefreshing];
        }
    }];
    
    //宽窄屏切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bigOrSmall) name:@"bigAndSmall" object:nil];
    
}
//控件初始化
-(void)setUpRadioDetailView
{
    self.radioDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(XX, 0, WW, HH) style:UITableViewStylePlain];
    _radioDetailTableView.dataSource = self;
    _radioDetailTableView.delegate = self;
    //去掉cell分割线
    _radioDetailTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //隐藏垂直指示条
    _radioDetailTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.radioDetailTableView];
    [self.radioDetailTableView registerClass:[RadioDetailTableViewCell class] forCellReuseIdentifier:@"CELL"];
    //背景
    self.bgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_bgView sd_setImageWithURL:[NSURL URLWithString:self.coverimgStr]];
    self.radioDetailTableView.backgroundView = self.bgView;
    //毛玻璃效果
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _effectView.frame = CGRectMake1(0, 0, WIDTH, HH);
    //effectView.alpha = 0.95;
    [self.bgView addSubview:_effectView];
}
//网络请求 默认及下拉刷新
-(void)radioDetailHttpRequest
{
    __block RadioDetailViewController *radioVC = self;
    HTTPTool *tool = [[HTTPTool alloc] init];
    
    if (self.isUpToRefresh == NO) {
        [tool requestDataByRadioDetailStart:0];
    }
    else
    {
        [tool requestDataByRadioDetailStart:self.radioDetailStart];
    }
    [tool requestDataByRadioid:self.radioidStr];
    [tool requestRadioDetailViewByDateController:radioVC RadioDetailBlock:^(NSData *data)
    {
        
        if (data) {
            [radioVC hideLoadingView];
            //[radioVC.radioDetailTableView reloadData];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            NSArray *listArray = dataDict[@"list"];
            for (NSDictionary *listDict in listArray) {
                self.radioDetail = [RadioDetailModel radioDetailModelWithDictionary:listDict];
                if (![self.radioDetailSet containsObject:self.radioDetail.tingidStr]) {
                    [self.radioDetailArray addObject:self.radioDetail];
                    [self.radioDetailSet addObject:self.radioDetail.tingidStr];
                }
            }
            [self performSelectorOnMainThread:@selector(backToMainThread) withObject:nil waitUntilDone:NO];
        }
    }];
}
-(void)backToMainThread
{
    [self hideLoadingView];//移除转圈圈
    
    [self.radioDetailTableView.mj_header endRefreshing];
    [self.radioDetailTableView.mj_footer endRefreshing];
    [self.radioDetailTableView reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    [cell configureRadioDetailTableViewCellWithRadioDetailModel:self.radioDetailArray[indexPath.row]];
    //设置cell背景为透明 不然看不到背景图
    cell.backgroundColor = [UIColor clearColor];
    //设置点击cell背景效果为透明
    UIView *cellBGView = [[UIView alloc] initWithFrame:cell.bounds];
    cellBGView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = cellBGView;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.radioDetailArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80*SCALE_Y;
}
-(void)backing
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

//跳转页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioPlayViewController *radioVC = [[RadioPlayViewController alloc] init];
    radioVC.currentIndex = indexPath.row;
    
    radioVC.radioArray = self.radioDetailArray;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:radioVC];
    [self presentViewController:nav animated:YES completion:nil];
}

//判断滑动方向 隐藏导航栏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    //上拉
    if (currentPostion - _lastPosition > 5  && currentPostion > 0 && !self.radioDetailArray.count == 0) {
        _lastPosition = currentPostion;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:0.5 animations:^{
            self.radioDetailTableView.frame = CGRectMake(XX, 0, WW, HEIGHT*SCALE_Y);
            self.radioDetailTableView.layer.cornerRadius = 0;
            self.radioDetailTableView.layer.masksToBounds = YES;
        }];
    }
    else if ((_lastPosition - currentPostion > 5) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-5))
    {
        _lastPosition = currentPostion;
        //显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self prefersStatusBarHidden];

        [self bigOrSmall];
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

//日夜模式切换
-(void)dayOrNight
{
    //日夜间模式
    UIColor *color = [[UIColor alloc] init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        color = [UIColor whiteColor];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    else
    {
        color = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:70/255.0 alpha:1.0];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    }
    self.view.backgroundColor = color;
    self.radioDetailTableView.backgroundColor = color;
    _effectView.frame = CGRectMake1(0, 0, WIDTH, HEIGHT);
    [self.bgView addSubview:_effectView];
    self.navigationController.navigationBar.barTintColor = color;
    //状态栏
    UIView *view = [[UIApplication sharedApplication].delegate window];
    view.backgroundColor = color;
}
//宽窄屏切换
-(void)bigOrSmall
{
    //宽窄屏圆直角切换
    int xxx = (int)XX;
    int xxx2 = (int)(15*SCALE_X);
    if (xxx == xxx2) {
        //窄屏
        [UIView animateWithDuration:0.5 animations:^{
            self.radioDetailTableView.layer.cornerRadius = 5;
            self.radioDetailTableView.frame = CGRectMake(XX, 0, WW, HH);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.radioDetailTableView.layer.cornerRadius = 0;
            self.radioDetailTableView.frame = CGRectMake(0, 0, WIDTH*SCALE_X, (HEIGHT-58)*SCALE_Y);
        }];
        
    }
    self.radioDetailTableView.layer.masksToBounds = YES;
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
