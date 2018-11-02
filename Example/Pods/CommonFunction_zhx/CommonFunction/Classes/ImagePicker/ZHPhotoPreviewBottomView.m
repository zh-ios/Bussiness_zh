//
//  ZHPhotoPreviewBottomView.m
//  ZHProject
//
//  Created by zh on 2018/8/15.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHPhotoPreviewBottomView.h"
#import "ZHImagePickerConst.h"
#import "CommonFunctionPrefixHeader.h"

@interface ZHPhotoPreviewBottomView ()

@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *originalBtn;

@end

@implementation ZHPhotoPreviewBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 73)];
    self.scrollView = scrollView;
    scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.hidden = YES; // 仿照微信的小图预览暂且不做
    [self addSubview:scrollView];
    
    UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, scrollView.bottom, self.width, 0.5)];
    lineL.backgroundColor = [UIColor redColor];
    lineL.hidden = YES;
    [self addSubview:lineL];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, lineL.bottom, self.width, self.height-73)];
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:containerView];
    
    UIButton *originalBtn = [[UIButton alloc] initWithFrame:CGRectMake(kImagePickerSideViewPadding , 13, 48, 20)];
    self.originalBtn = originalBtn;
    originalBtn.backgroundColor = [UIColor redColor];
    [originalBtn setTitle:@"原图" forState:UIControlStateNormal];
    originalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    originalBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
    [originalBtn setImage:[UIImage imageFromColor:[UIColor redColor] size:CGSizeMake(16, 16)] forState:UIControlStateSelected];
    [originalBtn setImage:[UIImage imageFromColor:[UIColor greenColor] size:CGSizeMake(16, 16)] forState:UIControlStateNormal];
    [originalBtn addTarget:self action:@selector(selectedOriginImage:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:originalBtn];
    [originalBtn setExtendedHitArea:CGRectMake(0, 10, 0, 10)];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-64-kPreviewCellMargin, 10, 64, 26)];
    [sendBtn setExtendedHitArea:CGRectMake(0, 10, 0, 10)];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"343434"] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sendBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn = sendBtn;
    [containerView addSubview:sendBtn];
}

- (void)setAllowPickOriginalImage:(BOOL)allowPickOriginalImage {
    _allowPickOriginalImage = allowPickOriginalImage;
    self.originalBtn.hidden = !self.allowPickOriginalImage;
}

- (void)selectedOriginImage:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.originalBtnOnClick) {
        self.originalBtnOnClick(btn.selected);
    }
}

- (void)done:(UIButton *)btn {
    if (self.doneBtnOnClick) {
        self.doneBtnOnClick();
    }
}

- (void)refreshBottomView:(NSArray<ZHAssetModel *> *)selecteAssets isOriginal:(BOOL)isOriginal {
    self.sendBtn.enabled = selecteAssets.count > 0;
    self.originalBtn.selected = isOriginal;
    [self.sendBtn setTitle:selecteAssets.count>0?[NSString stringWithFormat:@"发送(%@)",@(selecteAssets.count)]:@"发送" forState:UIControlStateNormal];
}

@end
