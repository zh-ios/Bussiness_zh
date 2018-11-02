//
//  ZHAssetsModel.m
//  ZHProject
//
//  Created by zh on 2018/7/30.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHAssetsModel.h"

@implementation ZHAssetModel

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(ZHAssetMediaType)type videoDuration:(CGFloat)duration {
    ZHAssetModel *model = [[ZHAssetModel alloc] init];
    model.asset = asset;
    model.duration = duration;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(ZHAssetMediaType)type {
    return [self modelWithAsset:asset type:type videoDuration:0];
}

@end


@implementation ZHAlbumModel

+ (instancetype)modelWithResult:(id)result name:(NSString *)name {
    return [[self alloc] initWithAlbumWithResult:result name:name];
}

- (instancetype)initWithAlbumWithResult:(id)result name:(NSString *)name {
    if (self = [super init]) {
        self.result = result;
        self.name = name;
        self.count = [(PHFetchResult *)result count];
    }
    return self;
}

@end
