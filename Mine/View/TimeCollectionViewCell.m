//
//  TimeCollectionViewCell.m
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "TimeCollectionViewCell.h"

@interface TimeCollectionViewCell ()<UIScrollViewDelegate>

@property(nonatomic,retain)UIImageView *coverImageView;
@property(nonatomic,retain)UILabel *nameLabel;

@end

@implementation TimeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createThisPageUI];
    }
    return self;
}
-(void)createThisPageUI
{
    self.coverImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_coverImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nameLabel];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.coverImageView.frame = CGRectMake4(40, 10, 120, 120);
    _coverImageView.layer.cornerRadius = 5;
    _coverImageView.layer.masksToBounds = YES;
    
    self.nameLabel.frame = CGRectMake3(CGRectGetMinX(self.coverImageView.frame), CGRectGetMaxY(self.coverImageView.frame)+5, 100, 15);
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textColor = [UIColor grayColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    
}
//赋值
-(void)configureTimeTabelCellWithTimeModel:(TimeModel *)time
{
    self.h = arc4random()%70+80;
    CGFloat x = arc4random()%80;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:time.coveringStr] placeholderImage:[UIImage imageNamed:@"holder"]];
    self.nameLabel.text = time.ennameStr;
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _coverImageView.frame = CGRectMake4(x, 10, _h, _h);
        _nameLabel.frame = CGRectMake2(CGRectGetMinX(self.coverImageView.frame), CGRectGetMaxY(self.coverImageView.frame)+5, _h, 15);
    } completion:^(BOOL finished) {
    }];
    
    //_coverImageView.frame = CGRectMake(10, 10, _h, _h);
    //self.nameLabel.text = time.ennameStr;
    //_nameLabel.frame = CGRectMake(CGRectGetMinX(self.coverImageView.frame), CGRectGetMaxY(self.coverImageView.frame)+5, _h, 20);
}


@end
