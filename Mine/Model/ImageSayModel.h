//
//  ImageSayModel.h
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSayModel : NSObject

@property(nonatomic,assign)NSInteger albumId;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *introString;
@property(nonatomic,strong)NSString *imgString;
@property(nonatomic,strong)NSString *titleString;

@property(nonatomic,assign)CGSize imageSize;

+(instancetype)imageSayWithDictionary:(NSDictionary *)dict;

@end
