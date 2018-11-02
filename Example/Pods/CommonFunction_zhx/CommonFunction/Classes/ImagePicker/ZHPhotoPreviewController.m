//
//  ZHPhotoPreviewController.m
//  ZHProject
//
//  Created by zh on 2018/8/13.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHPhotoPreviewController.h"
#import "ZHPhotoPreviewCell.h"
#import "ZHImagePickerConst.h"
#import "ZHPhotoPreviewBottomView.h"
#import "ZHMediaFetcher.h"
#import "ZHImagePickerController.h"
#import "CommonFunctionPrefixHeader.h"
@interface ZHPhotoPreviewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) ZHPhotoPreviewBottomView *bottomBar;
@property (nonatomic, strong) UIView *customNav;
@property (nonatomic, assign) BOOL navAndBottomBarHiding;

@end

@implementation ZHPhotoPreviewController

static NSString *photoPreviewCellID = @"photoPreviewCellID";

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(self.view.width+kPreviewCellMargin*2, self.view.height);
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kPreviewCellMargin , 0, self.view.width+kPreviewCellMargin*2, self.view.height)
                                             collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.contentSize = CGSizeMake((self.view.width+kPreviewCellMargin*2)*self.assets.count, 0);
        [_collectionView registerClass:[ZHPhotoPreviewCell class] forCellWithReuseIdentifier:photoPreviewCellID];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
        
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    [self initCustomNav];
    
    [self initBottomBar];
    
    [self refreshNavBar];
    [self.bottomBar refreshBottomView:self.selectedAssets isOriginal:self.isOriginalImage];
}

- (void)initCustomNav {
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kNavbarHeight)];
    nav.backgroundColor = kImagePickerNavBgColor;
    [self.view addSubview:nav];
    self.customNav = nav;

    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(kImagePickerSideViewPadding, kTopSafeArea+10, 20, 20)];
    backBtn.backgroundColor = [UIColor orangeColor];
    [backBtn setExtendedHitArea:CGRectMake(20, 20, 20, 20)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:backBtn];
    
    UIButton *selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-kImagePickerSideViewPadding-30, kTopSafeArea+10, 20, 30)];
    self.selectedBtn = selectedBtn;
    [selectedBtn setBackgroundImage:[UIImage imageFromColor:[UIColor redColor]] forState:UIControlStateNormal];
    [selectedBtn setBackgroundImage:[UIImage imageFromColor:[UIColor orangeColor]] forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:selectedBtn];
}

- (void)initBottomBar {
    ZHImagePickerController *pickerVC = (ZHImagePickerController *)self.navigationController;
    ZHPhotoPreviewBottomView *bottomBar = [[ZHPhotoPreviewBottomView alloc] initWithFrame:CGRectMake(0, self.view.height-kBottomSafeArea-49-73-0.5, self.view.width, 49+73+0.5+kBottomSafeArea)];
    self.bottomBar = bottomBar;
    bottomBar.allowPickOriginalImage = pickerVC.allowPickOriginalImage;
    [self.view addSubview:bottomBar];
    __weak  typeof(self)weakSelf = self;
    bottomBar.doneBtnOnClick = ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf done];
    };
    bottomBar.originalBtnOnClick = ^(BOOL isOriginalImage) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isOriginalImage = isOriginalImage;
        if (strongSelf.originalBtnOnClick) {
            strongSelf.originalBtnOnClick(isOriginalImage);
        }
    };
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZHPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoPreviewCellID forIndexPath:indexPath];
    ZHAssetModel *model = self.assets[indexPath.item];
    cell.model = model;
    __weak  typeof(self)weakSelf = self;
    cell.singleTapBlock = ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf handleSingleTap];
    };
    return cell;
}

- (void)handleSingleTap {
    self.navAndBottomBarHiding = !self.navAndBottomBarHiding;
    if (self.navAndBottomBarHiding) {
        self.customNav.transform = CGAffineTransformMakeTranslation(0, -self.customNav.height);
        self.bottomBar.transform = CGAffineTransformMakeTranslation(0, self.bottomBar.height);
    } else {
        self.customNav.transform = CGAffineTransformIdentity;
        self.bottomBar.transform = CGAffineTransformIdentity;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index =  (int)(scrollView.contentOffset.x/(self.view.width+kPreviewCellMargin*2)+0.5);
    NSLog(@"------------->%@",@(index));
    if (index != self.selectedIndex && index<self.assets.count) {
        self.selectedIndex = index;
        [self refreshNavBar];
    }
}

#pragma mark --- targetAction
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selected:(UIButton *)btn {
    ZHAssetModel *model = self.assets[self.selectedIndex];
    if (model.isSelected) {
        model.isSelected = NO;
        [self.selectedAssets removeObject:model];
    } else {
        model.isSelected = YES;
        [self.selectedAssets addObject:model];
    }
    [self.bottomBar refreshBottomView:self.selectedAssets isOriginal:self.isOriginalImage];
    [self refreshNavBar];
}

- (void)refreshNavBar {
    ZHAssetModel *model = self.assets[self.selectedIndex];
    self.selectedBtn.selected = model.isSelected;
    // 设置选中状态下标题
    [self.selectedBtn setTitle:[NSString stringWithFormat:@"%@",@([self.selectedAssets indexOfObject:model]+1)] forState:UIControlStateSelected];
}

- (void)done {
    if (self.sendBtnOnClick) {
        self.sendBtnOnClick();
    }
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"---- 图片预览页面销毁了");
#endif
}

@end
