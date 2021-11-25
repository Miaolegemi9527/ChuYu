//
//  TimeTableViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "TimeTableViewController.h"
#import "TimeTableViewCell2.h"
#import "TimeTableModel.h"
#import "TimeArticleWebViewController.h"
//下载图片
#import "SDWebImageManager.h"

@interface TimeTableViewController ()

@property(nonatomic,retain)TimeTableModel *time;
@property(nonatomic,retain)NSMutableArray *timeModelArray;
//上下拉刷新
@property(nonatomic,assign)NSInteger startNumber;
@property(nonatomic,assign)BOOL topRefresh;//是否下拉刷新
@property(nonatomic,strong)NSMutableSet *modelSet;//存放加载的数据（model），刷新时若存在则不添加（避免重复）
//上次滑动的位置 隐藏顶部导航栏和状态栏
@property(nonatomic,assign) NSInteger lastPosition;
//长按保存图片
@property(nonatomic,strong)NSIndexPath *indexPath;


@end

@implementation TimeTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    //日夜模式切换
    [self dayOrNight];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
    UILabel *itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(50, 0, 100, 30)];
    itemTitleLabel.text = self.enTitleStr;
    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
    itemTitleLabel.textColor = [UIColor grayColor];
    itemTitleLabel.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = itemTitleLabel;
    //self.navigationItem.title = self.enTitleStr;
    //返回
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
    //初始化数组
    self.timeModelArray = [NSMutableArray array];
    //初始化集合
    self.modelSet = [NSMutableSet set];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //cell分割线距离左边145  上左下右
    //[self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 145*SCALE_X, 0, 0)];
    [self.tableView registerClass:[TimeTableViewCell2 class] forCellReuseIdentifier:@"CELL"];
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([[[HTTPTool alloc] init] isNetWork]) {
            //self.startNumber = 0;
            self.topRefresh = YES;
            [self timeTabelViewHttpRequest];
        }
        else
        {
            [self.tableView.mj_header endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([[[HTTPTool alloc] init] isNetWork]) {
            self.startNumber += 10;
            self.topRefresh = NO;
            [self timeTabelViewHttpRequest];
        }
        else
        {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
    //网络请求
    self.startNumber = 0;
    [self timeTabelViewHttpRequest];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//网络请求
-(void)timeTabelViewHttpRequest
{
    __block TimeTableViewController *timeTVC = self;
    HTTPTool *tool = [[HTTPTool alloc] init];
    if (self.topRefresh == YES) {
        [tool requestTimeTabelDataByStart:0];
    }
    else
    {
        [tool requestTimeTabelDataByStart:self.startNumber];
    }
    [tool requestTimeTabelDataByType:self.type];
    [tool requestTimeTabelByDateController:self InfoBlock:^(NSData *timeTableData) {
        
        if (timeTableData) {
            [timeTVC hideLoadingView];
            //[timeTVC.tableView reloadData];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:timeTableData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDict = dict[@"data"];
            NSArray *listArray = dataDict[@"list"];
            for (NSDictionary *dict2 in listArray) {
                self.time = [TimeTableModel timeTableWithDictionary:dict2];
                //[self.timeModelArray addObject:_time];
                if (![self.modelSet containsObject:self.time.titleStr]) {
                    [self.modelSet addObject:self.time.titleStr];
                    [self.timeModelArray addObject:self.time];
                }
            }
            //回主线程更新UI界面 赋值
            [timeTVC performSelectorOnMainThread:@selector(backToMainThread) withObject:nil waitUntilDone:NO];
        }
        else
        {
            
        }
        
    }];
}
-(void)backToMainThread
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}
//返回
-(void)backing
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.timeModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimeTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    // Configure the cell...
    [cell configureTimeTabelCell2WithTimeTableModel:self.timeModelArray[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //日夜间模式切换
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    //添加长按图片手势
    UILongPressGestureRecognizer *longPGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageAction1:)];
    longPGR.minimumPressDuration = 1;
    cell.coverView.userInteractionEnabled = YES;
    [cell.coverView addGestureRecognizer:longPGR];
    return cell;
}
//长按图片保存
-(void)saveImageAction1:(UILongPressGestureRecognizer *)LPGR
{
    if (LPGR.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [LPGR locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
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
        self.time = self.timeModelArray[self.indexPath.row];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.time.coverimgStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.time = self.timeModelArray[indexPath.row];
    CGFloat height = [self getLabelHeightWithLength:(WIDTH-30)*SCALE_X wordSize:14 content:_time.titleStr];
    CGFloat height2 = [self getLabelHeightWithLength:(WIDTH-30)*SCALE_X wordSize:12 content:_time.contentStr];
    return (15+height+10+170+10+height2+35)*SCALE_Y;
}
//高度自适应算法
-(CGFloat)getLabelHeightWithLength:(CGFloat)length wordSize:(CGFloat)wordSize content:(NSString *)content
{
    CGSize size = CGSizeMake(length, 10000);
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:wordSize] forKey:NSFontAttributeName];
    
    CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}
//点击cell时间
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.time = self.timeModelArray[indexPath.row];
    TimeArticleWebViewController *timeArticleWebVC = [[TimeArticleWebViewController alloc] init];
    timeArticleWebVC.contentidStr = self.time.idStr;
    UINavigationController *timeArticleWebNC = [[UINavigationController alloc] initWithRootViewController:timeArticleWebVC];
    [self presentViewController:timeArticleWebNC animated:YES completion:^{
        
    }];
}

//判断滑动方向
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    //上拉
    if (currentPostion - _lastPosition > 5 && currentPostion > 0 && !self.timeModelArray.count == 0) {
        _lastPosition = currentPostion;
        //隐藏tabbar
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self prefersStatusBarHidden];
        //self.view.frame = CGRectMake(XX, 0, WW, HEIGHT*SCALE_Y);
    }
    else if ((_lastPosition - currentPostion > 5) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-5))
    {
        _lastPosition = currentPostion;
        //显示导航栏和tabbar
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self prefersStatusBarHidden];
        //self.view.frame = CGRectMake(XX, 0, WW, HH*SCALE_Y);
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
    }
    else
    {
        color = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    }
    self.view.backgroundColor = color;
    self.navigationController.navigationBar.barTintColor = color;
    //状态栏
    UIView *view = [[UIApplication sharedApplication].delegate window];
    view.backgroundColor = color;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
