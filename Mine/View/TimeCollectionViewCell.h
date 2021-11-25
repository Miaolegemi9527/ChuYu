//
//  TimeCollectionViewCell.h
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeModel.h"

@interface TimeCollectionViewCell : UICollectionViewCell


@property(nonatomic,assign)CGFloat h;
//赋值
-(void)configureTimeTabelCellWithTimeModel:(TimeModel *)time;


@end
