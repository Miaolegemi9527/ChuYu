//
//  ImageSayModel2.h
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSayModel2 : NSObject

//@property(nonatomic,strong)NSString *imgString;
//@property(nonatomic,strong)NSString *userNameString;
@property(nonatomic,strong)NSString *bigUrlString;
@property(nonatomic,strong)NSString *postTextString;
@property(nonatomic,strong)NSString *tagsString;

+(instancetype)imageSay2WithDictionary:(NSDictionary *)dict;

@end
