//
//  UIViewController+HUD.h
//  Mine
//
//  Created by 廖毅 on 15/12/14.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

//基类
//分类（类目) 特点：只能添加（扩展）方法 不能扩充属性
//创建方法 Source -> Objective-C File ->category

//方法 声明
//我的提示 弹出
-(void)showLoadingIndicatorView;
-(void)showLoadingImageView;
//我的提示 隐藏（移除）
-(void)hideLoadingView;

-(void)showLoadingView2;

@end
