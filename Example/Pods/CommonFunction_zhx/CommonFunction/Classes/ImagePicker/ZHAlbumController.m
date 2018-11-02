//
//  ZHAlbumController.m
//  ZHProject
//
//  Created by zh on 2018/8/3.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHAlbumController.h"
#import "ZHMediaFetcher.h"
#import "ZHPhotoPickerController.h"
#import "UIImage+ImagePicerBundle.h"
#import "ZHImagePickerConst.h"
#import "ZHImagePickerController.h"
#import "CommonFunctionPrefixHeader.h"


@interface ZHAlbumCell ()
@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *countL;
@end

@implementation ZHAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.width = [UIScreen mainScreen].bounds.size.width;
    
    UIImageView *posterImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
    posterImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:posterImage];
    posterImage.clipsToBounds = YES;
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(posterImage.right+10, 31, 200, 21)];
    nameL.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:nameL];
    
    UILabel *countL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.left, 56, 200, 17)];
    countL.font = [UIFont systemFontOfSize:12];
    countL.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self.contentView addSubview:countL];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-40, (self.height-20)/2, 20, 20)];
    [self.contentView addSubview:arrow];
    arrow.image = [UIImage imageFromImagePickerBundleNamed:@"icon_arrow_right"];
    
    self.posterImageView = posterImage;
    self.nameL = nameL;
    self.countL = countL;
}

- (void)setAlbum:(ZHAlbumModel *)album {
    _album = album;
    
    [[ZHMediaFetcher shareFetcher] getPosterImageForAlbumModel:album completion:^(UIImage *image, NSDictionary *info) {
        self.posterImageView.image = image;
    }];
    self.nameL.text = album.name;
    
    self.countL.text = [NSString stringWithFormat:@"（%@）张",@(album.count)];
}

@end


@interface ZHAlbumController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZHAlbumController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, self.view.width, self.view.height-kNavbarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 104;
    }
    return _tableView;
}


- (void)setAlbums:(NSArray<ZHAlbumModel *> *)albums {
    _albums = albums;
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    [self initCustomNav];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ZHImagePickerController *imagePickerVC = (ZHImagePickerController *)self.navigationController;
    [[ZHMediaFetcher shareFetcher] getAlbumsAllowPickVideo:imagePickerVC.allowPickVideo pickImage:imagePickerVC.allowPickImage completion:^(NSArray<ZHAlbumModel *> *albums) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.albums = albums;
            [self.tableView reloadData];
        });
    }];
}

- (void)initCustomNav {
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kNavbarHeight)];
    navView.backgroundColor = kImagePickerNavBgColor;
    [self.view addSubview:navView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(100, kTopSafeArea+10, self.view.width-100*2, 16)];
    titleL.font = kImagePickerNavTitleFont;
    titleL.textColor = kImagePickerNavTextColor;
    titleL.text = @"照片";
    titleL.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleL];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-60, kTopSafeArea+10, 60, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cancelBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *albumCellID = @"albumCellID";
    ZHAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:albumCellID];
    if (!cell) {
        cell = [[ZHAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:albumCellID];
    }
    ZHAlbumModel *model = self.albums[indexPath.row];
    cell.album = model;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZHPhotoPickerController *photoPicker = [[ZHPhotoPickerController alloc] init];
    ZHAlbumModel *album = self.albums[indexPath.row];
    photoPicker.album = album;
    [self.navigationController pushViewController:photoPicker animated:YES];
}

#pragma mark --- targetAction
- (void)cancel:(UIButton *)btn {
    ZHImagePickerController *picker = (ZHImagePickerController *)self.navigationController;
    if ([picker.pickerDelegate respondsToSelector:@selector(imagePickerControllerCancelBtnOnClick)]) {
        [picker.pickerDelegate imagePickerControllerCancelBtnOnClick];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"---- 相册页面销毁了");
#endif
}

@end
