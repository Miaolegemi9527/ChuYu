//
//  ImageSayModel2.m
//  Mine
//
//  Created by 廖毅 on 15/12/17.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "ImageSayModel2.h"

@implementation ImageSayModel2

+(instancetype)imageSay2WithDictionary:(NSDictionary *)dict
{
    ImageSayModel2 *imageSay2 = [[ImageSayModel2 alloc] init];
    //imageSay2.imgString = dict[@"img"];
    //imageSay2.userNameString = dict[@"userName"];
    imageSay2.bigUrlString = dict[@"bigUrl"];
    imageSay2.postTextString = dict[@"postText"];
    imageSay2.tagsString = dict[@"tags"];
    return imageSay2;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
