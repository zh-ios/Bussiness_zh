//
//  ZHPhotoPreviewBottomView.h
//  ZHProject
//
//  Created by zh on 2018/8/15.
//  Copyright © 2018年 autohome. All rights reserved.
//  预览视图底部view 

#import <UIKit/UIKit.h>
#import "ZHAssetsModel.h"

@interface ZHPhotoPreviewBottomView : UIView

@property (nonatomic, copy) void (^originalBtnOnClick)(BOOL isOriginalImage);

@property (nonatomic, copy) void (^doneBtnOnClick)(void);

- (void)refreshBottomView:(NSArray<ZHAssetModel *> *)selecteAssets isOriginal:(BOOL)isOriginal;

@property (nonatomic, assign) BOOL allowPickOriginalImage;

@end

