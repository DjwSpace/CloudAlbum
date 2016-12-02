//
//  BaseViewController.m
//  CloudPhoto
//
//  Created by 芏小川 on 16/11/22.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "BaseViewController.h"
#import "CloudAlbumUI.h"
#import "ToolMacroDefine.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

-(void)setNavBar{
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[CloudAlbumUI topBar]];
    
     self.visualEffectView.frame = CGRectMake(0, 0, VIEW_WIDTH, 44);
    [self.view addSubview: self.visualEffectView];
    
    UIImage *backImg = [[CloudAlbumUI backButtonImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.backBtn setFrame:CGRectMake(0.0, 0, 60.0, 44.0)];
    [ self.backBtn addTarget:self action:@selector(tapLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [ self.backBtn setImage:backImg forState:UIControlStateNormal];
    [ self.visualEffectView.contentView addSubview: self.backBtn];
}

-(void)tapLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
