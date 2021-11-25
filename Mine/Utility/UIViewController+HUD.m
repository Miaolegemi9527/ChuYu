//
//  UIViewController+HUD.m
//  Mine
//
//  Created by 廖毅 on 15/12/14.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "UIViewController+HUD.h"



@implementation UIViewController (HUD)


//我的提示
-(void)showLoadingIndicatorView
{
    UIActivityIndicatorView *activityv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityv.frame = CGRectMake((self.view.frame.size.width-25)/2, (self.view.frame.size.height-30)/2-110, 30, 30);
    activityv.color = [UIColor purpleColor];
    [self.view addSubview:activityv];
    [activityv startAnimating];
    activityv.tag = 1001;
}

-(void)showLoadingView2
{
    //网络加载时转圈圈 article
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake1((WIDTH-25)/2, (HEIGHT-30)/2-60, 30, 30);
    indicator.color = [UIColor purpleColor];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    indicator.tag = 10002;
}

//我的提示 隐藏（移除）
-(void)showLoadingImageView
{
    //图片
    UIImageView *noNetIV = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-57)/2, (self.view.frame.size.width)/2+90, 60, 60)];
    noNetIV.image = [UIImage imageNamed:@"NoNetImage"];
    noNetIV.tag = 1002;
    [self.view addSubview:noNetIV];
}
-(void)hideLoadingView
{
    UIView *view = self.view;
    for (UIActivityIndicatorView *subView in view.subviews) {
        if (subView.tag == 1001) {
            [subView stopAnimating];
            [subView removeFromSuperview];
        }
        if (subView.tag == 1002) {
            [subView removeFromSuperview];
        }if (subView.tag == 10002) {
            [subView removeFromSuperview];
        }
    }
}


@end
