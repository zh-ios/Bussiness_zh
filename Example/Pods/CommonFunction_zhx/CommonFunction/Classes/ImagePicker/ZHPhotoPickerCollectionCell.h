//
//  ZHPhotoPickerCollectionCell.h
//  ZHProject
//
//  Created by zh on 2018/8/8.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAssetsModel.h"
@interface ZHPhotoPickerCollectionCell : UICollectionViewCell


@property (nonatomic, strong) UIView *cantSelectedCoverView;


@property (nonatomic, strong) ZHAssetModel *model;


@property (nonatomic, copy)  void (^coverBtnOnClick)(ZHAssetModel *_Nonnull model);


@end
