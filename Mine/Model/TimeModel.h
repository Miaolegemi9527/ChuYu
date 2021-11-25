//
//  TimeModel.h
//  Mine
//
//  Created by 廖毅 on 15/12/21.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeModel : NSObject

@property(nonatomic,strong)NSString *coveringStr;
@property(nonatomic,strong)NSString *ennameStr;
@property(nonatomic,strong)NSString *nameStr;
@property(nonatomic,assign)NSInteger type;

+(instancetype)timeModelWithDictionary:(NSDictionary *)dict;

@end
