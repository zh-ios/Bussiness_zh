//
//  ZHPhotoPreviewContainerView.h
//  ZHProject
//
//  Created by zh on 2018/8/13.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAssetsModel.h"
@interface ZHPhotoPreviewContainerView : UIView

@property (nonatomic, copy) void (^singleTapBlock)(void);

@property (nonatomic, strong) ZHAssetModel *model;

- (void)reloadSubviews;

@end
