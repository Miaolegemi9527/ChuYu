//
//  My_MJRefreshStateRighter.h
//  Galaxy
//
//  Created by lanou on 16/1/11.
//  Copyright © 2016年 9527. All rights reserved.
//

#import "My_MJRefreshRighter.h"

@interface My_MJRefreshStateRighter : My_MJRefreshRighter

/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;

/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;

/** 隐藏刷新状态的文字 */
@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;

@end
