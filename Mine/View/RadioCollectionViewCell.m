//
//  RadioCollectionViewCell.m
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "RadioCollectionViewCell.h"

@interface RadioCollectionViewCell ()

@property(nonatomic,retain)UIImageView *radioCoverView;
@property(nonatomic,retain)UILabel *radioNameLabel;
@property(nonatomic,retain)UILabel *radioAuthorLabel;
@property(nonatomic,retain)UILabel *radioInfoLabel;

@end

@implementation RadioCollectionViewCell

//用懒加载的方式初始化
//懒加载 重写每个控件的get方法 只有在用的时候会初始化 只初始化一次 不用不初始化 大大减少系统内存的占用量
-(UIImageView *)radioCoverView
{
    if (!_radioCoverView) {
        self.radioCoverView = [[UIImageView alloc] initWithFrame:CGRectMake4((WIDTH-50-80)/2, 10, 80, 80)];
        _radioCoverView.layer.cornerRadius = 40*SCALE_Y;
        _radioCoverView.layer.masksToBounds = YES;
        //_radioCoverView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_radioCoverView];
    }
    return _radioCoverView;
}
-(UILabel *)radioNameLabel
{
    if (!_radioNameLabel) {
        self.radioNameLabel = [[UILabel alloc] initWithFrame:CGRectMake2(0, CGRectGetMaxY(self.radioCoverView.frame)+10, 0, 15)];
        _radioNameLabel.numberOfLines = 0;
        [_radioNameLabel sizeToFit];
        _radioNameLabel.font = [UIFont boldSystemFontOfSize:13];
        _radioNameLabel.textColor = [UIColor grayColor];
        //_radioNameLabel.textAlignment = NSTextAlignmentCenter;
        //_radioNameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_radioNameLabel];
    }
    return _radioNameLabel;
}
-(UILabel *)radioAuthorLabel
{
    if (!_radioAuthorLabel) {
        self.radioAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake2(5, CGRectGetMaxY(self.radioNameLabel.frame)+10, WIDTH-60, 15)];
        _radioAuthorLabel.font = [UIFont systemFontOfSize:12];
        _radioAuthorLabel.textAlignment = NSTextAlignmentCenter;
        //_radioAuthorLabel.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:_radioAuthorLabel];
    }
    return _radioAuthorLabel;
}
-(UILabel *)radioInfoLabel
{
    if (!_radioInfoLabel) {
        self.radioInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake2(5, CGRectGetMaxY(self.radioAuthorLabel.frame)+10, WIDTH-60, 15)];
        _radioInfoLabel.font = [UIFont systemFontOfSize:12];
        _radioInfoLabel.textAlignment = NSTextAlignmentCenter;
        //UILabel 设置过长文本中间为省略号
        _radioInfoLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _radioInfoLabel.textColor = [UIColor grayColor];
        //_radioInfoLabel.backgroundColor = [UIColor brownColor];
        [self.contentView addSubview:_radioInfoLabel];
    }
    return _radioInfoLabel;
}

-(void)configureRadioCollectionViewCell:(RadioModel *)radio
{
    //作者
    NSString *authorStr = radio.alllistUserinfoDict[@"uname"];
    [self.radioCoverView sd_setImageWithURL:[NSURL URLWithString:radio.alllistCoverimgStr] placeholderImage:[UIImage imageNamed:@"holder"]];
    self.radioNameLabel.text = radio.alllistTitleStr;
    self.radioInfoLabel.text = radio.alllistDescStr;
    self.radioAuthorLabel.text = authorStr;

    NSInteger xx = (WIDTH-50-80)*SCALE_X;//图片不超界的最大滚动范围
    CGFloat mx = arc4random()%xx;
    [UIView animateWithDuration:4.0 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _radioCoverView.frame = CGRectMake(mx, 10*SCALE_Y, 80*SCALE_Y, 80*SCALE_Y);
    } completion:^(BOOL finished) {
    }];
    //CGFloat length = self.radioNameLabel.frame.size.width;//标题的长度
    CGFloat length = radio.alllistTitleStr.length*14;
    NSInteger xx2 = (WIDTH-50-length)*SCALE_X;//标题不超界的最大滚动范围
    CGFloat mx2 = arc4random()%xx2;
    [UIView animateWithDuration:4.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.radioNameLabel.frame = CGRectMake(mx2, CGRectGetMaxY(self.radioCoverView.frame)+10, 0, 15*SCALE_Y);
        _radioNameLabel.numberOfLines = 0;
        [_radioNameLabel sizeToFit];
        self.radioAuthorLabel.frame = CGRectMake2(5, CGRectGetMaxY(self.radioNameLabel.frame)+10, WIDTH-60, 15);
        self.radioInfoLabel.frame = CGRectMake2(5, CGRectGetMaxY(self.radioAuthorLabel.frame)+10, WIDTH-60, 15);
    } completion:^(BOOL finished) {
    }];
}


@end
