//
//  PHAlbumListViewController.m
//  CloudPhoto
//
//  Created by 芏小川 on 2016/11/23.
//  Copyright © 2016年 芏小川. All rights reserved.
//

#import "PHAlbumListViewController.h"
#import "PHAlbumDetailViewController.h"
#import "PHAlbumListTableViewCell.h"
#import "PHManager.h"
#import "CloudAlbumUI.h"
#import "ToolMacroDefine.h"

@interface PHAlbumListViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSArray *PHAbListArr;
@property (nonatomic,retain) NSMutableArray *imgArr;

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) UILabel *titleLbl;
@property (nonatomic,retain) UILabel *msgLbl;
@property (nonatomic,retain) UILabel *imgNumLbl;
@property (nonatomic,retain) UIButton *uploadBtn;

@end

@implementation PHAlbumListViewController


#pragma mark - UITableViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [CloudAlbumUI backgroundColor];
    [self.view addSubview:self.tableView];
    [[PHManager defaultManager].noticeView addSubview:self.msgLbl];
    if ([PHManager defaultManager].isShowView == NO) {
        self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0, 0, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(76.0, 0, 0, 0);
    }
    
    [self.visualEffectView.contentView addSubview:self.cancleBtn];
    self.cancleBtn.hidden = YES;
    [self.visualEffectView.contentView addSubview:self.titleLbl];
    [[PHManager defaultManager].bottomView addSubview:self.imgNumLbl];
    [[PHManager defaultManager].bottomView addSubview:self.uploadBtn];
    [self.view bringSubviewToFront:self.visualEffectView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [PHManager defaultManager].bottomView.hidden = NO;
    self.tableView.frame =  CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT-49);
    self.titleLbl.frame = CGRectMake(0, 0,VIEW_WIDTH , 44);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"同意");
            self.PHAbListArr = [[ZLPhotoTool sharePhotoTool] getPhotoAblumList];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }else if (status == PHAuthorizationStatusDenied) {
            NSLog(@"拒绝");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)uploadBtnDidClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"print" object:nil];
    
    [PHManager defaultManager].bottomView.hidden = YES;
    [PHManager defaultManager].noticeView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        [[PHManager defaultManager].selectedMsgArr removeAllObjects];
        [PHManager defaultManager].allSelectImgNum = 0;
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cancleBtnDidClick {
    [PHManager defaultManager].noticeView.hidden = YES;
    [PHManager defaultManager].bottomView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.PHAbListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tcell" forIndexPath:indexPath];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    if (cell == nil) {
        cell = [[PHAlbumListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Tcell"];
    }
    
    [self requestData];
    cell.backgroundColor = [UIColor clearColor];
    cell.thumbnail.image = self.imgArr[indexPath.row];
    cell.albumNameLbl.text = ((ZLPhotoAblumList *)self.PHAbListArr[indexPath.row]).title;
    cell.albumImgNumLbl.text = [NSString stringWithFormat:@"%lu",((ZLPhotoAblumList *)self.PHAbListArr[indexPath.row]).count];
    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAlbumDetailViewController *pickVC = [PHAlbumDetailViewController new];
    pickVC.AllMsgArr = self.PHAbListArr;
    pickVC.selectIndex = indexPath.row;
    pickVC.albumListNum = self.PHAbListArr.count;
    [self.navigationController pushViewController:pickVC animated:YES];
}

#pragma mark - Private Method

- (void)requestData {
    NSInteger cou = self.PHAbListArr.count;
    if (cou != 0) {
        for (NSInteger i = 0 ; i < cou; i++) {
            PHAsset *asset = ((ZLPhotoAblumList *)self.PHAbListArr[i]).headImageAsset;
            PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
            [imageManager requestImageForAsset:asset targetSize:CGSizeMake(93, 93) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result) {
                    [self.imgArr addObject:result];
                }
            }];
        }
    }
}

#pragma mark - Setter & Getter

- (NSMutableArray *)imgArr {
    if (_imgArr == nil) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[PHAlbumListTableViewCell class ]forCellReuseIdentifier:@"Tcell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UILabel *)msgLbl {
    if (_msgLbl == nil) {
        _msgLbl = [PHManager defaultManager].msgLbl;
        _msgLbl.font = [CloudAlbumUI LocalAlbumListViewController_noticeView_messageLabelFont];
        _msgLbl.textColor =[CloudAlbumUI LocalAlbumListViewController_noticeView_messageLabelTextColor];
        _msgLbl.text = [NSString stringWithFormat:@"将照片添加到'%@'",[PHManager defaultManager].albumTitleStr];
        _msgLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _msgLbl;
}

- (UILabel *)titleLbl {
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"相册列表";
        _titleLbl.textColor = [CloudAlbumUI titleColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (UIButton *)cancleBtn {
    if (_cancleBtn == nil) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setFrame:CGRectMake(315, 0, 60.0, 44.0)];
        [_cancleBtn addTarget:self action:@selector(cancleBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancleBtn setTitleColor:[CloudAlbumUI LocalAlbumListViewController_cancleButton_TextColor] forState:UIControlStateNormal];
    }
    return _cancleBtn;
}

- (UILabel *)imgNumLbl {
    if (_imgNumLbl == nil) {
        _imgNumLbl = [PHManager defaultManager].imgNumLbl;
        _imgNumLbl.text = [NSString stringWithFormat:@"已选择了%lu张图片",[PHManager defaultManager].allSelectImgNum];
        _imgNumLbl.textColor = [CloudAlbumUI LocalAlbumListViewController_bottomView_showSelectedImageViewNumberLabel_textColor];
        _imgNumLbl.font = [CloudAlbumUI LocalAlbumListViewController_bottomView_showSelectedImageViewNumberLabel_textFont];
    }
    return _imgNumLbl;
}

- (UIButton *)uploadBtn {
    if (_uploadBtn == nil) {
        _uploadBtn = [PHManager defaultManager].uploadBtn;
        [_uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
        _uploadBtn.titleLabel.font = [CloudAlbumUI LocalAlbumListViewController_bottomView_uploadButton_textFont];
        _uploadBtn.titleLabel.textColor = [CloudAlbumUI LocalAlbumListViewController_bottomView_uploadButton_textColor];
        [_uploadBtn setBackgroundImage:[CloudAlbumUI LocalAlbumListViewController_bottomView_uploadButton_backgroundImage_default] forState:UIControlStateNormal];
        [_uploadBtn addTarget:self
                       action:@selector(uploadBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

@end
