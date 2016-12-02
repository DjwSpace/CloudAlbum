//
//  CAListModel.m
//  CloudPhoto
//
//  Created by 芏小川 on 2016/11/24.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "CAListModel.h"

@implementation CAListModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        self.imgData = dic[@"img_data"];
    }
    return self;
}

@end
