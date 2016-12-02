//
//  ListTableViewCell.m
//  PrintPhotoInfo
//
//  Created by 芏小川 on 16/11/17.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "PHAlbumListTableViewCell.h"
#import "ToolMacroDefine.h"
#import "CloudAlbumUI.h"

@implementation PHAlbumListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.thumbnail =
        [[UIImageView alloc] initWithFrame:CGRectMake(15, 9,42 , 42)];
        [self addSubview: self.thumbnail];
        
        self.albumNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(72, 15, 100, 15)];
        self.albumNameLbl.font = [UIFont systemFontOfSize:15];
        self.albumNameLbl.textColor = [CloudAlbumUI LocalAlbumController_cell_nameLblAndNumberLbl_textColor];
        [self addSubview:self.albumNameLbl];
        
        self.albumImgNumLbl = [[UILabel alloc]initWithFrame:CGRectMake(72, 30, 50, 15)];
        self.albumImgNumLbl.font = [UIFont systemFontOfSize:13];
        self.albumImgNumLbl.textColor = [CloudAlbumUI LocalAlbumController_cell_nameLblAndNumberLbl_textColor];

        [self addSubview:self.albumImgNumLbl];
        
        self.toNextImgView = [[UIImageView alloc] initWithFrame:CGRectMake((VIEW_WIDTH-15-8), 22, 8, 16)];
        self.toNextImgView.image = [UIImage imageNamed:@"jane_next"];
        [self addSubview:self.toNextImgView];
    }
    
    return self;
}

@end
