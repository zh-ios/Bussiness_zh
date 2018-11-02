//
//  ZHAlbumController.h
//  ZHProject
//
//  Created by zh on 2018/8/3.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAssetsModel.h"

@interface ZHAlbumCell : UITableViewCell

@property (nonatomic, strong) ZHAlbumModel *album;

@end


@interface ZHAlbumController : UIViewController


@property (nonatomic, strong) NSArray<ZHAlbumModel *> *albums;


@end
