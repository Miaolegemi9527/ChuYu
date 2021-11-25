//
//  My_MJRefreshRighter.m
//  Galaxy
//
//  Created by lanou on 16/1/11.
//  Copyright © 2016年 9527. All rights reserved.
//

#import "My_MJRefreshRighter.h"

@implementation My_MJRefreshRighter

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) { // 新的父控件
        if (self.hidden == NO) {
            self.scrollView.mj_insetR += self.mj_h;
        }
        // 设置位置
        self.mj_x = _scrollView.mj_contentW;
    } else { // 被移除了
        if (self.hidden == NO) {
            self.scrollView.mj_insetR -= self.mj_w;
        }
    }
}

#pragma mark - 过期方法
- (void)setAppearencePercentTriggerAutoRefresh:(CGFloat)appearencePercentTriggerAutoRefresh
{
    self.triggerAutomaticallyRefreshPercent = appearencePercentTriggerAutoRefresh;
}

- (CGFloat)appearencePercentTriggerAutoRefresh
{
    return self.triggerAutomaticallyRefreshPercent;
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutomaticallyRefreshPercent = 1.0;
    
    // 设置为默认状态
    self.automaticallyRefresh = YES;
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 设置位置
    self.mj_x = self.scrollView.mj_contentW;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state != MJRefreshStateIdle || !self.automaticallyRefresh || self.mj_x == 0) return;
    
    if (_scrollView.mj_insetL + _scrollView.mj_contentW > _scrollView.mj_w) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        if (_scrollView.mj_offsetX >= _scrollView.mj_contentW - _scrollView.mj_w + self.mj_w * self.triggerAutomaticallyRefreshPercent + _scrollView.mj_insetR - self.mj_w) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.x <= old.x) return;
            
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    if (self.state != MJRefreshStateIdle) return;
    
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
        if (_scrollView.mj_insetL + _scrollView.mj_contentW <= _scrollView.mj_w) {  // 不够一个屏幕
            if (_scrollView.mj_offsetX >= - _scrollView.mj_insetR) { // 向上拽
                [self beginRefreshing];
            }
        } else { // 超出一个屏幕
            if (_scrollView.mj_offsetX >= _scrollView.mj_contentW + _scrollView.mj_insetL - _scrollView.mj_w) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (state == MJRefreshStateRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self executeRefreshingCallback];
        });
    }
}

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = MJRefreshStateIdle;
        
        self.scrollView.mj_insetL -= self.mj_w;//一开始便可以上下左右拖拽（这里设置向左拖拽）
    } else if (lastHidden && !hidden) {
        self.scrollView.mj_insetL += self.mj_w;
        
        // 设置位置
        self.mj_x = _scrollView.mj_contentW;
    }
}

@end
