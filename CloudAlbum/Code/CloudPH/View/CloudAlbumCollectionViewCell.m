//
//  CloudAlbumCollectionViewCell.m
//  CloudPhoto
//
//  Created by 芏小川 on 16/11/21.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "CloudAlbumCollectionViewCell.h"
#import "ToolMacroDefine.h"
#import "PHManager.h"
#import "ZLPhotoAblumList.h"
#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
#import "BCANetWorkAPIRequest.h"
#import "BCANetWorkAPIConstant.h"
#import "CloudAlbumUI.h"

@implementation CloudAlbumCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [ super initWithFrame:frame];
    if (self) {
        //拉伸图片(9 slicing)
        UIImage*backgroundImage = [UIImage imageNamed:@"jane_album_topview"];
        backgroundImage= [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.2, 3, 0.2, 3) resizingMode:UIImageResizingModeStretch];
        self.topImgView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self.topImgView setFrame:CGRectMake(2, 2, (CGRectGetWidth(self.frame)-4), 6)];

        [self addSubview:self.topImgView];
        
        self.contentImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,10, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        [self addSubview:self.contentImg];
        
        self.numLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, (CGRectGetWidth(self.frame)-5), 50, 10)];
        self.numLbl.textColor = [UIColor whiteColor];
        self.numLbl.textAlignment = NSTextAlignmentLeft;
        self.numLbl.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.numLbl];
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetWidth(self.frame) + 16), CGRectGetWidth(self.frame), 13)];
        self.nameLbl.font = [UIFont systemFontOfSize:13];
        self.nameLbl.textColor = [CloudAlbumUI CloudAlbumListViewController_cell_nameLabel_textColor];
        self.nameLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLbl];
    }
    
    return self;
}


@end
