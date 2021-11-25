//
//  ArticleView.h
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"


@interface ArticleView : UIView

//便于隐藏导航栏和状态栏
@property(nonatomic,retain)UIScrollView *articleScrollView;

//赋值
-(void)configureWithArticle:(ArticleModel *)article;
//设置字体大小
-(void)setFont:(CGFloat)font;
//设置背景颜色
-(void)setColor:(UIColor *)color Color2:(UIColor *)color2;



@end
