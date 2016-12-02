//
//  CloudAlbumUIProtocol.h
//  JaneDemo
//
//  Created by 芏小川 on 2016/11/30.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@protocol CloudAlbumUIProtocol <NSObject>

@required
+(UIBlurEffect *)topBar;
+ (UIImage *)backButtonImage;
+ (UIColor *)titleColor;
+ (UIColor *)backgroundColor;

#pragma mark - LocalAlbum

//noticeView
+ (UIColor *)LocalAlbumListViewController_noticeView_backgoundColor;
+ (UIFont *)LocalAlbumListViewController_noticeView_messageLabelFont;
+ (UIColor *)LocalAlbumListViewController_noticeView_messageLabelTextColor;

//selectAllBtn
+ (UIFont *)LocalAlbumDetailViewController_selectAllButton_Font;
+ (UIColor *)LocalAlbumDetailViewController_selectAllButton_TextColor;

//cancleBtn
+ (UIColor *)LocalAlbumListViewController_cancleButton_TextColor;

//bottomView
+ (UIColor *)LocalAlbumListViewController_bottomView_backgroundColor;
+ (UIFont *)LocalAlbumListViewController_bottomView_showSelectedImageViewNumberLabel_textFont;
+ (UIColor *)LocalAlbumListViewController_bottomView_showSelectedImageViewNumberLabel_textColor;
+ (UIImage *)LocalAlbumListViewController_bottomView_uploadButton_backgroundImage;
+ (UIImage *)LocalAlbumListViewController_bottomView_uploadButton_backgroundImage_default;
+ (UIFont *)LocalAlbumListViewController_bottomView_uploadButton_textFont;
+ (UIColor *)LocalAlbumListViewController_bottomView_uploadButton_textColor;

//LocalALbumListCellLbl
+ (UIColor *)LocalAlbumController_cell_nameLblAndNumberLbl_textColor;


#pragma mark - CloudAlbum

/*
 *  CloudAlbunListViewController
**/
+ (UIImage *)CloudAlbumListViewController_settingButtonImage;
+ (UIImage *)CloudAlbumListViewController_addAlbumImage;
+ (UIImage *)CloudAlbumListViewController_createAlbumButtonImage;
+ (UIImage *)CloudAlbumListViewController_placeholderImage;
+ (UIColor *)CloudAlbumListViewController_cell_nameLabel_textColor;
+ (UIColor *)CloudAlbumListViewController_noAlbumView_tipTextClolor;

/**
*  CloudAlbunDetailViewController
 **/
+ (UIColor *)CloudAlbumDetailViewController_headView_backgroundColor;
+ (UIColor *)CloudAlbumDetailViewController_headView_showTimeLabel_textColor;
+ (UIFont *)CloudAlbumDetailViewController_headView_showTimeLabel_textFont;

//无图片时UI
+ (UIFont *)CloudAlbumDetailViewController_noImage_tipLabel_textFont;
+ (UIColor *)CloudAlbumDetailViewController_noImage_tipLabel_textColor;
+ (UIFont *)CloudAlbumDetailViewController_noImage_uploadButton_textFont;
+ (UIImage *)CloudAlbumDetailViewController_noImage_uploadButton_backgroundImage;
+ (UIImage *)CloudAlbumDetailViewController_noImage_uploadButton_contentImage;
+ (UIColor *)CloudAlbumDetailViewController_noImage_uploadButton_textColor;




@end
