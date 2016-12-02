//
//  CloudAlbumDetailCollectionViewCell.m
//  CloudPhoto
//
//  Created by 芏小川 on 16/11/22.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "CloudAlbumDetailCollectionViewCell.h"

@implementation CloudAlbumDetailCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self addSubview:self.contentImg];
    }
    
    return self;
}

@end
