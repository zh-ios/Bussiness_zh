//
//  ZHImagePickerController.m
//  ZHProject
//
//  Created by zh on 2018/8/3.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHImagePickerController.h"
#import "ZHAlbumController.h"
#import "ZHMediaFetcher.h"
#import "ZHPhotoPickerController.h"
@interface ZHImagePickerController ()

@property (nonatomic, strong) ZHMediaFetcher *fetcher;
@property (nonatomic, strong) ZHAlbumController *albumController;

@end

@implementation ZHImagePickerController

- (void)setAllowPickImage:(BOOL)allowPickImage {
    _allowPickImage = allowPickImage;
}

- (void)setAllowPickVideo:(BOOL)allowPickVideo {
    _allowPickVideo = allowPickVideo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO init navigation
    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.enabled = NO;
    self.fetcher = [ZHMediaFetcher shareFetcher];
    
    [self initData];
}

- (void)initData {
    self.allowPickImage = YES;
    self.allowPickVideo = YES;
    self.allowPickOriginalImage = YES;
}

- (instancetype)initWithMaxSelectedCount:(NSUInteger)maxCount
                          selectedAssets:(NSArray<ZHAssetModel *> *)selectedAssets
                                delegate:(id)delegate {
    
    self.maxSelectCount = maxCount;
    self.pickerDelegate = delegate;
    ZHAlbumController *album = [[ZHAlbumController alloc] init];
    self.albumController = album;
    self = [super initWithRootViewController:album];
    ZHPhotoPickerController *picker = [[ZHPhotoPickerController alloc] init];
    [album.navigationController pushViewController:picker animated:YES];
    
    return self;
}


@end
