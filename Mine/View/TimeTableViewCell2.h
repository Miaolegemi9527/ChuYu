//
//  TimeTableViewCell2.h
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTableModel.h"

@interface TimeTableViewCell2 : UITableViewCell

//便于添加长按图片手势
@property(nonatomic,retain)UIImageView *coverView;
//赋值
-(void)configureTimeTabelCell2WithTimeTableModel:(TimeTableModel *)time;

@end
