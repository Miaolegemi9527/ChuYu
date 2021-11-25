//
//  SettingViewController.m
//  Mine
//
//  Created by 廖毅 on 15/12/25.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "SettingViewController.h"
//文章
#import "ArticleViewController.h"
//电台
#import "RadioStreamer.h"
#import "RadioManager.h"

//重新指定跟视图
#import "AppDelegate.h"
#import "ImageSayCollViewController.h"
#import "RadioViewController.h"
#import "TimeViewController.h"
#import "HomeViewController2.h"
#import "RadioPlayViewController.h"


@interface SettingViewController ()<UIGestureRecognizerDelegate,RadioDelegate>

//设置界面
@property(nonatomic,retain)UIView *settingView;
//设置界面毛玻璃
@property(nonatomic,retain)UIVisualEffectView *effectView;
//免责声明
@property(nonatomic,retain)UIView *mianzeView;
@property(nonatomic,retain)UILabel *mianzeLabel;
@property(nonatomic,retain)UIImageView *mianzeImageView;
@property(nonatomic,retain)UIVisualEffectView *mianzeComeOutVisual;
//点击屏幕收起设置手势
@property(nonatomic,retain)UITapGestureRecognizer *hiddenSettingTapGR;
//右划屏幕手势拉出设置view
@property(nonatomic,retain)UISwipeGestureRecognizer *settingSwipeGR;
//左划屏幕手势收起设置view
@property(nonatomic,retain)UISwipeGestureRecognizer *hiddenSettingSwipeGR;
//homeviewcontroller设置按钮弹出及隐藏设置view事件
@property(nonatomic,assign)BOOL isSetting;
//文章
@property(nonatomic,retain)UIButton *articleButton;
//屏切 宽屏窄屏
@property(nonatomic,retain)UIButton *sizeButton;
@property(nonatomic,retain)UIButton *fullSizeButton;
@property(nonatomic,retain)UIButton *smallSizeButton;
//日夜间模式
@property(nonatomic,retain)UIButton *dayAndNightModelButton;
@property(nonatomic,retain)UIButton *dayModelButton;
@property(nonatomic,retain)UIButton *nightModelButton;
//清除缓存
@property(nonatomic,retain)UIButton *clearButton;
@property(nonatomic,retain)UIButton *clearSureButton;
@property(nonatomic,retain)UIButton *clearCancelButton;
@property(nonatomic,assign)float clearSize;
//免责声明
@property(nonatomic,retain)UIButton *mianzeButton;

//文字日夜模式背景颜色
@property(nonatomic,retain)UIColor *color;


//电台
@property(nonatomic,strong) RadioDetailModel *radio;
//播放
@property(nonatomic,retain)UIButton *playButton;
//歌曲图片
@property(nonatomic,strong) UIImageView *imageV;
//歌曲名称
@property(nonatomic,strong) UILabel *nameLabel;
//头像加颜色渐变效果
@property(nonatomic,strong)CAGradientLayer *gradientLayer;
@property(nonatomic,strong)NSTimer *timer;
//设置按钮
@property(nonatomic,retain)UIButton *settingButton;

@property(nonatomic,assign) NSInteger index;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //右边设置图标
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingButton.frame = CGRectMake(328*SCALE_X, 25, 32*SCALE_Y, 32*SCALE_Y);
    _settingButton.layer.cornerRadius = 16*SCALE_Y;
    _settingButton.layer.masksToBounds = YES;
    [_settingButton setImage:[UIImage imageNamed:@"settingButton"] forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(settingFromHomeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view2.view addSubview:_settingButton];
    
    [self addChildViewController:self.view2];
    //设置默认显示的页面 tabbarController在view2上、、、
    [self.view addSubview:self.view2.view];
    //设置弹出/隐藏view手势
    self.settingSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setting:)];
    _settingSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_settingSwipeGR];
    self.hiddenSettingSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(settingViewHidden)];
    _hiddenSettingSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:_hiddenSettingSwipeGR];
    
    
    //日夜模式切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayOrNight) name:@"dayAndNight" object:nil];
    //收起侧滑栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingViewHidden) name:@"leftSlider" object:nil];
    
    
}
//设置界面控件初始化
-(void)setUpSettingView
{
    self.settingView = [[UIView alloc] initWithFrame:CGRectMake1(-WIDTH/2-1, 0, WIDTH/2, HEIGHT)];
    _settingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_settingView];
    
    //添加点击收起屏切和日夜间模式按钮手势
    UITapGestureRecognizer *pickUpButtonTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickUpButtonAction)];
    pickUpButtonTapGR.numberOfTapsRequired = 1;
    [_settingView addGestureRecognizer:pickUpButtonTapGR];
    
    
    //毛玻璃效果
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];

    _effectView.frame = CGRectMake1(0, 0, WIDTH/2, HEIGHT);
    [self.settingView addSubview:_effectView];
    //图
    UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake6(((WIDTH/2)-80)/2, 80, 80, 80)];
    coverImageView.image = [UIImage imageNamed:@"holder"];
    coverImageView.layer.cornerRadius = 40*SCALE_Y;
    coverImageView.layer.masksToBounds = YES;
    coverImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    coverImageView.layer.borderWidth = 1;
    [self.settingView addSubview:coverImageView];
    //文章
    self.articleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _articleButton.frame = CGRectMake6((WIDTH/2-50)/2, 180, 50, 50);
    [_articleButton setTitle:@"文章" forState:UIControlStateNormal];
    _articleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_articleButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    _articleButton.layer.cornerRadius = 25*SCALE_Y;
    _articleButton.layer.masksToBounds = YES;
    _articleButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _articleButton.layer.borderWidth = 1;
    [self.settingView addSubview:_articleButton];
    [_articleButton addTarget:self action:@selector(articling) forControlEvents:UIControlEventTouchUpInside];
    _articleButton.showsTouchWhenHighlighted = YES;
    //宽屏
    self.fullSizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _fullSizeButton.frame = CGRectMake6((WIDTH/2-40)/2, 250, 40, 40);
    [_fullSizeButton setTitle:@"宽屏" forState:UIControlStateNormal];
    _fullSizeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_fullSizeButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    [_fullSizeButton setTitleColor:[UIColor colorWithRed:227/255.0 green:56/255.0 blue:43/255.0 alpha:1] forState:UIControlStateSelected];
    _fullSizeButton.layer.cornerRadius = 20*SCALE_Y;
    _fullSizeButton.layer.masksToBounds = YES;
    _fullSizeButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _fullSizeButton.layer.borderWidth = 0.5;
    _fullSizeButton.alpha = 0;
    [self.settingView addSubview:_fullSizeButton];
    [self.fullSizeButton addTarget:self action:@selector(fullSize) forControlEvents:UIControlEventTouchUpInside];
    _fullSizeButton.showsTouchWhenHighlighted = YES;
    //窄屏
    self.smallSizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _smallSizeButton.frame = CGRectMake6((WIDTH/2-40)/2, 250, 40, 40);
    [_smallSizeButton setTitle:@"窄屏" forState:UIControlStateNormal];
    _smallSizeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_smallSizeButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    [_smallSizeButton setTitleColor:[UIColor colorWithRed:227/255.0 green:56/255.0 blue:43/255.0 alpha:1] forState:UIControlStateSelected];
    _smallSizeButton.layer.cornerRadius = 20*SCALE_Y;
    _smallSizeButton.layer.masksToBounds = YES;
    _smallSizeButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _smallSizeButton.layer.borderWidth = 0.5;
    _smallSizeButton.alpha = 0;
    [self.settingView addSubview:_smallSizeButton];
    [_smallSizeButton addTarget:self action:@selector(smallSize) forControlEvents:UIControlEventTouchUpInside];
    _smallSizeButton.showsTouchWhenHighlighted = YES;
    //屏切
    self.sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sizeButton.frame = CGRectMake6((WIDTH/2-40)/2, 250, 40, 40);
    //[_sizeButton setTitle:@"切屏" forState:UIControlStateNormal];
    _sizeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_sizeButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    [_sizeButton setTitleColor:[UIColor colorWithRed:227/255.0 green:56/255.0 blue:43/255.0 alpha:1] forState:UIControlStateSelected];
    _sizeButton.layer.cornerRadius = 20*SCALE_Y;
    _sizeButton.layer.masksToBounds = YES;
    _sizeButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _sizeButton.layer.borderWidth = 0.5;
    [self.settingView addSubview:_sizeButton];
    [self.sizeButton addTarget:self action:@selector(sizeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _sizeButton.showsTouchWhenHighlighted = YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"size"] isEqualToString:@"full"]) {
        self.fullSizeButton.selected = YES;
        [_sizeButton setTitle:@"宽屏" forState:UIControlStateNormal];
    }
    else
    {
        self.smallSizeButton.selected = YES;
        [_sizeButton setTitle:@"窄屏" forState:UIControlStateNormal];
    }

    //日
    self.dayModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dayModelButton.frame = CGRectMake6((WIDTH/2-40)/2, 310, 40, 40);
    [_dayModelButton setTitle:@"白昼" forState:UIControlStateNormal];
    _dayModelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_dayModelButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    [_dayModelButton setTitleColor:[UIColor colorWithRed:227/255.0 green:56/255.0 blue:43/255.0 alpha:1] forState:UIControlStateSelected];
    _dayModelButton.layer.cornerRadius = 20*SCALE_Y;
    _dayModelButton.layer.masksToBounds = YES;
    _dayModelButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _dayModelButton.layer.borderWidth = 0.5;
    _dayModelButton.alpha = 0;
    [self.settingView addSubview:_dayModelButton];
    [self.dayModelButton addTarget:self action:@selector(dayModelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _dayModelButton.showsTouchWhenHighlighted = YES;
    //夜间
    self.nightModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nightModelButton.frame = CGRectMake6((WIDTH/2-40)/2, 310, 40, 40);
    [_nightModelButton setTitle:@"黑夜" forState:UIControlStateNormal];
    _nightModelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_nightModelButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    [_nightModelButton setTitleColor:[UIColor colorWithRed:227/255.0 green:56/255.0 blue:43/255.0 alpha:1] forState:UIControlStateSelected];
    _nightModelButton.layer.cornerRadius = 20*SCALE_Y;
    _nightModelButton.layer.masksToBounds = YES;
    _nightModelButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _nightModelButton.layer.borderWidth = 0.5;
    _nightModelButton.alpha = 0;
    [self.settingView addSubview:_nightModelButton];
    [_nightModelButton addTarget:self action:@selector(nightModelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _nightModelButton.showsTouchWhenHighlighted = YES;
    ////日夜模式切换
    self.dayAndNightModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dayAndNightModelButton.frame = CGRectMake6((WIDTH/2-40)/2, 310, 40, 40);
    //[_dayAndNightModelButton setTitle:@"日夜" forState:UIControlStateNormal];
    _dayAndNightModelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_dayAndNightModelButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    [_dayAndNightModelButton setTitleColor:[UIColor colorWithRed:227/255.0 green:56/255.0 blue:43/255.0 alpha:1] forState:UIControlStateSelected];
    _dayAndNightModelButton.layer.cornerRadius = 20*SCALE_Y;
    _dayAndNightModelButton.layer.masksToBounds = YES;
    _dayAndNightModelButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _dayAndNightModelButton.layer.borderWidth = 0.5;
    [self.settingView addSubview:_dayAndNightModelButton];
    [self.dayAndNightModelButton addTarget:self action:@selector(dayAndNightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _dayAndNightModelButton.showsTouchWhenHighlighted = YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        self.dayModelButton.selected = YES;
        [_dayAndNightModelButton setTitle:@"白昼" forState:UIControlStateNormal];
    }
    else
    {
        self.nightModelButton.selected = YES;
        [_dayAndNightModelButton setTitle:@"黑夜" forState:UIControlStateNormal];
    }
    //清除缓存
    //确定清除
    self.clearSureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearSureButton.frame = CGRectMake6((WIDTH/2-40)/2, 370, 40, 40);
    [_clearSureButton setTitle:@"清除" forState:UIControlStateNormal];
    _clearSureButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_clearSureButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    [_clearSureButton setTitleColor:[UIColor colorWithRed:227/255.0 green:56/255.0 blue:43/255.0 alpha:1] forState:UIControlStateSelected];
    _clearSureButton.layer.cornerRadius = 20*SCALE_Y;
    _clearSureButton.layer.masksToBounds = YES;
    _clearSureButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _clearSureButton.layer.borderWidth = 0.5;
    _clearSureButton.alpha = 0;
    [self.settingView addSubview:_clearSureButton];
    [self.clearSureButton addTarget:self action:@selector(clearSureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _clearSureButton.showsTouchWhenHighlighted = YES;
    //取消清除
    self.clearCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearCancelButton.frame = CGRectMake6((WIDTH/2-40)/2, 370, 40, 40);
    [_clearCancelButton setTitle:@"取消" forState:UIControlStateNormal];
    _clearCancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    //[_clearCancelButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    [_clearCancelButton setTitleColor:[UIColor colorWithRed:227/255.0 green:56/255.0 blue:43/255.0 alpha:1] forState:UIControlStateNormal];
    _clearCancelButton.layer.cornerRadius = 20*SCALE_Y;
    _clearCancelButton.layer.masksToBounds = YES;
    _clearCancelButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _clearCancelButton.layer.borderWidth = 0.5;
    _clearCancelButton.alpha = 0;
    [self.settingView addSubview:_clearCancelButton];
    [_clearCancelButton addTarget:self action:@selector(clearCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _clearCancelButton.showsTouchWhenHighlighted = YES;
    ////缓存大小
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearButton.frame = CGRectMake6((WIDTH/2-40)/2, 370, 40, 40);
    _clearButton.titleLabel.font = [UIFont systemFontOfSize:9];
    [_clearButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    [_clearButton setTitleColor:[UIColor colorWithRed:227/255.0 green:56/255.0 blue:43/255.0 alpha:1] forState:UIControlStateSelected];
    _clearButton.layer.cornerRadius = 20*SCALE_Y;
    _clearButton.layer.masksToBounds = YES;
    _clearButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _clearButton.layer.borderWidth = 0.5;
    [self.settingView addSubview:_clearButton];
    [self.clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _clearButton.showsTouchWhenHighlighted = YES;

    //免责声明
    self.mianzeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mianzeButton.frame = CGRectMake6((WIDTH/2-40)/2, 430, 40, 40);
    [_mianzeButton setTitle:@"声明" forState:UIControlStateNormal];
    _mianzeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_mianzeButton setTitleColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6] forState:UIControlStateNormal];
    _mianzeButton.layer.cornerRadius = 20*SCALE_Y;
    _mianzeButton.layer.masksToBounds = YES;
    _mianzeButton.layer.borderColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6].CGColor;
    _mianzeButton.layer.borderWidth = 0.5;
    [self.settingView addSubview:_mianzeButton];
    [_mianzeButton addTarget:self action:@selector(mianzeViewComeOut) forControlEvents:UIControlEventTouchUpInside];
    _mianzeButton.showsTouchWhenHighlighted = YES;

    
}
-(void)settingFromHomeViewController
{
    if (self.isSetting) {
        //隐藏设置菜单
        [self settingViewHidden];
    }
    else
    {
        //弹出设置菜单
        [self settingViewComeOut];
    }
}
-(void)setting:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        //弹出设置菜单
        [self settingViewComeOut];
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        //隐藏设置菜单
        [self settingViewHidden];
    }
}
//弹出设置菜单
-(void)settingViewComeOut
{
    [self dayOrNight];
    
    self.isSetting = YES;
    if (!_settingView) {
        //设置界面控件初始化
        [self setUpSettingView];
    }
    if (!_mianzeView) {
        //免责view初始化
        [self setUpMianzeView];
    }
    //电台
    [RadioStreamer shareManager].radioDelegate = self;
    [self reloadRadioControllerView];
    //点击屏幕收起设置手势
    self.hiddenSettingTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingViewHidden)];
    _hiddenSettingTapGR.numberOfTapsRequired = 1;
    [self.view2.view addGestureRecognizer:_hiddenSettingTapGR];
    //显示缓存大小
    self.clearSize = (float)[[SDImageCache sharedImageCache] getSize]/1024/1024;
    [_clearButton setTitle:[NSString stringWithFormat:@"%.1fM",self.clearSize] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.settingView.frame = CGRectMake1(0, 0, WIDTH/2, HEIGHT);
    } completion:^(BOOL finished) {
    }];
    
}
//隐藏设置菜单
-(void)settingViewHidden
{
    self.isSetting = NO;
    //移除点击手势
    [self.view2.view removeGestureRecognizer:_hiddenSettingTapGR];
    //屏切复原
    [self sizeButtonBackToStart];
    //日夜间切换复原
    [self dayAndNightButtonBackToStart];
    //清除缓存按钮复原
    [self clearButtonBackToStart];

    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.settingView.frame = CGRectMake1(-WIDTH/2-1, 0, WIDTH/2, HEIGHT);
    } completion:^(BOOL finished) {
    }];
}
//文章
-(void)articling
{
    ArticleViewController *articleVC = [[ArticleViewController alloc] init];
    articleVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *articleNC = [[UINavigationController alloc] initWithRootViewController:articleVC];
    articleVC.day = arc4random()%365+1;
    [self presentViewController:articleNC animated:YES completion:nil];
    
    //隐藏设置菜单
    [self settingViewHidden];
}
//屏切
-(void)sizeButtonAction
{
    //日夜间切换复原
    [self dayAndNightButtonBackToStart];
    //清除缓存按钮复原
    [self clearButtonBackToStart];

    [UIView animateWithDuration:1.0 animations:^{
        _sizeButton.alpha = 0;
        _fullSizeButton.alpha = 1;
        _fullSizeButton.frame = CGRectMake6((WIDTH/2-40)/2-25, 250, 40, 40);
        _smallSizeButton.alpha = 1;
        _smallSizeButton.frame = CGRectMake6((WIDTH/2-40)/2+25, 250, 40, 40);
    }];
}
//屏切复原
-(void)sizeButtonBackToStart
{
    [UIView animateWithDuration:1.0 animations:^{
        _fullSizeButton.alpha = 0;
        _fullSizeButton.frame = CGRectMake6((WIDTH/2-40)/2, 250, 40, 40);
        _smallSizeButton.alpha = 0;
        _smallSizeButton.frame = CGRectMake6((WIDTH/2-40)/2, 250, 40, 40);
        _sizeButton.alpha = 1;
    }];
}
//全屏
-(void)fullSize
{
    [[NSUserDefaults standardUserDefaults] setObject:@"full" forKey:@"size"];
    self.fullSizeButton.selected = YES;
    self.smallSizeButton.selected = NO;
    [_sizeButton setTitle:@"宽屏" forState:UIControlStateNormal];
    NSUserDefaults *sizeDe = [NSUserDefaults standardUserDefaults];
    [sizeDe setFloat:WIDTH*SCALE_X forKey:@"ww"];
    [sizeDe setFloat:(HEIGHT-64-49)*SCALE_Y forKey:@"hh"];
    [sizeDe setFloat:0 forKey:@"xx"];
    //屏切复原
    [self sizeButtonBackToStart];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bigAndSmall" object:nil userInfo:nil];
}
//窄屏
-(void)smallSize
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"small" forKey:@"size"];
    self.smallSizeButton.selected = YES;
    self.fullSizeButton.selected = NO;
    [_sizeButton setTitle:@"窄屏" forState:UIControlStateNormal];
    NSUserDefaults *sizeDe = [NSUserDefaults standardUserDefaults];
    [sizeDe setFloat:(WIDTH-30)*SCALE_X forKey:@"ww"];
    [sizeDe setFloat:(HEIGHT-64-64)*SCALE_Y forKey:@"hh"];
    [sizeDe setFloat:(15*SCALE_X) forKey:@"xx"];
    //屏切复原
    [self sizeButtonBackToStart];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bigAndSmall" object:nil userInfo:nil];
}
//日夜间模式切换
-(void)dayAndNightButtonAction
{
    //屏切复原
    [self sizeButtonBackToStart];
    //清除缓存按钮复原
    [self clearButtonBackToStart];
    
    [UIView animateWithDuration:1.0 animations:^{
        _dayModelButton.alpha = 1;
        _dayModelButton.frame = CGRectMake6((WIDTH/2-40)/2-25, 310, 40, 40);
        _nightModelButton.alpha = 1;
        _nightModelButton.frame = CGRectMake6((WIDTH/2-40)/2+25, 310, 40, 40);
        _dayAndNightModelButton.alpha = 0;
    }];
}
//日夜间切换复原
-(void)dayAndNightButtonBackToStart
{
    [UIView animateWithDuration:1.0 animations:^{
        _dayModelButton.alpha = 0;
        _dayModelButton.frame = CGRectMake6((WIDTH/2-40)/2, 310, 40, 40);
        _nightModelButton.alpha = 0;
        _nightModelButton.frame = CGRectMake6((WIDTH/2-40)/2, 310, 40, 40);
        _dayAndNightModelButton.alpha = 1;
    }];
}
//日间模式
-(void)dayModelButtonAction
{
    [[NSUserDefaults standardUserDefaults] setObject:@"day" forKey:@"DAN"];
    self.dayModelButton.selected = YES;
    self.nightModelButton.selected = NO;
    [_dayAndNightModelButton setTitle:@"白昼" forState:UIControlStateNormal];
    //日夜间切换复原
    [self dayAndNightButtonBackToStart];
    
    
    
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dayAndNight" object:nil userInfo:nil];
    
}
//夜间模式
-(void)nightModelButtonAction
{
    [[NSUserDefaults standardUserDefaults] setObject:@"night" forKey:@"DAN"];
    self.dayModelButton.selected = NO;
    self.nightModelButton.selected = YES;
    [_dayAndNightModelButton setTitle:@"黑夜" forState:UIControlStateNormal];
    //日夜间切换复原
    [self dayAndNightButtonBackToStart];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dayAndNight" object:nil userInfo:nil];
}
//添加点击收起屏切和日夜间模式按钮手势
-(void)pickUpButtonAction
{
    //屏切复原
    [self sizeButtonBackToStart];
    //日夜间切换复原
    [self dayAndNightButtonBackToStart];
    //清除缓存按钮复原
    [self clearButtonBackToStart];
}
//此页面日夜模式切换
-(void)dayOrNight
{
    //背景色
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"]) {
        self.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        self.view2.view.backgroundColor = [UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1];
        self.color = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.view2.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:70/255.0 alpha:1];
        self.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    }
    //按钮文字颜色
    [_articleButton setTitleColor:self.color forState:UIControlStateNormal];
    _articleButton.layer.borderColor = self.color.CGColor;
    [_fullSizeButton setTitleColor:self.color forState:UIControlStateNormal];
    _fullSizeButton.layer.borderColor = self.color.CGColor;
    [_smallSizeButton setTitleColor:self.color forState:UIControlStateNormal];
    _settingButton.layer.borderColor = self.color.CGColor;
    [_sizeButton setTitleColor:self.color forState:UIControlStateNormal];
    _sizeButton.layer.borderColor = self.color.CGColor;
    [_dayModelButton setTitleColor:self.color forState:UIControlStateNormal];
    _dayModelButton.layer.borderColor = self.color.CGColor;
    [_nightModelButton setTitleColor:self.color forState:UIControlStateNormal];
    _nightModelButton.layer.borderColor = self.color.CGColor;
    [_dayAndNightModelButton setTitleColor:self.color forState:UIControlStateNormal];
    _dayAndNightModelButton.layer.borderColor = self.color.CGColor;
    [_clearSureButton setTitleColor:self.color forState:UIControlStateNormal];
    _clearSureButton.layer.borderColor = self.color.CGColor;
    [_clearCancelButton setTitleColor:self.color forState:UIControlStateNormal];
    _clearCancelButton.layer.borderColor = self.color.CGColor;
    [_clearButton setTitleColor:self.color forState:UIControlStateNormal];
    _clearButton.layer.borderColor = self.color.CGColor;
    [_mianzeButton setTitleColor:self.color forState:UIControlStateNormal];
    _mianzeButton.layer.borderColor = self.color.CGColor;
}
//清除缓存
-(void)clearButtonAction
{
    //屏切复原
    [self sizeButtonBackToStart];
    //日夜间切换复原
    [self dayAndNightButtonBackToStart];
    [UIView animateWithDuration:1.0 animations:^{
        self.clearButton.alpha = 0;
        _clearCancelButton.alpha = 1;
        _clearCancelButton.frame = CGRectMake6((WIDTH/2-40)/2+25, 370, 40, 40);
        _clearSureButton.alpha = 1;
        _clearSureButton.frame = CGRectMake6((WIDTH/2-40)/2-25, 370, 40, 40);
    }];

}
//清除缓存按钮复原
-(void)clearButtonBackToStart
{
    [UIView animateWithDuration:1.0 animations:^{
        _clearCancelButton.alpha = 0;
        _clearCancelButton.frame = CGRectMake6((WIDTH/2-40)/2, 370, 40, 40);
        _clearSureButton.alpha = 0;
        _clearSureButton.frame = CGRectMake6((WIDTH/2-40)/2, 370, 40, 40);
        self.clearButton.alpha = 1;
    }];
}
//确定清除
-(void)clearSureButtonAction
{
    NSLog(@"缓存：%ld",[[SDImageCache sharedImageCache] getSize]);
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    NSLog(@"缓存：%ld",[[SDImageCache sharedImageCache] getSize]);
    self.clearSize = (float)[[SDImageCache sharedImageCache] getSize]/1024/1024;
    [_clearButton setTitle:[NSString stringWithFormat:@"%.1fM",self.clearSize] forState:UIControlStateNormal];
    [self clearButtonBackToStart];
    

}
//取消清除
-(void)clearCancelButtonAction
{
    [self clearButtonBackToStart];
}
//免责view初始化
-(void)setUpMianzeView
{
    //免责声明
    self.mianzeView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH-190)*SCALE_X/2, -251*SCALE_Y, 190, 275)];
    _mianzeView.backgroundColor = [UIColor clearColor];
    _mianzeView.layer.cornerRadius = 5;
    _mianzeView.layer.masksToBounds = YES;
    _mianzeView.alpha = 0;
    //毛玻璃效果
    UIVisualEffectView *mianzeVisual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    mianzeVisual.frame = CGRectMake(0, 0, 190, 275);
    [self.mianzeView addSubview:mianzeVisual];
    //图标
    UIImageView *coverView = [[UIImageView alloc] initWithFrame:CGRectMake6(10, 5, 30, 30)];
    coverView.layer.cornerRadius = 15*SCALE_Y;
    coverView.layer.masksToBounds = YES;
    coverView.layer.borderColor = [UIColor whiteColor].CGColor;
    coverView.layer.borderWidth = 1;
    coverView.image = [UIImage imageNamed:@"holder"];
    [self.mianzeView addSubview:coverView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((190-80)/2, 10*SCALE_Y, 80, 20*SCALE_Y)];
    //titleLabel.backgroundColor = [UIColor orangeColor];
    titleLabel.text = @"免责声明";
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.mianzeView addSubview:titleLabel];
    //文字内容
    self.mianzeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*SCALE_X, 35*SCALE_Y, 180, 225)];
    _mianzeLabel.backgroundColor = [UIColor clearColor];
    _mianzeLabel.text = @"       在使用前，请务必仔细阅读并透彻理解本声明。您可以选择不使用本APP，但如果您使用本APP，您的使用行为将被视为对本声明全部内容的认可。\n       本APP所有数据均来源于网络，本APP不做任何形式的保证：不保证内容的安全性、正确性、及时性、合法性，亦不承担任何法律责任。\n       本APP仅用于学习、娱乐，请勿用于商业用途！使用者应遵守著作权法及其他相关法律的规定，不得侵犯本APP及其相关权利人的合法权利。";
    _mianzeLabel.font = [UIFont systemFontOfSize:12];
    _mianzeLabel.numberOfLines = 0;
    [self.mianzeView addSubview:self.mianzeLabel];
    
    [self.view addSubview:_mianzeView];
    
    self.mianzeView.translatesAutoresizingMaskIntoConstraints = NO;
    //拖动mianzeView手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGR setMinimumNumberOfTouches:1];
    [panGR setMaximumNumberOfTouches:1];
    [panGR setDelegate:self];
    [self.mianzeView setUserInteractionEnabled:YES];
    [self.mianzeView addGestureRecognizer:panGR];
    
    //关闭
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(190-10-20*SCALE_Y, 10*SCALE_Y, 20*SCALE_Y, 20*SCALE_Y);
    [closeButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [self.mianzeView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
}
//关闭免责
-(void)closeButtonAction
{
    [self mianzeViewHidden];
}
//拖拽免责View
-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //移动
    CGPoint point = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x+point.x, recognizer.view.center.y+point.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat changeY = recognizer.view.center.y;
        self.mianzeComeOutVisual.alpha = (HEIGHT- changeY)/HEIGHT;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat endY = recognizer.view.center.y;
        //设置回弹参数
        if (endY - self.view2.view.center.y < 40 || self.view2.view.center.y > endY) {
            [UIView animateWithDuration:1.0 animations:^{
                self.mianzeView.frame = CGRectMake((WIDTH-190)*SCALE_X/2, 150*SCALE_Y, 190, 275);
                _mianzeView.center = self.view.center;
                _mianzeComeOutVisual.alpha = 0.8;
            }];
        }
        else
        {
            //关闭免责
            [self mianzeViewHidden];
        }
    }
}
//免责view弹出
-(void)mianzeViewComeOut
{
    //毛玻璃效果
    self.mianzeComeOutVisual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    //_mianzeComeOutVisual.alpha = 0.0;
    _mianzeComeOutVisual.frame = CGRectMake1(0, 0, WIDTH, HEIGHT);
    [self.view2.view addSubview:_mianzeComeOutVisual];
    //隐藏设置菜单
    [self settingViewHidden];
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _mianzeComeOutVisual.alpha = 0.5;
        self.mianzeView.frame = CGRectMake((WIDTH-190)*SCALE_X/2, 150*SCALE_Y, 190, 275);
        _mianzeView.alpha = 1;
        _mianzeView.center = self.view.center;
    } completion:^(BOOL finished) {
    }];
}
//免责viewhidden
-(void)mianzeViewHidden
{
    [UIView animateWithDuration:1.0 animations:^{
        self.mianzeView.frame = CGRectMake((WIDTH-190)*SCALE_X/2, (HEIGHT+1)*SCALE_Y, 190, 275);
        _mianzeView.alpha = 0;
        self.mianzeComeOutVisual.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (_mianzeComeOutVisual) {
            [_mianzeComeOutVisual removeFromSuperview];
        }
        self.mianzeView.frame = CGRectMake1((WIDTH-190)/2, -251, 190, 275);
        //        if (_mianzeView) {
        //            [_mianzeView removeFromSuperview];
        //        }
    }];
}


//电台控件初始化
-(void)setUpRadioControllerView
{
    //歌曲图片
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake4((WIDTH/2-50)/2, HEIGHT-160, 50, 50)];
    _imageV.layer.cornerRadius = 25*SCALE_Y;
    _imageV.layer.masksToBounds = YES;
    _imageV.layer.borderColor = [UIColor grayColor].CGColor;
    _imageV.layer.borderWidth = 1;
    [self.settingView addSubview:_imageV];
    _imageV.backgroundColor = [UIColor orangeColor];
    
    UIButton *goToRadioPlayVCButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goToRadioPlayVCButton.frame = CGRectMake1((WIDTH/2-50)/2, HEIGHT-160, 50, 50);
    goToRadioPlayVCButton.layer.cornerRadius = 25*SCALE_Y;
    goToRadioPlayVCButton.layer.masksToBounds = YES;
    [self.settingView addSubview:goToRadioPlayVCButton];
    [goToRadioPlayVCButton addTarget:self action:@selector(goToRadioPlayView) forControlEvents:UIControlEventTouchUpInside];

    //播放
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake4((WIDTH/2-30)/2, HEIGHT-90, 30, 30);

    [self.settingView addSubview:_playButton];
    [self.playButton addTarget:self action:@selector(playing) forControlEvents:UIControlEventTouchUpInside];
    //歌曲名称
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake1(0, HEIGHT-40, WIDTH/2, 20)];
    [self.settingView addSubview:_nameLabel];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.numberOfLines = 0;
}
//点击回到播放页面
-(void)goToRadioPlayView
{
    RadioPlayViewController *radioV = [[RadioPlayViewController alloc] init];
    radioV.currentIndex = [[RadioManager shareManager] showIndex];
    radioV.radioArray = [[RadioManager shareManager] showArray];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:radioV];
    [self presentViewController:nav animated:YES completion:^{
        [self settingViewHidden];
    }];
}
//播放完成后的代理方法
-(void)audioStreamerDidFinishPlaying
{
    NSMutableArray *arr = [[RadioManager shareManager] showArray];
    if (self.index < arr.count-1) {
        self.index ++;
    }
    [[RadioManager shareManager] configureWithIndex:self.index];
    [self reloadRadioControllerView];
    
}
//开始播放的代理方法 设置按钮状态
-(void)playNow
{
    [self.playButton setImage:[UIImage imageNamed:@"RadioPause_h"] forState:UIControlStateNormal];
}
-(void)audioStreamerPlayingWithPregress:(float)progressValue
{
    
}
//电台控件赋值
-(void)reloadRadioControllerView
{
    _index = [[RadioManager shareManager] showIndex];
    NSMutableArray *arr = [[RadioManager shareManager] showArray];
    self.radio = arr[_index];
    if (self.radio.titleStr.length > 0) {
        if (![[RadioStreamer shareManager] isPlayingCurrentAudioWithUrl:self.radio.musicUrlStr]) {
            [[RadioStreamer shareManager] setAudioMusicWithUrl:_radio.musicUrlStr];
        }
        //电台控件初始化
        if (!_playButton) {
            [self setUpRadioControllerView];
            [self colorChange];//图片封面渐变层
        }
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:self.radio.coverimgStr] placeholderImage:[UIImage imageNamed:@"holder"]];
        self.nameLabel.text = self.radio.titleStr;
        
        if ([[RadioStreamer shareManager] isPlaying] == YES) {
            [self.playButton setImage:[UIImage imageNamed:@"RadioPause_h"] forState:UIControlStateNormal];
            //为了安全 判断timer是否为空
            if (self.timer) {
                return;//return则跳出方法 底下self.timer =...的方法不再执行
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
        }else
        {
            [self.playButton setImage:[UIImage imageNamed:@"RadioPlay_h"] forState:UIControlStateNormal];
            
            //关闭定时器
            [self.timer invalidate];
            //安全释放
            self.timer = nil;
        }
    }
}
//播放
-(void)playing
{
    //屏切复原
    [self sizeButtonBackToStart];
    //日夜间切换复原
    [self dayAndNightButtonBackToStart];
    //清除缓存按钮复原
    [self clearButtonBackToStart];
    
    if ([[RadioStreamer shareManager] playState] == YES) {
        [[RadioStreamer shareManager] pause];
        [_playButton setImage:[UIImage imageNamed:@"RadioPlay_h"] forState:UIControlStateNormal];
        
        //安全释放颜色渐变计时器
        [self.timer invalidate];
        self.timer = nil;
        
    }else{
        [[RadioStreamer shareManager] play];
        [_playButton setImage:[UIImage imageNamed:@"RadioPause_h"] forState:UIControlStateNormal];
        
        //为了安全 判断timer是否为空
        if (self.timer) {
            return;//return则跳出方法 底下self.timer =...的方法不再执行
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeColor) userInfo:nil repeats:YES];
    }
}
//电台图片颜色渐变
//初始化渐变层
-(void)colorChange
{
    //颜色渐变
    //初始化渐变层
    self.gradientLayer = [CAGradientLayer layer];
    self.imageV.alpha = 1;
    self.gradientLayer.frame = _imageV.bounds;
    [_imageV.layer addSublayer:self.gradientLayer];
    //设置渐变颜色的方向
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    //设定颜色组
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor purpleColor].CGColor];
    //设定颜色分割点
    self.gradientLayer.colors = @[@(0.5f),@(1.0f)];
}
//颜色渐变
-(void)changeColor
{
    //定时改变颜色
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0].CGColor];
    //定时改变分割点
    self.gradientLayer.locations = @[@(arc4random()%10/10.0f),@(1.0f)];
}
//让子视图控制状态栏的隐藏与出现
-(UIViewController *)childViewControllerForStatusBarHidden
{
    return self.view2;
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
