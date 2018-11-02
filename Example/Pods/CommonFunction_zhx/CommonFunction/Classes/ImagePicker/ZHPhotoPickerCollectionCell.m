//
//  ZHPhotoPickerCollectionCell.m
//  ZHProject
//
//  Created by zh on 2018/8/8.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHPhotoPickerCollectionCell.h"
#import "ZHMediaFetcher.h"
#import "UIImage+ImagePicerBundle.h"
#import "CommonFunctionPrefixHeader.h"

@interface ZHPhotoPickerCollectionCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *unselectedImageBtn;

@end


@implementation ZHPhotoPickerCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat imageViewWH = 18;
    CGFloat padding = 4;
    CGFloat coverBtnWH = 60;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    UIView *cantSelectedCoverView = [[UIView alloc] initWithFrame:self.bounds];
    self.cantSelectedCoverView = cantSelectedCoverView;
    cantSelectedCoverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    cantSelectedCoverView.hidden = YES;
    [self.contentView addSubview:cantSelectedCoverView];
    
    UIButton *unselectedImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-padding-imageViewWH, padding, imageViewWH, imageViewWH)];
    self.unselectedImageBtn = unselectedImageBtn;
    unselectedImageBtn.titleLabel.font = [UIFont systemFontOfSize:10];

    [unselectedImageBtn setBackgroundImage:[UIImage imageFromColor:[UIColor redColor]] forState:UIControlStateNormal];
    [unselectedImageBtn setBackgroundImage:[UIImage imageFromColor:[UIColor orangeColor]] forState:UIControlStateSelected];

    [self.contentView addSubview:unselectedImageBtn];
    
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-60, 0, coverBtnWH, coverBtnWH)];
    [coverBtn addTarget:self action:@selector(coverBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    coverBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:coverBtn];
}

- (void)setModel:(ZHAssetModel *)model {
    _model = model;
    // 说明是选中的
    if (model.selectedIndex != 0 && model.isSelected) {
        [self.unselectedImageBtn setTitle:[NSString stringWithFormat:@"%@",@(model.selectedIndex)] forState:UIControlStateNormal];
    } else {
        [self.unselectedImageBtn setTitle:@"" forState:UIControlStateNormal];
    }
    if (!model.cachedImage) {
        [[ZHMediaFetcher shareFetcher] getImageForAssetModel:model.asset imageSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) completion:^(UIImage *image, NSDictionary *info) {
            BOOL ret = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (image && !ret) {
                self.imageView.image = image;
                model.cachedImage = image;
            }
        }];
    } else {
        self.imageView.image = model.cachedImage;
    }
    
    
    self.unselectedImageBtn.selected = model.isSelected;
    if (model.isSelected) {
        [self.unselectedImageBtn setTitle:[NSString stringWithFormat:@"%@",@(model.selectedIndex+1)] forState:UIControlStateNormal];
    }
}

- (void)coverBtnOnClick:(UIButton *)btn {
    if (!self.model.isSelected) {
        self.model.selectedIndex = 0;
    }
    if (self.coverBtnOnClick) {
        self.coverBtnOnClick(self.model);
    }
}

@end
