//
//  ZHAssetsModel.h
//  ZHProject
//
//  Created by zh on 2018/7/30.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
typedef NS_ENUM(NSInteger, ZHAssetMediaType) {
    ZHAssetMediaType_Image = 0,
    ZHAssetMediaType_Video,
    ZHAssetMediaType_Audio,
    ZHAssetMediaType_Gif
};

@interface ZHAssetModel : NSObject


/**
  是否选中
 */
@property (nonatomic, assign) BOOL isSelected;


/**
  选中图片后，当前图片的索引，默认为 0 。
 */
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) PHAsset *asset; // PHAsset 模型

@property (nonatomic, assign) ZHAssetMediaType type;

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, strong) UIImage *cachedImage;

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(ZHAssetMediaType)type;

/**
 video 类型 model初始化
 */
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(ZHAssetMediaType)type videoDuration:(CGFloat)duration;

@end


@interface ZHAlbumModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) PHFetchResult *result; // phfetchResult

+ (instancetype)modelWithResult:(id)result name:(NSString *)name;

@end
