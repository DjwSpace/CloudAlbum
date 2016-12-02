//
//  ViewController.m
//  PrintPhotoInfo
//
//  Created by 芏小川 on 16/11/15.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "MainViewController.h"
#import "PHManager.h"
#import "ZLPhotoAblumList.h"
#import "CloudAlbumViewController.h"
#import "PHAlbumListViewController.h"
#import "CloudAlbumUI.h"
#import "ToolMacroDefine.h"


@interface MainViewController ()

@property (nonatomic,retain) UILabel *titleLbl;

@end

@implementation MainViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [CloudAlbumUI backgroundColor];
    
    [self createBtnWithFrame:CGRectMake(58, 200, 100, 100) title:@"打开相册" bgColor:[UIColor greenColor] num:0];
    [self createBtnWithFrame:CGRectMake(216, 200, 100, 100) title:@"打开云相册" bgColor:[UIColor blueColor] num:1];
    self.backBtn.hidden = YES;
    [self.visualEffectView.contentView addSubview:self.titleLbl];

    [self addNotificationWithName:@"print"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = YES;
    [PHManager defaultManager].bottomView.hidden = YES;
    self.titleLbl.frame = CGRectMake(0, 0,VIEW_WIDTH , 44);
    [[PHManager defaultManager].selectedMsgArr removeAllObjects];
    [PHManager defaultManager].allSelectImgNum = 0;
}

-(void)dealloc{
    [self removeNotificationWithName:@"print"];
}

#pragma mark - Action

- (void)toCloudAlbumBtnDidClick {
    CloudAlbumViewController *cloudAlbum = [[CloudAlbumViewController alloc] init];
    [self.navigationController pushViewController:cloudAlbum animated:YES];
}

- (void)toPHAbListBtnDidClick {
     PHAlbumListViewController *album = [PHAlbumListViewController new];
    [self.navigationController pushViewController:album animated:YES];
}

#pragma mark - Private Method

- (void)createBtnWithFrame:(CGRect )frame title:(NSString *)title bgColor:(UIColor *)bgColor num:(NSInteger)num {
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = frame;
    clickBtn.layer.cornerRadius = CGRectGetWidth(frame)/2;
    if (num == 0) {
        [clickBtn addTarget:self
                     action:@selector(toPHAbListBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [clickBtn addTarget:self
                     action:@selector(toCloudAlbumBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [clickBtn setTitle:title forState:UIControlStateNormal];
    [clickBtn setBackgroundColor:bgColor];
    [self.view addSubview:clickBtn];
}

-(void)addNotificationWithName:(NSString *)name {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveNotification) name:name object:nil];
}

-(void)removeNotificationWithName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)didRecieveNotification {
    for (PHAsset *asset in [PHManager defaultManager].PhotoMsgArr) {
            NSLog(@"creationDate---%@\nmodificationDate---%@\nduration---%f\nburstIdentifier---%@\nlocation---%@\nlocalIdentifier---%@ ",asset.creationDate,asset.modificationDate,asset.duration,asset.burstIdentifier,asset.location,asset.localIdentifier);
        }
}

#pragma mark - Setter & Getter

-(UILabel *)titleLbl{
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"主页";
        _titleLbl.textColor = [CloudAlbumUI titleColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

@end
