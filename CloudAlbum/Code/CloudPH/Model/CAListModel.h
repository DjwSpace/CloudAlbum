//
//  CAListModel.h
//  CloudPhoto
//
//  Created by 芏小川 on 2016/11/24.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAListModel : NSObject

@property (nonatomic,retain) NSArray *imgData;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
