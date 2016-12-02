//
//  CloudAlbumViewController.m
//  CloudPhoto
//
//  Created by 芏小川 on 16/11/21.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "CloudAlbumViewController.h"
#import "CloudAlbumCollectionViewCell.h"
#import "CloudAlbumDetailViewController.h"
#import "CAModel.h"
#import "CloudAlbumUI.h"
#import "BCANetWorkAPIRequest.h"
#import "ToolMacroDefine.h"
#import "UIImageView+WebCache.h"

@interface CloudAlbumViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,retain) UICollectionView *collectionView;
@property (nonatomic,retain) CAModel *caModel;
@property (nonatomic,retain) UIButton *settingBtn;
@property (nonatomic,retain) UILabel *titleLbl;

@property (nonatomic,retain) UIView *noneAlbumView;
@property (nonatomic,retain) UILabel *tipLbl;
@property (nonatomic,retain) UIImageView *arrowImgView;
@property (nonatomic,retain) UIButton *createAlbumBtn;

@property (nonatomic,retain) NSMutableArray *albumArr;

@end

@implementation CloudAlbumViewController
#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [CloudAlbumUI backgroundColor];
    [self.visualEffectView.contentView addSubview:self.settingBtn];
    [self.visualEffectView.contentView addSubview:self.titleLbl];
    //获取文件夹列表
    [BCANetWorkAPIRequest requestGetFolderListWithUserID:CLOUD_USER_ID token:CLOUD_TOKEN parentID:nil page:1 pageCount:1000 bSelectCount:false successBlock:^(BOOL finish, id result) {
        self.albumArr = [NSMutableArray arrayWithArray:result];
        if (self.albumArr.count < 0) {
            [self.view addSubview:self.collectionView];
        }else{
            self.noneAlbumView = [[UIView alloc] init];
            self.noneAlbumView.backgroundColor = [UIColor cyanColor];
            self.noneAlbumView.frame = CGRectMake(0, 0, 150, 200);
            self.noneAlbumView.center = self.view.center;
            [self.view addSubview:self.noneAlbumView];
        }
        
        [self.view bringSubviewToFront:self.visualEffectView];
    } failBlock:^(BOOL finish, id result) {
        NSLog(@"resultlistfalse____%@",result);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.titleLbl.frame = CGRectMake(0, 0,VIEW_WIDTH , 44);
    [self.settingBtn setFrame:CGRectMake((VIEW_WIDTH - 60), 0, 60.0, 44.0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)createAlbumAction {
    NSLog(@"创建相册");
}

- (void)goSetting {
    NSLog(@"setting");
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.item == 0) {
        NSLog(@"添加相册");
    } else {
        NSLog(@"已有相册");
        CloudAlbumDetailViewController *cadVC = [[CloudAlbumDetailViewController alloc] init];
        NSDictionary *dic = self.albumArr[indexPath.item-1];
        self.caModel = [[CAModel alloc] initWithDictionary:dic];
        cadVC.titleStr = self.caModel.name;
        cadVC.FolderID = self.caModel.folderId;
        [self.navigationController pushViewController:cadVC animated:YES];
    }
    
}

#pragma mark -UICollectionView DataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CloudAlbumCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.item == 0) {
        cell.contentImg.image = [CloudAlbumUI CloudAlbumListViewController_addAlbumImage];
    }else{
        NSDictionary *dic = self.albumArr[(indexPath.item-1)];
        self.caModel = [[CAModel alloc] initWithDictionary:dic];
        [cell.contentImg sd_setImageWithURL:
         [NSURL URLWithString:self.caModel.coverImgUrl] placeholderImage:[CloudAlbumUI CloudAlbumListViewController_placeholderImage]];
        cell.numLbl.text = self.caModel.photoCount;
        cell.nameLbl.text = self.caModel.name;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.albumArr.count+1);
}

#pragma mark - Setter & Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((VIEW_WIDTH-60)/3, ((VIEW_WIDTH-60)/3 + 40));
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
        flowLayout.headerReferenceSize = CGSizeMake(VIEW_WIDTH, 44);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT) collectionViewLayout:flowLayout];
        [_collectionView  registerClass:[CloudAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (UILabel *)titleLbl {
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"云相册";
        _titleLbl.textColor = [CloudAlbumUI titleColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (UIButton *)settingBtn {
    if (_settingBtn == nil) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
        UIImage *settingImage = [[CloudAlbumUI CloudAlbumListViewController_settingButtonImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_settingBtn setImage:settingImage forState:UIControlStateNormal];
    }
    return _settingBtn;
}

-(void)setNoneAlbumView:(UIView *)noneAlbumView{
    [noneAlbumView addSubview:self.tipLbl];
    [noneAlbumView addSubview:self.arrowImgView];
    [noneAlbumView addSubview:self.createAlbumBtn];
    _tipLbl.frame = CGRectMake(0, 0, 150, 60);
    _arrowImgView.frame = CGRectMake(60, 60, 30,  60);
    _createAlbumBtn.frame = CGRectMake(35, 120, 80, 80);
    _noneAlbumView = noneAlbumView;
}

- (UILabel *)tipLbl {
    if (_tipLbl == nil) {
        _tipLbl = [[UILabel alloc] init];
        _tipLbl.numberOfLines = 0;
        _tipLbl.font = [UIFont systemFontOfSize:13];
        _tipLbl.textAlignment = NSTextAlignmentCenter;
        _tipLbl.text = @"还未创建相册\n点击创建新的相册";
        _tipLbl.textColor = [CloudAlbumUI CloudAlbumListViewController_noAlbumView_tipTextClolor];
    }
    return _tipLbl;
}

- (UIImageView *)arrowImgView {
    if (_arrowImgView == nil) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image =
        [UIImage imageNamed:@"jane_arrow"];
    }
    return _arrowImgView;
}

- (UIButton *)createAlbumBtn {
    if (_createAlbumBtn == nil) {
        _createAlbumBtn =
        [UIButton buttonWithType:UIButtonTypeCustom];
        [_createAlbumBtn setBackgroundImage:
         [UIImage imageNamed:@"jane_createalbum"] forState:UIControlStateNormal];
        [_createAlbumBtn addTarget:self action:@selector(createAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createAlbumBtn;
}

@end
