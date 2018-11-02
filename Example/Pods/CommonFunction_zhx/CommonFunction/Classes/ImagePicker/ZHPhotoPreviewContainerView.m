//
//  ZHPhotoPreviewContainerView.m
//  ZHProject
//
//  Created by zh on 2018/8/13.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHPhotoPreviewContainerView.h"
#import "ZHImagePickerConst.h"
#import "ZHMediaFetcher.h"
#import "CommonFunctionPrefixHeader.h"

// 滚动的时候让view居中显示 。
//if (lastView.tz_right+12<self.view.tz_width) {
//    return;
//}
//CGFloat offsetx = bottomView.center.x - _bottomPreviewBar.frame.size.width * 0.5;
//CGFloat offsetMax = _bottomPreviewBar.contentSize.width - _bottomPreviewBar.frame.size.width;
//if (offsetx < 0) {
//    offsetx = 0;
//}else if (offsetx > offsetMax){
//    offsetx = offsetMax;
//}
//
//CGPoint offset = CGPointMake(offsetx, _bottomPreviewBar.contentOffset.y);
////  NSLog(@"%@",NSStringFromCGPoint(offset));
//[_bottomPreviewBar setContentOffset:offset animated:YES];


@interface ZHPhotoPreviewContainerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZHPhotoPreviewContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 2.5;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.alwaysBounceVertical = NO;
    [self addSubview:_scrollView];
    
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [_imageContainerView addSubview:_imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
}

- (void)setModel:(ZHAssetModel *)model {
    _model = model;
    __weak typeof(self)weakSelf = self;
    [[ZHMediaFetcher shareFetcher] getImageForAssetModel:model.asset imageSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 0) completion:^(UIImage *image, NSDictionary *info) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.imageView.image = image;
    }];
}

#pragma mark - UITapGestureRecognizer Event
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

-(void)reloadSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resetSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(kPreviewCellMargin, 0, self.width-kPreviewCellMargin*2, self.height);
    [self reloadSubviews];
}

- (void)resetSubviews {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.scrollView.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.scrollView.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.scrollView.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.height, self.height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.width > _scrollView.contentSize.width) ? ((_scrollView.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.height > _scrollView.contentSize.height) ? ((_scrollView.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}




@end
