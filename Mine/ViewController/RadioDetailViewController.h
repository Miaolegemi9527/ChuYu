//
//  RadioDetailViewController.h
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioDetailViewController : UIViewController

//传入电台id
@property(nonatomic,strong)NSString *radioidStr;
//传入电台封面（做背景）
@property(nonatomic,strong)NSString *coverimgStr;

@end
