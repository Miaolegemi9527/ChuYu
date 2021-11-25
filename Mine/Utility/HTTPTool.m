//
//  HTTPTool.m
//  Mine
//
//  Created by 廖毅 on 15/12/14.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "HTTPTool.h"

@interface HTTPTool ()

//根据传进来的时间获取数据
@property(nonatomic,strong)NSString *timeStr;
//根据传进来的ID获取响应的数据
@property(nonatomic,assign)NSInteger albumID;
//根据图片ID和偏移量上下拉刷新数据 每次刷新10张
@property(nonatomic,assign)NSInteger albumIDOffset;
//timeTable 根据传入的类型获取相应的阅读类型
@property(nonatomic,assign)NSInteger type;
//timeTable根据开始位置（个数）刷新
@property(nonatomic,assign)NSInteger startNumber;
//TimeArticle 根据传入的文章id获取相应的文章内容
@property(nonatomic,strong)NSString *Contentid;

@property(nonatomic,strong) UIAlertController *alert;
//电台Radio
//电台列表上下拉刷新 根据传入的start获取相应的数据
@property(nonatomic,assign)NSInteger radioListLimitAndStart;
//电台详情上下拉刷新 根据传入的start获取相应的数据
@property(nonatomic,assign)NSInteger radioDetailStart;
//电台歌单 根据传入的Radioid获取电台歌单
@property(nonatomic,strong)NSString *radioidStr;


@end

@implementation HTTPTool


//网络判断
-(BOOL)isNetWork
{
    BOOL isNetWork = NO;//BOOL 默认为NO
    //创建网络监测对象
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:
        {
            NSLog(@"当前没有网络");
            isNetWork = NO;
        }
            break;
        case ReachableViaWiFi:
        {
            NSLog(@"当前为WIFI网络");
            isNetWork = YES;
        }
            break;
        case ReachableViaWWAN:
        {
            NSLog(@"当前为2g/3g网络");//设置2g/3g网络是否可访问网络
            isNetWork = YES;
        }
            break;
        default:
            break;
    }
    return isNetWork;
}
-(void)requestDataByTime:(NSString *)dateStr
{
    self.timeStr = dateStr;
}
//获取首页 日期 图片+文字
-(void)requestHomeContentByDateController:(UIViewController *)controller InfoBlock:(block)HomeContentBlock
{
    if ([self isNetWork]) {
        //解析
        NSURLSession *session = [NSURLSession sharedSession];
        //NSURL *url = [NSURL URLWithString:@"http://rest.wufazhuce.com/OneForWeb/one/getHp_N?strDate=2015-12-15&strRow=1"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://rest.wufazhuce.com/OneForWeb/one/getHp_N?strDate=%@&strRow=1",self.timeStr]];
        NSURLSessionTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            HomeContentBlock(data);
        }];
        [dataTask resume];
    }
    else
    {
        NSLog(@"网络异常");
        [controller showLoadingIndicatorView];
        [controller showLoadingImageView];
        
    }
}
//文章
-(void)requestArticleByDateController:(UIViewController *)controller InfoBlock:(block)ArticleBlock
{
    if ([self isNetWork] == YES) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://bea.wufazhuce.com/OneForWeb/one/getOneContentInfo?strDate=%@&strRow=1&strMS=1",self.timeStr]];
        NSURLSessionTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            ArticleBlock(data);
        }];
        [dataTask resume];
    }
    else
    {
        NSLog(@"网络异常");
        [controller showLoadingIndicatorView];
        [controller showLoadingImageView];
    }
}
//Time
-(void)requestTimeByDateController:(UIViewController *)controller InfoBlock:(block)TimeBlock
{
    if ([self isNetWork] == YES) {
         
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *mrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api2.pianke.me/read/columns"]];
        //设置请求样式为POST
        mrequest.HTTPMethod = @"POST";
        mrequest.HTTPBody = [@"auth=&client=1&deviceid=4F19F3EA-310E-40EC-B1A6-B76BDBBA61CC&version=3.0.6" dataUsingEncoding:NSUTF8StringEncoding];//字符串转data
        NSURLSessionTask *dataTask = [session dataTaskWithRequest:mrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            TimeBlock(data);
        }];
        [dataTask resume];
    }
    else
    {
        NSLog(@"网络异常");
        [controller showLoadingIndicatorView];
        [controller showLoadingImageView];
    }
}

//TimeTabel
-(void)requestTimeTabelDataByType:(NSInteger)type
{
    self.type = type;//根据传入的类型请求数据
}
-(void)requestTimeTabelDataByStart:(NSInteger)start
{
    self.startNumber = start;
}
-(void)requestTimeTabelByDateController:(UIViewController *)controller InfoBlock:(block)TimeTableBlock
{
    if ([self isNetWork] == YES) {
         
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *mrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api2.pianke.me/read/columns_detail"]];
        //设置请求样式为POST
        mrequest.HTTPMethod = @"POST";
        mrequest.HTTPBody = [[NSString stringWithFormat:@"auth=&client=1&deviceid=4F19F3EA-310E-40EC-B1A6-B76BDBBA61CC&limit=10&sort=addtime&start=%ld&typeid=%ld&version=3.0.6",self.startNumber,self.type] dataUsingEncoding:NSUTF8StringEncoding];//字符串转data
        NSURLSessionTask *dataTask = [session dataTaskWithRequest:mrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            TimeTableBlock(data);
        }];
        [dataTask resume];
    }
    else
    {
        NSLog(@"网络异常");
        [controller showLoadingIndicatorView];
        [controller showLoadingImageView];
    }

}
//TimeArticle
-(void)requestTimeArticleDataByContentid:(NSString *)ContentidStr
{
    self.Contentid = ContentidStr;
}
-(void)requestTimeArticleByDateController:(UIViewController *)controller InfoBlock:(block)TimeArticleBlock
{
    if ([self isNetWork] == YES) {
         
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *mrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://api2.pianke.me/article/info"]];
        //设置请求样式为POST
        mrequest.HTTPMethod = @"POST";
        mrequest.HTTPBody = [[NSString stringWithFormat:@"auth=&client=1&contentid=%@&deviceid=4F19F3EA-310E-40EC-B1A6-B76BDBBA61CC&version=3.0.6",self.Contentid] dataUsingEncoding:NSUTF8StringEncoding];//字符串转data
        NSURLSessionTask *dataTask = [session dataTaskWithRequest:mrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            TimeArticleBlock(data);
        }];
        [dataTask resume];
    }
    else
    {
        NSLog(@"网络异常");
        [controller showLoadingIndicatorView];
        [controller showLoadingImageView];
    }
}
//Image
//Image上下拉刷新 根据传入的ID和偏移量获取相应的数据
-(void)requestDataByalbumIdOffset:(NSInteger)albumIdOffset
{
    self.albumIDOffset = albumIdOffset;
}
-(void)requestImageSayByDateController:(UIViewController *)controller InfoBlock:(block)imageSayBlock
{
    if ([self isNetWork] == YES) {
        //        if (ReachableViaWWAN) {
        //            self.alert = [UIAlertController alertControllerWithTitle:@"当前网络为3g,注意流量" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //            [controller presentViewController:self.alert animated:YES completion:^{
        //                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
        //            }];
        //        }
        NSURLSession *session = [NSURLSession sharedSession];
        //NSURL *url = [NSURL URLWithString:@"http://fotoplace.cc/api2/user/user_albums_hot_list.php"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://fotoplace.cc/api2/user/user_albums_hot_list.php?albumId=%ld&offset=%ld",self.albumIDOffset,self.albumIDOffset]];
        NSURLSessionTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            imageSayBlock(data);
        }];
        [dataTask resume];
    }
    else
    {
        NSLog(@"网络异常");
        [controller showLoadingIndicatorView];
        [controller showLoadingImageView];
    }
}
-(void)dismissAlert
{
    [self.alert dismissViewControllerAnimated:YES completion:nil];
}

//Image详情
//根据传入的ID获取相应的数据
-(void)requestDataByalbumId:(NSInteger)albumId
{
    self.albumID = albumId;
}
-(void)requestImageSay2ByDateController:(UIViewController *)controller InfoBlock:(block)imageSay2Block
{
    if ([self isNetWork] == YES) {
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://fotoplace.cc/api2/user/user_albums_detail.php?album_id=%ld",self.albumID]];
        NSURLSessionTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            imageSay2Block(data);
        }];
        [dataTask resume];
    }
    else
    {
        NSLog(@"网络异常");
        [controller showLoadingIndicatorView];
        [controller showLoadingImageView];
    }
}
//电台Radio
//电台列表上拉刷新 根据传入limit、start获取相应的数据
-(void)requestDataByLimitAndStart:(NSInteger)LimitAndStart
{
    self.radioListLimitAndStart = LimitAndStart;
}
-(void)requestRadioListViewByDateController:(UIViewController *)controller RadioListBlock:(block)RadioListBlock
{
    if ([self isNetWork] == YES) {
        NSString *urlStr;
        NSString *bodyStr;
        if (self.radioListLimitAndStart == 0) {
            NSLog(@"加载");
            urlStr = @"http://api2.pianke.me/ting/radio";
            bodyStr = @"auth=&client=1&deviceid=4F19F3EA-310E-40EC-B1A6-B76BDBBA61CC&version=3.0.6";
        }
        else
        {
            //上拉刷新 self.radioListLimitAndStart每次+9 每次加载9个
            urlStr = @"http://api2.pianke.me/ting/radio_list";
            bodyStr = [NSString stringWithFormat:@"auth=&client=1&deviceid=4F19F3EA-310E-40EC-B1A6-B76BDBBA61CC&limit=9&start=%ld&version=3.0.6",self.radioListLimitAndStart];
            NSLog(@"%ld",self.radioListLimitAndStart);
        }
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *mrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        //设置请求样式为POST
        mrequest.HTTPMethod = @"POST";
        mrequest.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];//字符串转data
        NSURLSessionTask *dataTask = [session dataTaskWithRequest:mrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            RadioListBlock(data);
        }];
        [dataTask resume];
    }
    else
    {
        NSLog(@"网络异常");
        [controller showLoadingIndicatorView];
        [controller showLoadingImageView];
    }
}
//电台详情
-(void)requestDataByRadioDetailStart:(NSInteger)Start
{
    self.radioDetailStart = Start;
}
//根据电台id获取歌单
-(void)requestDataByRadioid:(NSString *)Radioid
{
    self.radioidStr = Radioid;
}
//默认及下拉刷新 上拉刷新 根据传入的limit、start获取相应的数据
-(void)requestRadioDetailViewByDateController:(UIViewController *)controller RadioDetailBlock:(block)RadioListBlock
{
    if ([self isNetWork] == YES) {
        NSString *urlStr;
        NSString *bodyStr;
        if (self.radioDetailStart == 0) {
            NSLog(@"加载");
            urlStr = @"http://api2.pianke.me/ting/radio_detail";
            bodyStr = [NSString stringWithFormat:@"auth=&client=1&deviceid=4F19F3EA-310E-40EC-B1A6-B76BDBBA61CC&radioid=%@&version=3.0.6",self.radioidStr];
        }
        else
        {
            //上拉刷新 self.radioDetailStart每次+10 每次加载10个
            urlStr = @"http://api2.pianke.me/ting/radio_detail_list";
            bodyStr = [NSString stringWithFormat:@"auth=&client=1&deviceid=4F19F3EA-310E-40EC-B1A6-B76BDBBA61CC&limit=10&radioid=%@&start=%ld&version=3.0.6",self.radioidStr,self.radioDetailStart];
            NSLog(@"self.radioDetailStart=%ld",self.radioDetailStart);
        }
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *mrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        //设置请求样式为POST
        mrequest.HTTPMethod = @"POST";
        mrequest.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];//字符串转data
        NSURLSessionTask *dataTask = [session dataTaskWithRequest:mrequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            RadioListBlock(data);
        }];
        [dataTask resume];
    }
    else
    {
        NSLog(@"网络异常");
        [controller showLoadingIndicatorView];
        [controller showLoadingImageView];
    }
}


@end
