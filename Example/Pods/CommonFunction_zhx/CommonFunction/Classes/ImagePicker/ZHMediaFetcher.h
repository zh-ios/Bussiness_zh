//
//  ZHMediaFetcher.h
//  ZHProject
//
//  Created by zh on 2018/7/31.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHAssetsModel.h"

/**
 获取到图片后的回调block

 @param image 选择的图片
 @param info info
 */
typedef void (^ImageFetchedBlock)(UIImage *image, NSDictionary *info);
typedef void (^ImageDataFetchedBlock)(NSData *imageData, NSDictionary *info);
typedef void (^AlbumsFetchedBlock)(NSArray<ZHAlbumModel *> *albums);
typedef void (^AssetsFetchedBlock)(NSArray<ZHAssetModel *> *assets);

@interface ZHMediaFetcher : NSObject


+ (instancetype)shareFetcher;

/**
 获取相册的封面图

 @param album ZHAlbumModel
 @param completed 完成回调
 */
- (void)getPosterImageForAlbumModel:(ZHAlbumModel *)album completion:(ImageFetchedBlock)completed;


/**
 根据 PHFetchResult 获取AssetModel数组
 @param completed 完成回调
 */
- (void)getAssetsForResult:(PHFetchResult *)result allowPickVideo:(BOOL)pickVideo allowPickImage:(BOOL)pickImage completion:(AssetsFetchedBlock)completed;

/**
 通过 ZHAssetModel获取图片

 @param asset ZHAssetModel
 @param size 目标图片的size
 @param completed 完成回调
 */
//For an asynchronous request, Photos may call your result handler block more than once. Photos first calls the block to provide a low-quality image suitable for displaying temporarily while it prepares a high-quality image. (If low-quality image data is immediately available, the first call may occur before the method returns.) When the high-quality image is ready, Photos calls your result handler again to provide it. If the image manager has already cached the requested image at full quality, Photos calls your result handler only once. The PHImageResultIsDegradedKey key in the result handler’s info parameter indicates when Photos is providing a temporary low-quality image.
- (PHImageRequestID *)getImageForAssetModel:(PHAsset *)asset imageSize:(CGSize)size completion:(ImageFetchedBlock)completed;


- (void)getOriginalImageDataForAssetModel:(PHAsset *)asset completion:(ImageDataFetchedBlock)completed;
- (void)getOriginalImageForAssetModel:(PHAsset *)asset completion:(ImageFetchedBlock)completed;


/**
 获取相簿列表

 @param pickVideo 是否允许选择视频
 @param pickImage 是否允许选择图片
 @param completed 完成回调
 */
- (void)getAlbumsAllowPickVideo:(BOOL)pickVideo pickImage:(BOOL)pickImage
                     completion:(AlbumsFetchedBlock)completed;


/**
 获取相机胶卷列表
 */
- (void)getCameraRollAlbumPickVideo:(BOOL)pickVideo
                          pickImage:(BOOL)pickImage
                         completion:(AlbumsFetchedBlock)completed;
@end
