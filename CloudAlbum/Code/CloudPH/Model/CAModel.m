//
//  CAModel.m
//  CloudPhoto
//
//  Created by 芏小川 on 2016/11/24.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "CAModel.h"

@implementation CAModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{

    self = [super init];
    if (self) {
        self
        .name = dic[@"name"];
        self.photoCount = dic[@"photo_count"];
        self.coverImgUrl = dic[@"cover_img_url"];
        self.folderId = dic[@"folder_id"];
    }
    return self;
}


@end
