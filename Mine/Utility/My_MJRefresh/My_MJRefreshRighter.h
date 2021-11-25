//
//  My_MJRefreshRighter.h
//  Galaxy
//
//  Created by lanou on 16/1/11.
//  Copyright © 2016年 9527. All rights reserved.
//

#import "MJRefreshFooter.h"

@interface My_MJRefreshRighter : MJRefreshFooter

/** 是否自动刷新(默认为YES) */
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh MJRefreshDeprecated("请使用automaticallyChangeAlpha属性");

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;

@end
