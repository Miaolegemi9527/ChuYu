//
//  ImageSayTableViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "ImageSayTableViewController.h"
#import "ImageSayModel2.h"
#import "ImageSayTableViewCell.h"
//下载图片
#import "SDWebImageManager.h"

@interface ImageSayTableViewController ()

//双击返回手势
@property(nonatomic,retain)UITapGestureRecognizer *backTapGR;
//添加表头
@property(nonatomic,retain)UIView *headerView;
@property(nonatomic,retain)UIImageView *headerImageView;
@property(nonatomic,strong)NSString *imageSting;
@property(nonatomic,retain)UILabel *userNameLabel;
@property(nonatomic,strong)NSString *userNameString;

@property(nonatomic,retain)NSMutableArray *imageSayArray;
@property(nonatomic,retain)ImageSayModel2 *imageSay;
//当前滑动的位置
@property(nonatomic,assign) int lastPosition;
//图片高度
@property(nonatomic,assign) CGFloat hehe;
//长按保存图片
@property(nonatomic,strong)NSIndexPath *indexPath;


@end

@implementation ImageSayTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    //日夜模式切换
    [self dayOrNight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.hehe = 175*SCALE_Y;
    
//    UILabel *itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(50, 0, 100, 30)];
//    itemTitleLabel.text = @"Image";
//    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
//    itemTitleLabel.textColor = [UIColor grayColor];
//    itemTitleLabel.font = [UIFont systemFontOfSize:18];
//    self.navigationItem.titleView = itemTitleLabel;
    
    //返回
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
    
    //背景色
    self.view.backgroundColor = [UIColor colorWithRed:254/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    //双击返回手势
    self.backTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backing)];
    _backTapGR.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:_backTapGR];
    //self.tableView.showsVerticalScrollIndicator = NO;
    //self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 100, 50, 100);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //表头初始化
    [self setUpHeaderView];
    //注册
    [self.tableView registerClass:[ImageSayTableViewCell class] forCellReuseIdentifier:@"CELL"];
    //可变数组初始化
    self.imageSayArray = [NSMutableArray array];
    //网络请求数据
    [self imageSayHttpRequest];
    
}
//表头初始化
-(void)setUpHeaderView
{
    //添加表头
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake1(0, 0, WIDTH, 80)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake4(10, 20, 50, 50)];
    _headerImageView.layer.cornerRadius = 25*SCALE_Y;
    _headerImageView.layer.borderColor = [UIColor grayColor].CGColor;
    _headerImageView.layer.borderWidth = 1;
    _headerImageView.layer.masksToBounds = YES;
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake1(80, 35, WIDTH-90-10, 20)];
    _userNameLabel.center = CGPointMake(_userNameLabel.center.x, self.headerImageView.center.y);
    _userNameLabel.font = [UIFont systemFontOfSize:14];
    
    [_headerView addSubview:_headerImageView];
    [_headerView addSubview:_userNameLabel];
    self.tableView.tableHeaderView = _headerView;
}
//表头赋值
-(void)reloadHeaderView
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageSting] placeholderImage:[UIImage imageNamed:@"settingButton"]];
    self.userNameLabel.text = self.userNameString;
    
}
//网络请求数据
-(void)imageSayHttpRequest
{
    __block ImageSayTableViewController *imageSayTVC = self;
    HTTPTool *tool = [[HTTPTool alloc] init];
    [tool requestDataByalbumId:self.albumID];
    [tool requestImageSay2ByDateController:self InfoBlock:^(NSData *data) {
        
        if (data) {
            [imageSayTVC hideLoadingView];
            //[imageSayTVC.tableView reloadData];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDictionary = dict[@"data"];
            NSDictionary *albumDictionary = dataDictionary[@"album"];
            imageSayTVC.imageSting = albumDictionary[@"img"];
            imageSayTVC.userNameString = albumDictionary[@"userName"];
            //self.imageSay = [ImageSayModel2 imageSay2WithDictionary:albumDictionary];
            NSArray *postArray = dataDictionary[@"post"];
            for (NSDictionary *dict2 in postArray) {
                imageSayTVC.imageSay = [ImageSayModel2 imageSay2WithDictionary:dict2];
                [imageSayTVC.imageSayArray addObject:_imageSay];
            }
            //回主线程更新UI界面 赋值
            [imageSayTVC performSelectorOnMainThread:@selector(backToMainThread) withObject:nil waitUntilDone:NO];
            }
    }];
}
-(void)backToMainThread
{
    [self reloadHeaderView];
    [self.tableView reloadData];
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
    return [self.imageSayArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageSayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    self.imageSay = self.imageSayArray[indexPath.row];
    [cell configureImageSayCellWithImageSayModel:self.imageSay];
  
    [cell sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //日夜间模式
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
    cell.imageV.userInteractionEnabled = YES;
    [cell.imageV addGestureRecognizer:longPGR];
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
        self.imageSay = self.imageSayArray[self.indexPath.row];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.imageSay.bigUrlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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
    CGFloat height0 = [self getLabelHeightWithLength:(WIDTH-20)*SCALE_X wordSize:12 content:self.imageSay.tagsString];
    CGFloat height = [self getLabelHeightWithLength:(WIDTH-20)*SCALE_X wordSize:12 content:self.imageSay.postTextString];
    [self getImageHeightWithImage:self.imageSay.bigUrlString];
    return height0+35*SCALE_Y+height+self.hehe;
}
//自适应高度算法
-(CGFloat)getLabelHeightWithLength:(CGFloat)length wordSize:(CGFloat)wordSize content:(NSString *)content
{
    CGSize size = CGSizeMake(length, 100000);
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:wordSize] forKey:NSFontAttributeName];
    CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}
//图片高度
-(void)getImageHeightWithImage:(NSString *)string
{
    __block CGFloat h = self.hehe;
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:string]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGSize size = image.size;
        float w = (WIDTH - 20)*SCALE_X;
        h = w*size.height/size.width;
    }];
    self.hehe = h;
}
//返回
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
    if (currentPostion - _lastPosition > 5  && currentPostion > 0 && !self.imageSayArray.count == 0) {
        _lastPosition = currentPostion;
        //隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self prefersStatusBarHidden];
        self.tableView.frame = CGRectMake1(0, 0, WIDTH, HEIGHT);
    }
    else if ((_lastPosition - currentPostion > 5) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-5))
    {
        _lastPosition = currentPostion;
        //显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self prefersStatusBarHidden];
        self.tableView.frame = CGRectMake1(0, 64, WIDTH, HEIGHT);
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
    _headerView.backgroundColor = color;
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
