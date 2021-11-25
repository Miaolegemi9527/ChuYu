//
//  HomeCollectionViewCell.h
//  Mine
//
//  Created by lanou on 16/1/13.
//  Copyright © 2016年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel2.h"

@interface HomeCollectionViewCell : UICollectionViewCell

//图片
@property(nonatomic,retain)UIImageView *imageV;
//赋值
-(void)configureWithHome2:(HomeModel2 *)home2;
////宽窄屏切换 刷新视图
-(void)reloadBigAndSmallView;
@end
