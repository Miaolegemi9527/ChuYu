//
//  TimeTableViewCell2.m
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "TimeTableViewCell2.h"

@interface TimeTableViewCell2 ()

@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *contentLabel;

@end

@implementation TimeTableViewCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createThisPageUI];
    }
    return self;
}
-(void)createThisPageUI
{
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    
    self.coverView = [[UIImageView alloc] init];
    [self.contentView addSubview:_coverView];
    
    self.contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_contentLabel];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake1(15, 20, WIDTH-30, 20);
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textColor = [UIColor grayColor];
    [self.titleLabel sizeToFit];
    //_titleLabel.backgroundColor = [UIColor orangeColor];
    
    self.coverView.frame = CGRectMake2(15, CGRectGetMaxY(self.titleLabel.frame)+10*SCALE_Y, WIDTH-30, 170);
    //_coverView.backgroundColor = [UIColor redColor];
    _coverView.layer.cornerRadius = 5;
    _coverView.layer.masksToBounds = YES;
    
    self.contentLabel.frame = CGRectMake2(15, CGRectGetMaxY(self.coverView.frame)+10*SCALE_Y, WIDTH-15*2, 15);
    _contentLabel.font = [UIFont systemFontOfSize:12];
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.numberOfLines = 0;
    [_contentLabel sizeToFit];
    //_contentLabel.backgroundColor = [UIColor purpleColor];
}
-(void)configureTimeTabelCell2WithTimeTableModel:(TimeTableModel *)time
{
    self.titleLabel.text = time.titleStr;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:time.coverimgStr]];
    self.contentLabel.text = time.contentStr;


}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
