//
//  CAModel.h
//  CloudPhoto
//
//  Created by 芏小川 on 2016/11/24.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAModel : NSObject

@property (nonatomic,retain) NSString *coverImgUrl;
@property (nonatomic,retain) NSString *folderId;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString* photoCount;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
