//
//  PHManager.h
//  PrintPhotoInfo
//
//  Created by 芏小川 on 16/11/18.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PHManager : NSObject

+(instancetype)defaultManager;

/**
 * 存储选择上传图片信息
 */
@property (nonatomic,retain) NSMutableArray *selectedMsgArr;
@property (nonatomic,retain) NSMutableArray *PhotoMsgArr;
@property (nonatomic,assign) NSInteger allSelectImgNum;

/**
 * 提示信息topbar
 */
@property (nonatomic,retain) UIView *noticeView;
@property (nonatomic,retain) UILabel *msgLbl;
@property (nonatomic,retain) NSString *albumTitleStr;
@property (nonatomic,assign) BOOL isShowView;

/**
 * 上传照片计数View
 */
@property (nonatomic,retain) UIView *bottomView;
@property (nonatomic,retain) UILabel *imgNumLbl;
@property (nonatomic,retain) UIButton *uploadBtn;


@end
