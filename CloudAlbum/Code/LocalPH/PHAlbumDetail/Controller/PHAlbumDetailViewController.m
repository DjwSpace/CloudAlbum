//
//  PickerViewController.m
//  PrintPhotoInfo
//
//  Created by 芏小川 on 16/11/15.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "PHAlbumDetailViewController.h"
#import "PHAlbumDetailCollectionViewCell.h"
#import <Photos/Photos.h>
#import "ToolMacroDefine.h"
#import "CloudAlbumUI.h"
#import "PHManager.h"

@interface PHAlbumDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,retain) UICollectionView *collectionView;
@property (nonatomic,retain) UIButton *selectAllBtn;
@property (nonatomic,retain) UILabel *titleLbl;

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) BOOL isSelectAll;
@property (nonatomic,retain) NSMutableDictionary *cellDic;
@property (nonatomic,retain) NSArray *dataArr;
@property (nonatomic,retain) NSMutableArray *selectArr;
@property (nonatomic,retain) NSMutableArray *currentAlbumMsgArr;

@end

@implementation PHAlbumDetailViewController

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [CloudAlbumUI backgroundColor];
    [self.visualEffectView.contentView addSubview:self.titleLbl];
    [self.view addSubview:self.collectionView];
    [self.visualEffectView.contentView addSubview:self.selectAllBtn];
    [self.view bringSubviewToFront:self.visualEffectView];
    
    PHAssetCollection *collection = ((ZLPhotoAblumList *)self.AllMsgArr[self.selectIndex]).assetCollection;
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    self.count = result.count;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [PHManager defaultManager].bottomView.hidden = NO;
    self.titleLbl.frame = CGRectMake(0, 0,VIEW_WIDTH , 44);
    [self.selectAllBtn setFrame:CGRectMake((VIEW_WIDTH-60), 0, 60.0, 44.0)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [[PHManager defaultManager].selectedMsgArr addObjectsFromArray: self.selectArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView DataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"cell", [NSString stringWithFormat:@"%@", indexPath]];
        [self.cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        [self.collectionView registerClass:[PHAlbumDetailCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    
    PHAlbumDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        PHAssetCollection *collection = ((ZLPhotoAblumList *)self.AllMsgArr[self.selectIndex]).assetCollection;
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        PHAsset *asset = result[indexPath.item];
        
        for (NSString *localID in [PHManager defaultManager].selectedMsgArr) {
            if ([asset.localIdentifier isEqualToString: localID]) {
                [self.selectArr addObject:asset.localIdentifier];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.choiceView.hidden = NO;
                });
                break;
            }
        }
        
        [self.currentAlbumMsgArr addObject:asset.localIdentifier];
        [[PHManager defaultManager].PhotoMsgArr addObject:asset];
        
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        [imageManager requestImageForAsset:asset
                                targetSize:CGSizeMake(93, 93)
                               contentMode:PHImageContentModeAspectFill options:nil
                             resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.contentImgView.image = result;
            });
        }];
    });
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.count;
}

#pragma mark -UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAlbumDetailCollectionViewCell *cell = (PHAlbumDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
 
    if (![self.selectArr containsObject:self.currentAlbumMsgArr[indexPath.item]]) {
        cell.choiceView.hidden = NO;
        [self.selectArr addObject:self.currentAlbumMsgArr[indexPath.item]];
        [PHManager defaultManager].allSelectImgNum += 1;
    } else {
        cell.choiceView.hidden = YES;
        [[PHManager defaultManager].selectedMsgArr removeObject:self.currentAlbumMsgArr[indexPath.item]];
        [self.selectArr removeObject:
         self.currentAlbumMsgArr[indexPath.item]];
        [PHManager defaultManager].allSelectImgNum -= 1;
    }
    
    [self changeNumAndBtnStateUI];
}

#pragma mark - private Method

- (void)handleUIToSelectAll {
    if (self.selectArr.count < self.count) {
        self.isSelectAll = YES;
        [PHManager defaultManager].allSelectImgNum += (self.count - self.selectArr.count);
        [self.selectArr removeAllObjects];
        [self.selectArr  addObjectsFromArray:self.currentAlbumMsgArr];
    } else {
        self.isSelectAll = NO;
        [PHManager defaultManager].allSelectImgNum -= self.selectArr.count;
        [[PHManager defaultManager].selectedMsgArr removeObjectsInArray:self.selectArr];
        [self.selectArr removeAllObjects];
    }
    
    [self changeNumAndBtnStateUI];
    for (NSInteger i = 0 ; i < self.count; i++) {
        PHAlbumDetailCollectionViewCell *cell = (PHAlbumDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:
                                                                                    [NSIndexPath indexPathForItem:i inSection:0]];
        if (self.isSelectAll) {
            cell.choiceView.hidden = NO;
        } else {
            cell.choiceView.hidden = YES;
        }
    }
}

- (void)changeNumAndBtnStateUI {
    [PHManager defaultManager].imgNumLbl.text =
    [NSString stringWithFormat:@"已选择了%lu张图片",[PHManager defaultManager].allSelectImgNum];
    
    if ([PHManager defaultManager].allSelectImgNum == 0) {
        [[PHManager defaultManager].uploadBtn setBackgroundImage:[CloudAlbumUI LocalAlbumListViewController_bottomView_uploadButton_backgroundImage_default] forState:UIControlStateNormal];
    }else{
        [[PHManager defaultManager].uploadBtn setBackgroundImage:[CloudAlbumUI LocalAlbumListViewController_bottomView_uploadButton_backgroundImage] forState:UIControlStateNormal];
    }
    
}

#pragma mark - Setter & Getter

- (NSMutableDictionary *)cellDic {
    if (_cellDic == nil) {
        self.cellDic = [NSMutableDictionary dictionary];
    }
    
    return _cellDic;
}

- (NSMutableArray *)selectArr {
    if (_selectArr == nil) {
        _selectArr = [NSMutableArray array];
    }
    
    return _selectArr;
}

- (NSMutableArray *)currentAlbumMsgArr {
    if (_currentAlbumMsgArr == nil) {
        _currentAlbumMsgArr = [NSMutableArray array];
    }
    
    return _currentAlbumMsgArr;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((VIEW_WIDTH/4 - 1), (VIEW_WIDTH/4 - 1));
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT-49) collectionViewLayout:flowLayout];
        if ([PHManager defaultManager].noticeView.hidden == YES) {
            _collectionView.contentInset = UIEdgeInsetsMake(54.0, 0, 0, 0);
        }else{
            _collectionView.contentInset = UIEdgeInsetsMake(86.0, 0, 0, 0);
        }
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    
    return _collectionView ;
}

-(UIButton *)selectAllBtn{
    if (_selectAllBtn == nil) {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllBtn addTarget:self
                          action:@selector(handleUIToSelectAll) forControlEvents:UIControlEventTouchUpInside];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllBtn setTitleColor: [CloudAlbumUI LocalAlbumDetailViewController_selectAllButton_TextColor] forState:UIControlStateNormal];
        _selectAllBtn.titleLabel.font = [CloudAlbumUI LocalAlbumDetailViewController_selectAllButton_Font];
    }
    return _selectAllBtn;
}

-(UILabel *)titleLbl{
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = ((ZLPhotoAblumList *)self.AllMsgArr[self.selectIndex]).title;
        _titleLbl.textColor = [CloudAlbumUI titleColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;

    }
    return _titleLbl;
}

@end
