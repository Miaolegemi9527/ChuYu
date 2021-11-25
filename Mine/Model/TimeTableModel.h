//
//  TimeTableModel.h
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTableModel : NSObject

@property(nonatomic,assign)NSInteger typeId;
@property(nonatomic,retain)NSString *typenameStr;
@property(nonatomic,retain)NSString *contentStr;
@property(nonatomic,retain)NSString *coverimgStr;
@property(nonatomic,retain)NSString *idStr;
@property(nonatomic,retain)NSString *nameStr;
@property(nonatomic,retain)NSString *titleStr;

//赋值
+(instancetype)timeTableWithDictionary:(NSDictionary *)dict;

@end
