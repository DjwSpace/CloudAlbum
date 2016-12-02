//
//  CAImgDataModel.h
//  CloudPhoto
//
//  Created by 芏小川 on 2016/11/24.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAImgDataModel : NSObject

@property (nonatomic,retain) NSString *addDate;
@property (nonatomic,retain) NSString *coverImgUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
