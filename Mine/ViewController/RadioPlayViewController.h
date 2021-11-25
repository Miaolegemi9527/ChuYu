//
//  RadioPlayViewController.h
//  Mine
//
//  Created by 廖毅 on 15/12/25.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioPlayViewController : UIViewController

@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,strong) NSMutableArray *radioArray;

@property(nonatomic,retain)RadioPlayViewController *rpvc;
@end
