//
//  ZHPhotoPreviewCell.m
//  ZHProject
//
//  Created by zh on 2018/8/13.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHPhotoPreviewCell.h"
#import "ZHPhotoPreviewContainerView.h"

@interface ZHPhotoPreviewCell ()

@property (nonatomic, strong) ZHPhotoPreviewContainerView *container;

@end

@implementation ZHPhotoPreviewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    ZHPhotoPreviewContainerView *container = [[ZHPhotoPreviewContainerView alloc] init];
    self.container = container;
    [self.contentView addSubview:container];
    container.singleTapBlock = ^{
        if (self.singleTapBlock) {
            self.singleTapBlock();
        }
    };
}

- (void)setModel:(ZHAssetModel *)model {
    _model = model;
    self.container.model = model;
    [self.container reloadSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.container.frame = self.bounds;
}

@end
