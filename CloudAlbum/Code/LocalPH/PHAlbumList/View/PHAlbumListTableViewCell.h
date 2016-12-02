//
//  ListTableViewCell.h
//  PrintPhotoInfo
//
//  Created by 芏小川 on 16/11/17.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHAlbumListTableViewCell : UITableViewCell

@property (nonatomic,retain) UIImageView *thumbnail;
@property (nonatomic,retain) UILabel *albumNameLbl;
@property (nonatomic,retain) UILabel *albumImgNumLbl;
@property (nonatomic,retain) UIImageView *toNextImgView;

@end
