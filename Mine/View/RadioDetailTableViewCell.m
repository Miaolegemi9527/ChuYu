//
//  RadioDetailTableViewCell.m
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioDetailTableViewCell.h"

@interface RadioDetailTableViewCell ()

@property(nonatomic,retain)UIImageView *coverimgView;
@property(nonatomic,retain)UILabel *titleLabel;

@end

@implementation RadioDetailTableViewCell


//用懒加载的方式初始化
//懒加载 重写每个控件的get方法 只有在用的时候会初始化 只初始化一次 不用不初始化 大大减少系统内存的占用量
-(UIImageView *)coverimgView
{
    if (!_coverimgView) {
        self.coverimgView = [[UIImageView alloc] initWithFrame:CGRectMake4(10, 10, 60, 60)];
        _coverimgView.layer.cornerRadius = 30*SCALE_Y;
        _coverimgView.layer.masksToBounds = YES;
        //_coverimgView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.coverimgView];
    }
    return _coverimgView;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake1(80, 30, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DAN"] isEqualToString:@"day"])
        {
            _titleLabel.textColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.6];
        }
        else
        {
            _titleLabel.textColor = [UIColor grayColor];
        }
        _titleLabel.highlightedTextColor = [UIColor blackColor];
        //_titleLabel.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

//赋值
-(void)configureRadioDetailTableViewCellWithRadioDetailModel:(RadioDetailModel *)RadioDetailModel
{
    [self.coverimgView sd_setImageWithURL:[NSURL URLWithString:RadioDetailModel.coverimgStr] placeholderImage:[UIImage imageNamed:@"holder"]];
    self.titleLabel.text = RadioDetailModel.titleStr;
    
    CGFloat x = arc4random()%60;
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.coverimgView.frame = CGRectMake(x, 10*SCALE_Y, 60*SCALE_Y, 60*SCALE_Y);
        self.titleLabel.frame = CGRectMake1(x+70, 30, 200, 20);
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
    } completion:^(BOOL finished) {
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
