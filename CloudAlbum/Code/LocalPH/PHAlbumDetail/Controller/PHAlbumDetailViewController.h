//
//  PickerViewController.h
//  PrintPhotoInfo
//
//  Created by 芏小川 on 16/11/15.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoAblumList.h"
#import "BaseViewController.h"

@interface PHAlbumDetailViewController : BaseViewController

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,retain) NSArray *AllMsgArr;
@property (nonatomic,assign) NSInteger albumListNum;

@end
