//
//  ZHMediaFetcher.m
//  ZHProject
//
//  Created by zh on 2018/7/31.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHMediaFetcher.h"
#import <Photos/Photos.h>
@implementation ZHMediaFetcher

+ (instancetype)shareFetcher {
    static ZHMediaFetcher *_fetcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_fetcher) {
            _fetcher = [[self alloc] init];
        }
    });
    return _fetcher;
}


- (PHImageRequestID *)getImageForAssetModel:(PHAsset *)asset imageSize:(CGSize)size completion:(ImageFetchedBlock)completed {
    CGSize imageSize = [self p_getImageSizeForAsset:asset size:size];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    PHImageRequestID *imageID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        BOOL downloaded = !([[info objectForKey:PHImageCancelledKey] boolValue])&&![info objectForKey:PHImageErrorKey];
//        BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (result) {
            result = [self p_fixOrientation:result];
            if (completed) {
                completed(result, info);
            }
        }
    }];
    return imageID;
}

- (CGSize)p_getImageSizeForAsset:(PHAsset *)asset size:(CGSize)size {
    CGSize imageSize = CGSizeZero;
    // 缩略图
    if (size.width < [UIScreen mainScreen].bounds.size.width) {
        // item 的高度
        imageSize = CGSizeMake(80 * [UIScreen mainScreen].scale, 80 * [UIScreen mainScreen].scale);
    }
    CGFloat scale = asset.pixelWidth / (asset.pixelHeight*1.0);
    CGFloat pixW = size.width*1.5;
    // 超宽图片
    if (scale > 1.8) {
        pixW = pixW * scale;
    }
    // 超高图片
    if (scale < 0.2) {
        pixW = pixW * 0.5;
    }
    CGFloat pixH = pixW / scale;
    imageSize = CGSizeMake(pixW, pixH);
    return imageSize;
}

- (void)getOriginalImageDataForAssetModel:(PHAsset *)asset completion:(ImageDataFetchedBlock)completed {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    if ([[[asset valueForKey:@"filename"] uppercaseString] hasSuffix:@"GIF"]) {
        // if version isn't PHImageRequestOptionsVersionOriginal, the gif may cann't play
        option.version = PHImageRequestOptionsVersionOriginal;
    }
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        if (completed) {
            completed(imageData, info);
        }
    }];
}

- (void)getOriginalImageForAssetModel:(PHAsset *)asset completion:(ImageFetchedBlock)completed {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    // Size to pass when requesting the original image or the largest rendered image available (resizeMode will be ignored)
//    extern CGSize const PHImageManagerMaximumSize PHOTOS_AVAILABLE_IOS_TVOS(8_0, 10_0);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        result = [self p_fixOrientation:result];
        if (completed) {
            completed(result, info);
        }
    }];
}





- (void)getAssetsForResult:(PHFetchResult *)result allowPickVideo:(BOOL)pickVideo
            allowPickImage:(BOOL)pickImage completion:(AssetsFetchedBlock)completed {
    NSMutableArray *assetsArray = @[].mutableCopy;
    [result enumerateObjectsUsingBlock:^(PHAsset *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHAssetModel *model = [self p_getAssetModelForAsset:obj allowPickVideo:pickVideo allowPickImage:pickImage];
        if (model) {
            [assetsArray addObject:model];
        }
    }];
    if (completed) {
        completed(assetsArray);
    }
}


/**
 获取相册
 @param isCameraRoll 是否是获取相机胶卷相册
 */
- (void)getAlbumsAllowPickVideo:(BOOL)pickVideo pickImage:(BOOL)pickImage completion:(AlbumsFetchedBlock)completed isCameraRoll:(BOOL)isCameraRoll {
    
    NSMutableArray *albumsArr = @[].mutableCopy;
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!pickVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    if (!pickImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                                                PHAssetMediaTypeVideo];
    // option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:self.sortAscendingByModificationDate]];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];

    NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHAssetCollection *collection in fetchResult) {
            // 有可能是PHCollectionList类的的对象，过滤掉
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            // 过滤空相册
            if (collection.estimatedAssetCount <= 0) continue;
            if (collection.assetCollectionSubtype == 1000000201) continue; //最近删除相册
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) continue;

            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if (fetchResult.count >= 1) {
                ZHAlbumModel *model = [ZHAlbumModel modelWithResult:fetchResult name:collection.localizedTitle];
                if (isCameraRoll) {
                    if ([self p_isCameraRoll:collection]) {
                        [albumsArr addObject:model];
                        if (completed) completed(albumsArr);
                        return;
                    }
                } else {
                    if ([self p_isCameraRoll:collection]) {
                        [albumsArr insertObject:model atIndex:0];
                    } else {
                        [albumsArr addObject:model];
                    }
                }
            }
        }
    }
    if (completed) {
        completed(albumsArr);
    }
}

- (void)getAlbumsAllowPickVideo:(BOOL)pickVideo pickImage:(BOOL)pickImage completion:(AlbumsFetchedBlock)completed {
    [self getAlbumsAllowPickVideo:pickVideo pickImage:pickImage completion:completed isCameraRoll:NO];
}

- (void)getCameraRollAlbumPickVideo:(BOOL)pickVideo pickImage:(BOOL)pickImage completion:(AlbumsFetchedBlock)completed {
    [self getAlbumsAllowPickVideo:pickVideo pickImage:pickImage completion:completed isCameraRoll:YES];
}


/**
 判断是否是相机胶卷
 */
- (BOOL)p_isCameraRoll:(PHAssetCollection *)collection {
    return collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
}


- (void)getPosterImageForAlbumModel:(ZHAlbumModel *)album completion:(ImageFetchedBlock)completed {
    // TODO 根据排序规则，选择是最后一个还是第一个
    PHAsset *lastAsset = [album.result lastObject];
    [self getImageForAssetModel:lastAsset imageSize:CGSizeMake(80*[UIScreen mainScreen].scale, 80*[UIScreen mainScreen].scale) completion:^(UIImage *image, NSDictionary *info) {
        if (completed) {
            completed(image, info);
        }
    }];
}


- (ZHAssetModel *)p_getAssetModelForAsset:(PHAsset *)asset allowPickVideo:(BOOL)pickVideo allowPickImage:(BOOL)pickImage {
    ZHAssetModel *model = nil;
    ZHAssetMediaType type = [self p_getMediaTypeForAsset:asset];
    if (!pickVideo && type == ZHAssetMediaType_Video) return nil;
    if (!pickImage && (type == ZHAssetMediaType_Image || type == ZHAssetMediaType_Gif)) return nil;
    if (type == ZHAssetMediaType_Audio) return nil;
    
    if (type == ZHAssetMediaType_Video) {
        CGFloat duration = asset.duration;
        model = [ZHAssetModel modelWithAsset:asset type:ZHAssetMediaType_Video videoDuration:duration];
        return model;
    } else {
        model = [ZHAssetModel modelWithAsset:asset type:type];
    }
    return model;
}



- (ZHAssetMediaType)p_getMediaTypeForAsset:(PHAsset *)asset {
    ZHAssetMediaType type = ZHAssetMediaType_Image;
    if (asset.mediaType == PHAssetMediaTypeVideo)  type = ZHAssetMediaType_Video;
    if (asset.mediaType == PHAssetMediaTypeAudio) type = ZHAssetMediaType_Audio;
    if (asset.mediaType == PHAssetMediaTypeImage) {
        if ([[[asset valueForKey:@"filename"] uppercaseString] isEqualToString:@"GIF"]) {
            type = ZHAssetMediaType_Gif;
        }
    }
    return type;
}

/// 修正图片转向
- (UIImage *)p_fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
