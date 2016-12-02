//
//  PickerCollectionViewCell.m
//  PrintPhotoInfo
//
//  Created by 芏小川 on 16/11/15.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "PHAlbumDetailCollectionViewCell.h"

@implementation PHAlbumDetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        self.contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        self.contentImgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.contentImgView];
        
        _choiceView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
//        self.choiceView.backgroundColor = [UIColor cyanColor];
//        _choiceView.image = [UIImage imageNamed:@"jane_choiceImg"];
        _choiceView.hidden = YES;
        _choiceView.layer.borderWidth = 3.0;
        _choiceView.layer.borderColor = [UIColor yellowColor].CGColor;
        [self.contentImgView addSubview:_choiceView];
        
    }
    
    return self;
}
 
@end
