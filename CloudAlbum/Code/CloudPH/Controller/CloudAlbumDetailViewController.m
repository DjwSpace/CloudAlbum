//
//  CloudAlbumDetailViewController.m
//  CloudPhoto
//
//  Created by 芏小川 on 16/11/22.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "CloudAlbumDetailViewController.h"
#import "PHAlbumListViewController.h"
#import "CloudAlbumDetailCollectionViewCell.h"
#import "CAListModel.h"
#import "CAImgDataModel.h"
#import "CloudAlbumUI.h"
#import "PHManager.h"
#import "BCANetWorkAPIRequest.h"
#import "ToolMacroDefine.h"
#import "UIImageView+WebCache.h"

@interface CloudAlbumDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,retain) UICollectionView *collectionView;
@property (nonatomic,retain) UILabel *titleLbl;
@property (nonatomic,retain) UIButton *uploadBtn;

@property (nonatomic,retain) UIImageView *airAlbumImg;
@property (nonatomic,retain) UILabel *tipLbl;
@property (nonatomic,retain) UIImageView *arrowImg;

@property (nonatomic,retain) NSMutableArray *allAlbumImgArr;
@property (nonatomic,retain) NSMutableArray *dateArr;
@property (nonatomic,retain) NSMutableArray *dateHandleArr;
@property (nonatomic,assign) NSInteger itemNum;
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,retain) CAListModel *caListModel;
@property (nonatomic,retain) CAImgDataModel *caImgDataModel;
@property (nonatomic,retain) NSMutableDictionary *cellDic;

@end

@implementation CloudAlbumDetailViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [CloudAlbumUI backgroundColor];
    [self.visualEffectView.contentView addSubview:self.titleLbl];
    [PHManager defaultManager].albumTitleStr = self.titleStr;
    //无图片时显示
    [self.view addSubview:self.airAlbumImg];
    [self.view addSubview:self.arrowImg];
    [self.view addSubview:self.tipLbl];
    
    //获取文件夹图片列表
    [BCANetWorkAPIRequest requestGetFolderImagesListWithUserID:CLOUD_USER_ID token:CLOUD_TOKEN folderID:self.FolderID page:1 pageCount:1000 orderIndex:1 bSelectCount:false successBlock:^(BOOL finish, id result) {
        NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:result];
        self.caListModel = [[CAListModel alloc] initWithDictionary:dataDic];
        self.allAlbumImgArr = [NSMutableArray arrayWithArray:self.caListModel.imgData];
        if (self.allAlbumImgArr.count > 0) {
            self.airAlbumImg.hidden = YES;
            self.arrowImg.hidden = YES;
            self.tipLbl.hidden = YES;
            [self.view addSubview:self.collectionView];
        }
        [self.view addSubview:self.uploadBtn];
        [self.view bringSubviewToFront:self.visualEffectView];
        [self handleData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } failBlock:^(BOOL finish, id result) {
        NSLog(@"resultiamgefalse___%@",result);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.titleLbl.frame = CGRectMake(0, 0,VIEW_WIDTH , 44);
    
    //无相册时
    self.airAlbumImg.frame = CGRectMake(140, 200, 94, 80);
    self.arrowImg.frame = CGRectMake((VIEW_WIDTH-103.5-38), (VIEW_HEIGHT-99.5-55), 38, 55);
    self.tipLbl.frame = CGRectMake(100, 300, 175, 43);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)uploadImg {
    PHAlbumListViewController *phlistVC = [[PHAlbumListViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:phlistVC];
    nav.navigationBar.hidden  = YES;
    [PHManager defaultManager].isShowView = YES;
    [self presentViewController:nav animated:YES completion:^{
        phlistVC.backBtn.hidden = YES;
        phlistVC.cancleBtn.hidden = NO;
        [PHManager defaultManager].noticeView.hidden = NO;
    }];
}

#pragma mark - UICollectionView Delegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview" forIndexPath:indexPath];
        
        //添加头视图的内容
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 41)];
        headView.backgroundColor = [CloudAlbumUI CloudAlbumDetailViewController_headView_backgroundColor];
        [headerview addSubview:headView];
        
        UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, VIEW_WIDTH, 19)];
        timeLbl.font = [CloudAlbumUI CloudAlbumDetailViewController_headView_showTimeLabel_textFont];
        timeLbl.textColor = [CloudAlbumUI CloudAlbumDetailViewController_headView_showTimeLabel_textColor];
        NSString *allStr = self.dateHandleArr[indexPath.section];
        NSString *yearStr = [allStr substringToIndex:4];
        NSString *monthStr = [allStr substringWithRange:NSMakeRange(4, 2)];
        NSString *dayStr = [allStr substringWithRange:NSMakeRange(6, 2)];
        timeLbl.text =  [NSString stringWithFormat:@"  %@年%@月%@日",yearStr,monthStr,dayStr];
        timeLbl.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:timeLbl];
        
        return headerview;
    }
    
    return nil;
}

#pragma mark -UICollectionView DataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"cell", [NSString stringWithFormat:@"%@", indexPath]];
        [self.cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        [self.collectionView registerClass:[CloudAlbumDetailCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    
    CloudAlbumDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    NSArray *dataArr = self.dataArr[indexPath.section];
    NSDictionary *dataDic = dataArr[indexPath.item];
    self.caImgDataModel = [[CAImgDataModel alloc] initWithDictionary:dataDic];
    [cell.contentImg sd_setImageWithURL:[NSURL URLWithString:self.caImgDataModel.coverImgUrl] placeholderImage:[UIImage imageNamed:@"cp_placholderimg"]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  self.dateHandleArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.itemNum = 0;
    for (int i = 0 ; i < self.dateHandleArr.count; i ++) {
        if (section == i) {
            for (NSDictionary *dataDic  in self.allAlbumImgArr) {
                self.caImgDataModel = [[CAImgDataModel alloc] initWithDictionary:dataDic];
                if ([self.caImgDataModel.addDate isEqualToString:self.dateHandleArr[i]]) {
                    self.itemNum += 1;
                }
            }
        }
    }
    return self.itemNum;
}

#pragma mark - Private Method

- (void)handleData {
    for (NSDictionary *imgDic in self.allAlbumImgArr) {
        self.caImgDataModel =
        [[CAImgDataModel alloc] initWithDictionary:imgDic];
        [self.dateArr addObject: self.caImgDataModel.addDate];
    }
    
    NSDictionary *handleDic =
    [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSString *str in self.dateArr) {
        [handleDic setValue:str forKey:str];
    }
    
    self.dateHandleArr =
    [NSMutableArray arrayWithArray:[handleDic allKeys]];
    NSInteger cou = self.dateHandleArr.count;
    for (int i = 0; i < cou; i++) {
        for (int j = i+1; j < cou; j++) {
            if (self.dateHandleArr[i]<self.dateHandleArr[j]) {
                NSString *dateStr = self.dateHandleArr[i];
                self.dateHandleArr[i] = self.dateHandleArr[j];
                self.dateHandleArr[j] = dateStr;
            }
        }
    }
    
    for (int i = 0 ; i < self.dateHandleArr.count; i ++) {
        NSMutableArray *dateArr = [NSMutableArray array];
        for (NSDictionary *dataDic  in self.allAlbumImgArr) {
            self.caImgDataModel = [[CAImgDataModel alloc] initWithDictionary:dataDic];
            if ([self.caImgDataModel.addDate isEqualToString:self.dateHandleArr[i]]) {
                [dateArr addObject:dataDic];
            }
        }
        
        [self.dataArr addObject:dateArr];
    }
}

#pragma mark - Setter & Getter

- (NSMutableDictionary *)cellDic {
    if (_cellDic == nil) {
        _cellDic = [NSMutableDictionary dictionary];
    }
    return _cellDic;
}

- (NSMutableArray *)dateArr {
    if (_dateArr == nil) {
        _dateArr = [NSMutableArray array];
    }
    return _dateArr;
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)dateHandleArr {
    if (_dateHandleArr == nil) {
        _dateHandleArr = [NSMutableArray array];
    }
    return _dateHandleArr;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((VIEW_WIDTH/3 - 2), (VIEW_WIDTH/3 - 2));
        flowLayout.minimumLineSpacing = 3;
        flowLayout.minimumInteritemSpacing = 3;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 3, 0);
        flowLayout.headerReferenceSize = CGSizeMake(VIEW_WIDTH, 41);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,VIEW_WIDTH, VIEW_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(44.0, 0, 0, 0);
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview"];
        [_collectionView  registerClass:[CloudAlbumDetailCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
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
        _titleLbl.text = self.titleStr;
        _titleLbl.textColor = [CloudAlbumUI titleColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (UIButton *)uploadBtn {
    if (_uploadBtn == nil) {
        _uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.uploadBtn.frame = CGRectMake(288, 579, 75, 75);
        [_uploadBtn setBackgroundImage:[CloudAlbumUI CloudAlbumDetailViewController_noImage_uploadButton_backgroundImage] forState:UIControlStateNormal];
        [_uploadBtn setImage:[CloudAlbumUI CloudAlbumDetailViewController_noImage_uploadButton_contentImage] forState:UIControlStateNormal];
        [_uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
        [_uploadBtn addTarget:self action:@selector(uploadImg) forControlEvents:UIControlEventTouchUpInside];
        _uploadBtn.titleLabel.font = [CloudAlbumUI CloudAlbumDetailViewController_noImage_uploadButton_textFont];
        [_uploadBtn setTitleColor:[CloudAlbumUI CloudAlbumDetailViewController_noImage_uploadButton_textColor] forState:UIControlStateNormal];
        _uploadBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_uploadBtn setTitleEdgeInsets:
         UIEdgeInsetsMake(_uploadBtn.imageView.frame.size.height ,-_uploadBtn.imageView.frame.size.width, -5.0,0.0)];
        [_uploadBtn setImageEdgeInsets:
         UIEdgeInsetsMake(-20.0, 0.0,0.0, -_uploadBtn.titleLabel.bounds.size.width)];
    }
    return _uploadBtn;
}

- (UIImageView *)airAlbumImg {
    if (_airAlbumImg == nil) {
        _airAlbumImg = [[UIImageView alloc] init];
        _airAlbumImg.image = [UIImage imageNamed:@"jane_airalbum"];
    }
    return _airAlbumImg;
}

- (UIImageView *)arrowImg {
    if (_arrowImg == nil) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.image = [UIImage imageNamed:@"jane_arrow"];
    }
    return _arrowImg;
}

- (UILabel *)tipLbl {
    if (_tipLbl == nil) {
        _tipLbl = [[UILabel alloc] init];
        _tipLbl.text = @"你的相册还没有照片哦\n试着上传一张照片吧";
        _tipLbl.numberOfLines = 0;
        _tipLbl.textAlignment = NSTextAlignmentCenter;
        _tipLbl.textColor = [CloudAlbumUI CloudAlbumDetailViewController_noImage_tipLabel_textColor];
        _tipLbl.font = [CloudAlbumUI CloudAlbumDetailViewController_noImage_tipLabel_textFont];
    }
    return _tipLbl;
}
@end
