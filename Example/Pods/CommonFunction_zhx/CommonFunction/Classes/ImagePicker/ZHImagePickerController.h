//
//  ZHImagePickerController.h
//  ZHProject
//
//  Created by zh on 2018/8/3.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAssetsModel.h"

@class ZHImagePickerController;

@protocol ZHImagePickerControllerDelegate <NSObject>
@required;
/**
 ❗️❗️❗️选择非原图图片片回调,
 infos 图片信息
 */
- (void)imagePickerController:(ZHImagePickerController *)picker
       didFinishPickingImages:(NSArray<UIImage *> *)images
                   imageInfos:(NSArray *)infos;
/**
 ❗️❗️❗️选择原图图片时回调，返回data类型数据
 PHImageManager的requestImageDataForAsset方法,这个方法是把PhAsset转化为NSData对象,NSData对象可以转化为UIImage对象,
 这样的话可以解决内存暴涨的问题.
 requestImageForAsset会对图片进行渲染,所以导致内存暴涨,
 而requestImageDataForAsset则是直接返回二进制数据,所以内存不会出现暴涨的现象.
 infos 返回的图片信息
 */
- (void)imagePickerController:(ZHImagePickerController *)picker
   didFinishPickingOriginalImages:(NSArray<NSData *> *)imagesData
                   imageInfos:(NSArray *)infos;


@optional;
- (void)imagePickerControllerCancelBtnOnClick;

@end


@interface ZHImagePickerController : UINavigationController

// 最大选取数量
@property (nonatomic, assign) NSUInteger maxSelectCount;
// 已经选取的数量
@property (nonatomic, assign) NSInteger  hadSelectedCount;

@property (nonatomic, assign) BOOL allowPickVideo;

@property (nonatomic, assign) BOOL allowPickImage;

@property (nonatomic, assign) BOOL allowPickOriginalImage;

@property (nonatomic, weak) id<ZHImagePickerControllerDelegate> pickerDelegate;


- (instancetype)initWithMaxSelectedCount:(NSUInteger)maxCount
                          selectedAssets:(NSArray<ZHAssetModel *> *)selectedAssets
                                delegate:(id)delegate;


- (instancetype)init NS_UNAVAILABLE;

@end
