//
//  WelcomeView.m
//  Mine
//
//  Created by 廖毅 on 15/12/19.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "WelcomeView.h"

@interface WelcomeView ()

@property(nonatomic,retain)UILabel *renLabel;
@property(nonatomic,retain)UILabel *shengLabel;
@property(nonatomic,retain)UILabel *ruoLabel;
@property(nonatomic,retain)UILabel *zhiLabel;
@property(nonatomic,retain)UILabel *ruLabel;
@property(nonatomic,retain)UILabel *chuLabel;
@property(nonatomic,retain)UILabel *jian0Label;

@property(nonatomic,retain)UILabel *henLabel;
@property(nonatomic,retain)UILabel *gaoLabel;
@property(nonatomic,retain)UILabel *xingLabel;
@property(nonatomic,retain)UILabel *yuLabel;
@property(nonatomic,retain)UILabel *jianLabel;
@property(nonatomic,retain)UILabel *ni2Label;
@property(nonatomic,retain)UILabel *zaiLabel;
@property(nonatomic,retain)UILabel *zheLabel;
@property(nonatomic,retain)UILabel *meiLabel;
@property(nonatomic,retain)UILabel *hao2Label;
@property(nonatomic,retain)UILabel *deLabel;
@property(nonatomic,retain)UILabel *shiLabel;
@property(nonatomic,retain)UILabel *guangLabel;
@property(nonatomic,retain)UILabel *LiLabel;

//RGB
@property(nonatomic,assign)NSInteger r;
@property(nonatomic,assign)NSInteger g;
@property(nonatomic,assign)NSInteger b;

@end

@implementation WelcomeView


//1、重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpWelcomeView];
    }
    return self;
}
//写布局文件
-(void)setUpWelcomeView
{
    //控件初始化
    self.renLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%780, arc4random()%400, 30, 30)];
    _renLabel.text = @"人";
    _renLabel.textColor = [UIColor grayColor];
    //_renLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _renLabel.textAlignment = NSTextAlignmentCenter;
    _renLabel.alpha = 0;
    _renLabel.font = [UIFont systemFontOfSize:20];
    self.shengLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%500, arc4random()%800, 30, 30)];
    _shengLabel.text = @"生";
    _shengLabel.textColor = [UIColor grayColor];
    //_shengLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _shengLabel.textAlignment = NSTextAlignmentCenter;
    _shengLabel.alpha = 0;
    _shengLabel.font = [UIFont systemFontOfSize:20];
    self.ruoLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%450, arc4random()%820, 30, 30)];
    _ruoLabel.alpha = 0;
    _ruoLabel.text = @"若";
    _ruoLabel.textColor = [UIColor grayColor];
    //_ruoLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _ruoLabel.textAlignment = NSTextAlignmentCenter;
    _ruoLabel.font = [UIFont systemFontOfSize:20];
    self.zhiLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%520, arc4random()%852, 30, 30)];
    _zhiLabel.alpha = 0;
    _zhiLabel.text = @"只";
    _zhiLabel.textColor = [UIColor grayColor];
    //_zhiLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _zhiLabel.textAlignment = NSTextAlignmentCenter;
    _zhiLabel.font = [UIFont systemFontOfSize:20];
    self.ruLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%521, arc4random()%950, 30, 30)];
    _ruLabel.text = @"如";
    _ruLabel.textColor = [UIColor grayColor];
    //_ruLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _ruLabel.textAlignment = NSTextAlignmentCenter;
    _ruLabel.alpha = 0;
    _ruLabel.font = [UIFont systemFontOfSize:20];
    self.chuLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%675, arc4random()%854, 30, 30)];
    _chuLabel.text = @"初";
    _chuLabel.textAlignment = NSTextAlignmentCenter;
    _chuLabel.font = [UIFont systemFontOfSize:20];
    _chuLabel.alpha = 0;
    self.jian0Label = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%854, arc4random()%892, 30, 30)];
    _jian0Label.text = @"见";
    _jian0Label.textAlignment = NSTextAlignmentCenter;
    _jian0Label.font = [UIFont systemFontOfSize:20];
    _jian0Label.alpha = 0;
    
    [self addSubview:_renLabel];
    [self addSubview:_shengLabel];
    [self addSubview:_ruoLabel];
    [self addSubview:_zhiLabel];
    [self addSubview:_ruLabel];
    [self addSubview:_chuLabel];
    [self addSubview:_jian0Label];
    
    self.henLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%500+500, arc4random()%800, 30, 30)];
    _henLabel.text = @"很";
    _henLabel.textAlignment = NSTextAlignmentCenter;
    _henLabel.font = [UIFont systemFontOfSize:20];
    _henLabel.alpha = 0;
    _henLabel.textColor = [UIColor grayColor];
    self.gaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%510, arc4random()%900, 30, 30)];
    _gaoLabel.text = @"高";
    _gaoLabel.textAlignment = NSTextAlignmentCenter;
    _gaoLabel.font = [UIFont systemFontOfSize:20];
    _gaoLabel.alpha = 0;
    _gaoLabel.textColor = [UIColor grayColor];
    self.xingLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%600, arc4random()%850, 30, 30)];
    _xingLabel.text = @"兴";
    _xingLabel.textAlignment = NSTextAlignmentCenter;
    _xingLabel.font = [UIFont systemFontOfSize:20];
    _xingLabel.alpha = 0;
    _xingLabel.textColor = [UIColor grayColor];
    self.yuLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%450, arc4random()%860, 40, 40)];
    _yuLabel.text = @"遇";
    _yuLabel.textAlignment = NSTextAlignmentCenter;
    _yuLabel.font = [UIFont boldSystemFontOfSize:30];
    _yuLabel.alpha = 0;
    self.jianLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%550, arc4random()%1000, 40, 40)];
    _jianLabel.text = @"见";
    _jianLabel.textAlignment = NSTextAlignmentCenter;
    _jianLabel.font = [UIFont boldSystemFontOfSize:30];
    _jianLabel.alpha = 0;
    self.ni2Label = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%600, arc4random()%925, 30, 30)];
    _ni2Label.text = @"你";
    _ni2Label.textAlignment = NSTextAlignmentCenter;
    _ni2Label.font = [UIFont systemFontOfSize:20];
    _ni2Label.alpha = 0;
    _ni2Label.textColor = [UIColor grayColor];
    self.zaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%700, arc4random()%700, 30, 30)];
    _zaiLabel.text = @"在";
    _zaiLabel.textAlignment = NSTextAlignmentCenter;
    _zaiLabel.font = [UIFont systemFontOfSize:20];
    _zaiLabel.alpha = 0;
    _zaiLabel.textColor = [UIColor grayColor];
    self.zheLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%543, arc4random()%777, 30, 30)];
    _zheLabel.text = @"这";
    _zheLabel.textAlignment = NSTextAlignmentCenter;
    _zheLabel.font = [UIFont systemFontOfSize:20];
    _zheLabel.alpha = 0;
    _zheLabel.textColor = [UIColor grayColor];
    self.meiLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%651, arc4random()%689, 40, 40)];
    _meiLabel.text = @"美";
    _meiLabel.textAlignment = NSTextAlignmentCenter;
    _meiLabel.font = [UIFont boldSystemFontOfSize:30];
    _meiLabel.alpha = 0;
    self.hao2Label = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%788, arc4random()%142, 40, 40)];
    _hao2Label.text = @"好";
    _hao2Label.textAlignment = NSTextAlignmentCenter;
    _hao2Label.font = [UIFont boldSystemFontOfSize:30];
    _hao2Label.alpha = 0;
    self.deLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%651, arc4random()%985, 30, 30)];
    _deLabel.textAlignment = NSTextAlignmentCenter;
    _deLabel.font = [UIFont systemFontOfSize:20];
    _deLabel.text = @"的";
    _deLabel.alpha = 0;
    _deLabel.textColor = [UIColor grayColor];
    self.shiLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%556, arc4random()%987, 40, 40)];
    _shiLabel.text = @"时";
    _shiLabel.textAlignment = NSTextAlignmentCenter;
    _shiLabel.font = [UIFont boldSystemFontOfSize:30];
    _shiLabel.alpha = 0;
    self.guangLabel = [[UILabel alloc]initWithFrame:CGRectMake(arc4random()%845, arc4random()%1520, 40, 40)];
    _guangLabel.text = @"光";
    _guangLabel.textAlignment = NSTextAlignmentCenter;
    _guangLabel.font = [UIFont boldSystemFontOfSize:30];
    _guangLabel.alpha = 0;
    self.LiLabel = [[UILabel alloc] initWithFrame:CGRectMake(arc4random()%475, arc4random()%999, 30, 30)];
    _LiLabel.text = @"里";
    _LiLabel.textAlignment = NSTextAlignmentCenter;
    _LiLabel.font = [UIFont systemFontOfSize:20];
    _LiLabel.alpha = 0;
    _LiLabel.textColor = [UIColor grayColor];
    
    
    [self addSubview:_henLabel];
    [self addSubview:_gaoLabel];
    [self addSubview:_xingLabel];
    [self addSubview:_yuLabel];
    [self addSubview:_jianLabel];
    [self addSubview:_ni2Label];
    [self addSubview:_zaiLabel];
    [self addSubview:_zheLabel];
    [self addSubview:_meiLabel];
    [self addSubview:_hao2Label];
    [self addSubview:_deLabel];
    [self addSubview:_shiLabel];
    [self addSubview:_guangLabel];
    [self addSubview:_LiLabel];
}

-(void)willMoveToWindow:(UIWindow *)newWindow
{
    //出现
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.renLabel.frame = CGRectMake((WIDTH-30)/2, (HEIGHT-30*7-10*6)/2, 30, 30);
        [_renLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:2.2 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shengLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.renLabel.frame)+10, 30, 30);
        [_shengLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:2.4 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:2.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.ruoLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.shengLabel.frame)+10, 30, 30);
        [_ruoLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:2.6 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.zhiLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.ruoLabel.frame)+10, 30, 30);
        [_zhiLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:2.8 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.ruLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.zhiLabel.frame)+10, 30, 30);
        [_ruLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.chuLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.ruLabel.frame)+10, 30, 30);
        [_chuLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:3.2 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.jian0Label.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.chuLabel.frame)+10, 30, 30);
        [_jian0Label setAlpha:1];
    } completion:^(BOOL finished) {
        //消失
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.renLabel.frame = CGRectMake((WIDTH-30)/2, (HEIGHT-30*7-10*6)/2, 30, 30);
            [_renLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.shengLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.renLabel.frame)+10, 30, 30);
            [_shengLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.8 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:2.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.ruoLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.shengLabel.frame)+10, 30, 30);
            [_ruoLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.6 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.zhiLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.ruoLabel.frame)+10, 30, 30);
            [_zhiLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.8 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.ruLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.zhiLabel.frame)+10, 30, 30);
            [_ruLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.6 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.chuLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.ruLabel.frame)+10, 30, 30);
            [_chuLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.2 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.jian0Label.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.chuLabel.frame)+10, 30, 30);
            [_jian0Label setAlpha:0];
        } completion:^(BOOL finished) {
            
            //出现2 一
            [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.yuLabel.frame = CGRectMake((WIDTH-40*3-10*2)/2, (HEIGHT-40*2-20)/2, 40, 40);
                [_yuLabel setAlpha:1];
                self.yuLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:1.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.jianLabel.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame), CGRectGetMaxY(self.yuLabel.frame)+20, 40, 40);
                [_jianLabel setAlpha:1];
                self.jianLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:1.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.ni2Label.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame)+5, CGRectGetMaxY(self.jianLabel.frame)+20, 30, 30);
                [_ni2Label setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.xingLabel.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame)+5, CGRectGetMinY(self.yuLabel.frame)-20-30, 30, 30);
                [_xingLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:1.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.gaoLabel.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame)+5, CGRectGetMinY(self.yuLabel.frame)-20*2-30*2, 30, 30);
                [_gaoLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.henLabel.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame)+5, CGRectGetMinY(self.yuLabel.frame)-20*3-30*3, 30, 30);
                [_henLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            //二
            [UIView animateWithDuration:2.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.meiLabel.frame = CGRectMake((WIDTH-40*3-10*2)/2+40+20, (HEIGHT-40*2-20)/2, 40, 40);
                [_meiLabel setAlpha:1];
                self.meiLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.hao2Label.frame = CGRectMake(CGRectGetMinX(self.meiLabel.frame), CGRectGetMaxY(self.meiLabel.frame)+20, 40, 40);
                [_hao2Label setAlpha:1];
                self.hao2Label.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.2 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.deLabel.frame = CGRectMake(CGRectGetMinX(self.meiLabel.frame)+5, CGRectGetMaxY(self.hao2Label.frame)+20, 30, 30);
                [_deLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.zheLabel.frame = CGRectMake(CGRectGetMinX(self.meiLabel.frame)+5, CGRectGetMinY(self.meiLabel.frame)-20-30, 30, 30);
                [_zheLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.zaiLabel.frame = CGRectMake(CGRectGetMinX(self.meiLabel.frame)+5, CGRectGetMinY(self.meiLabel.frame)-20*2-30*2, 30, 30);
                [_zaiLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            //三
            [UIView animateWithDuration:2.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.shiLabel.frame = CGRectMake((WIDTH-40*3-10*2)/2+(40+20)*2, (HEIGHT-40*2-20)/2, 40, 40);
                [_shiLabel setAlpha:1];
                self.shiLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.guangLabel.frame = CGRectMake(CGRectGetMinX(self.shiLabel.frame), CGRectGetMaxY(self.shiLabel.frame)+20, 40, 40);
                [_guangLabel setAlpha:1];
                self.guangLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.2 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.LiLabel.frame = CGRectMake(CGRectGetMinX(self.shiLabel.frame)+5, CGRectGetMaxY(self.guangLabel.frame)+20, 30, 30);
                [_LiLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
        }];
    }];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
