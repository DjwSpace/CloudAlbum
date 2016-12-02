//
//  CAImgDataModel.m
//  CloudPhoto
//
//  Created by 芏小川 on 2016/11/24.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "CAImgDataModel.h"

@implementation CAImgDataModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        self.addDate = dic[@"add_date"];
        self.coverImgUrl = dic[@"cover_img_url"];
    }
    return self;
}

@end
