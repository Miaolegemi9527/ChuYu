//
//  ImageSayCollViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "ImageSayCollViewController.h"
#import "ImageSayCollectionViewCell.h"
#import "ImageSayModel.h"
#import "ImageSayTableViewController.h"
//长按图片保存
#import "SDWebImageManager.h"
//image瀑布流
#import "ItemCell.h"
#import "CHTCollectionViewWaterfallLayout.h"

//设置每一个小方块(item)的大小 代理 1签协议UICollectionViewDelegateFlowLayout
@interface ImageSayCollViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)CHTCollectionViewWaterfallLayout *layout;
@property(nonatomic,retain)UICollectionView *collectionView;
@property(nonatomic,retain)NSMutableArray *imageSayArray;
@property(nonatomic,retain)ImageSayModel *imageSay;

//上拉刷新
@property(nonatomic,assign)NSInteger albumidOffset;
//下拉刷新
@property(nonatomic,assign)BOOL isPullToRefresh;
//上次滑动的位置
@property(nonatomic,assign) NSInteger lastPosition;
//图片的高度
@property(nonatomic,assign) CGFloat hehe;

@property(nonatomic,assign) BOOL isOnce;
@property(nonatomic,strong) NSMutableSet *set;
//长按图片图片保存
@property(nonatomic,strong)NSIndexPath *indexPath;
//切换显示列数
@property(nonatomic,assign)NSInteger rowNumber;
@property(nonatomic,assign)UIInterfaceOrientation orientation;

@end

@implementation ImageSayCollViewController

-(void)viewWillAppear:(BOOL)animated
{
    //日夜模式切换
    [self dayOrNight];
    //宽窄屏切换
    [self bigOrSmall];
    
    if (!self.imageSay && [[[HTTPTool alloc] init] isNetWork]) {
        [self hideLoadingView];
        [self imageSayHttpRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hehe = 175*SCALE_X;
    self.set = [NSMutableSet set];
    
//    UILabel *itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(50, 0, 100, 30)];
//    itemTitleLabel.text = @"Image";
//    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
//    itemTitleLabel.textColor = [UIColor grayColor];
//    itemTitleLabel.font = [UIFont systemFontOfSize:18];
//    self.navigationItem.titleView = itemTitleLabel;
    
    //切换显示列数
    self.rowNumber = 1;
    //控件初始化
    //创建布局类Layout
    self.layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    _layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    _layout.headerHeight = 0;
    _layout.footerHeight = 0;
    _layout.minimumColumnSpacing = 10;//列间距
    _layout.minimumInteritemSpacing = 20;//行间距
    
    //容器视图 瀑布流
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(XX, 0, WW, HH) collectionViewLayout:_layout];
    //背景色
    _collectionView.backgroundColor = [UIColor colorWithRed:254/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:_collectionView];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册cell collection的cell必须注册，不然会崩溃
    //[_collectionView registerClass:[ImageSayCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 下拉刷新进入刷新状态后会自动调用这个block
        //self.albumidOffset = 0;
        if ([[[HTTPTool alloc] init] isNetWork])
        {
            self.isPullToRefresh = YES;
            [self imageSayHttpRequest];
        }
        else
        {
            [self.collectionView.mj_header endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
    //上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载进入加载状态后会自动调用这个block
        if ([[[HTTPTool alloc] init] isNetWork])
        {
            self.albumidOffset += 10;
            self.isPullToRefresh = NO;
            [self imageSayHttpRequest];
        }
        else
        {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];

    //可变数组初始化
    self.imageSayArray = [NSMutableArray array];
    //刷新赋初值
    self.albumidOffset = 0;
    //网络请求数据
    [self imageSayHttpRequest];
    
    //日夜模式切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayOrNight) name:@"dayAndNight" object:nil];
    //宽窄屏切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bigOrSmall) name:@"bigAndSmall" object:nil];
    //双击手势切换显示列数
    UITapGestureRecognizer *changRowNumberTGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRowAction)];
    changRowNumberTGR.numberOfTapsRequired = 2;
    [self.collectionView addGestureRecognizer:changRowNumberTGR];
    
}
//切换显示的列数
-(void)changeRowAction{
    if (self.rowNumber == 1) {
        self.rowNumber = 2;
    }else{
        self.rowNumber = 1;
    }
    [self updateLayoutForOrientation:self.orientation];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.imageSayArray.count > 0) {
        [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
    
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}
- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    self.layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    self.layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? self.rowNumber : self.rowNumber;
}

//网络请求数据
-(void)imageSayHttpRequest
{
    __block ImageSayCollViewController *imageSayCVC = self;
    HTTPTool *tool = [[HTTPTool alloc] init];
    if (self.isPullToRefresh == YES) {
        [tool requestDataByalbumIdOffset:0];
    }
    else
    {
        [tool requestDataByalbumIdOffset:self.albumidOffset];
    }
    [tool requestImageSayByDateController:self InfoBlock:^(NSData *data)
    {
        if (data) {
            [imageSayCVC hideLoadingView];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dataDictionary = dict[@"data"];
            NSArray *albumArray = dataDictionary[@"album"];
            for (NSDictionary *dict2 in albumArray) {
                self.imageSay = [ImageSayModel imageSayWithDictionary:dict2];
                if (![self.set containsObject:self.imageSay.titleString]) {
                    [self.set addObject:self.imageSay.titleString];
                    [self.imageSayArray addObject:self.imageSay];
                }
            }
        }
        else
        {
            
        }
    //会主线程更新UI界面 赋值
    [self performSelectorOnMainThread:@selector(backToMainThread) withObject:nil waitUntilDone:NO];
    }];
}

-(void)backToMainThread
{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView reloadData];
}
//返回小方块item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageSayArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //只能自己自定义cell cell必须注册
    //ImageSayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    ItemCell *cell = (ItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    if (indexPath.row < self.imageSayArray.count) {
        self.imageSay = self.imageSayArray[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageSay.imgString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                if (!CGSizeEqualToSize(self.imageSay.imageSize, image.size)) {
                    self.imageSay.imageSize = image.size;
                    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            }
        }];
        cell.label.text = self.imageSay.titleString;
        cell.label.numberOfLines = 1;
        //[cell.label sizeToFit];
        cell.label.textAlignment = NSTextAlignmentCenter;
        cell.label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        cell.label.textColor = [UIColor grayColor];
        cell.label.font = [UIFont boldSystemFontOfSize:12];
        
        //添加长按图片手势
        UILongPressGestureRecognizer *longPGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageAction1:)];
        longPGR.minimumPressDuration = 1;
        cell.imageView.userInteractionEnabled = YES;
        [cell.imageView addGestureRecognizer:longPGR];
    }
    

    
    return cell;
}
//长按图片保存
-(void)saveImageAction1:(UILongPressGestureRecognizer *)LPGR
{
    if (LPGR.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [LPGR locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
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
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.imageSay.imgString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
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


//设置每一个小方块(item)的大小 代理 1签协议UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    self.imageSay = [self.imageSayArray objectAtIndex:indexPath.row];
//    if (!CGSizeEqualToSize(self.imageSay.imageSize, CGSizeZero)) {
//        return self.imageSay.imageSize;
//    }
//    return CGSizeMake(150, 200);
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.imageSayArray.count) {
        self.imageSay = self.imageSayArray[indexPath.row];
        if (CGSizeEqualToSize(self.imageSay.imageSize, CGSizeZero)) {
            return self.imageSay.imageSize;
        }
        CGFloat height0 = [self getLabelHeightWithLength:(WIDTH-60)*SCALE_X wordSize:14 content:_imageSay.titleString];
        CGFloat height = [self getLabelHeightWithLength:(WIDTH-60)*SCALE_X wordSize:12 content:_imageSay.introString];
        [self getImageHeightWithImage:self.imageSay.imgString];
        return CGSizeMake((WIDTH-60)*SCALE_X, height0+height+self.hehe+35*SCALE_Y);
    }
    return CGSizeMake(0, 0);
    
}
//分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.imageSayArray.count > 0) {
        return 1;
    }
    return 0;
}
//点击执行的方法 小方块点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageSayTableViewController *imageSayTVC = [[ImageSayTableViewController alloc] init];
    self.imageSay = self.imageSayArray[indexPath.row];
    imageSayTVC.albumID = _imageSay.albumId;
//    NSLog(@"第%d分区，第%d个",indexPath.section,indexPath.row);
    //模态跳转
     UINavigationController *imageSayNC = [[UINavigationController alloc] initWithRootViewController:imageSayTVC];
    imageSayTVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imageSayNC animated:YES completion:^{
    }];
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
        if (image) {
            CGSize size = image.size;
            float w = (WIDTH - 60)*SCALE_X;
            h = w*size.height/size.width;
        }
    }];
    self.hehe = h;
}
//判断滑动方向
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    //上拉
    if (currentPostion - _lastPosition > 5  && currentPostion > 0 && !self.imageSayArray.count == 0) {
        _lastPosition = currentPostion;
        //隐藏tabbar
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.tabBarController.tabBar.hidden = YES;
        [self prefersStatusBarHidden];
        [UIView animateWithDuration:0.5 animations:^{
            self.collectionView.frame = CGRectMake(XX, 0, WW, HEIGHT*SCALE_Y);
            self.collectionView.layer.cornerRadius = 0;
            self.collectionView.layer.masksToBounds = YES;
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
            self.collectionView.frame = CGRectMake(XX, 0, WW, HH);
            int xxx = (int)XX;
            int xxx2 = (int)(15*SCALE_X);
            if (xxx == xxx2) {
                self.collectionView.layer.cornerRadius = 5;
            }
            else
            {
                self.collectionView.layer.cornerRadius = 0;
            }
            self.collectionView.layer.masksToBounds = YES;
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
        _collectionView.backgroundColor = [UIColor whiteColor];
        color = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    }
    else
    {
        _collectionView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
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
        self.collectionView.frame = CGRectMake(XX, 0, WW, HH);
        //宽窄屏圆直角切换
        int xxx = (int)XX;
        int xxx2 = (int)(15*SCALE_X);
        if (xxx == xxx2) {
            self.collectionView.layer.cornerRadius = 5;
        }
        else
        {
            self.collectionView.layer.cornerRadius = 0;
        }
        self.collectionView.layer.masksToBounds = YES;
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
