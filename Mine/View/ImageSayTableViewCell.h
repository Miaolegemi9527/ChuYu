//
//  ImageSayTableViewCell.h
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSayModel2.h"

@interface ImageSayTableViewCell : UITableViewCell

//图片
@property(nonatomic,retain)UIImageView *imageV;
//赋值
-(void)configureImageSayCellWithImageSayModel:(ImageSayModel2 *)imageSay;


@end
