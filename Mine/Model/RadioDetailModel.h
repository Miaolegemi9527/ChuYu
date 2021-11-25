//
//  RadioDetailModel.h
//  Mine
//
//  Created by 廖毅 on 15/12/24.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioDetailModel : NSObject

@property(nonatomic,strong)NSString *coverimgStr;
@property(nonatomic,strong)NSString *musicUrlStr;
@property(nonatomic,strong)NSString *tingidStr;
@property(nonatomic,strong)NSString *titleStr;


//赋值
+(instancetype)radioDetailModelWithDictionary:(NSDictionary *)Dict;

@end
