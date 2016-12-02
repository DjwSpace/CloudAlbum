//
//  PHManager.m
//  PrintPhotoInfo
//
//  Created by 芏小川 on 16/11/18.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "PHManager.h"
#import "ToolMacroDefine.h"

@implementation PHManager

+(instancetype)defaultManager{
    static dispatch_once_t onceToken;
    static PHManager *phManager;
    dispatch_once(&onceToken, ^{
        phManager = [[PHManager alloc] init];
    });
    return phManager;
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.selectedMsgArr = [NSMutableArray array];
        self.PhotoMsgArr = [NSMutableArray array];
        self.allSelectImgNum = 0;
        
        self.noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, VIEW_WIDTH, 32.5)];
        self.msgLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 32.5)];
        self.isShowView = NO;
        self.noticeView.hidden = !self.isShowView;
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-49, VIEW_WIDTH, 49)];
        self.imgNumLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, VIEW_WIDTH/2, 17)];
        self.uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.uploadBtn.frame = CGRectMake(VIEW_WIDTH-110, 0, 100, 49);
        
    }
    return self;
}



@end
