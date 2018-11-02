//
//  ZHPhotoPreviewCell.h
//  ZHProject
//
//  Created by zh on 2018/8/13.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAssetsModel.h"
@interface ZHPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) ZHAssetModel *model;

@property (nonatomic, copy) void (^singleTapBlock)(void);

@end
