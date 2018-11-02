//
//  ZHProjectDefine.h
//  ZHProject
//
//  Created by zh on 2018/7/26.
//  Copyright © 2018年 autohome. All rights reserved.
//

#ifndef ZHProjectDefine_h
#define ZHProjectDefine_h


#define kIsIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kNavbarHeight (kIsIphoneX ? 88 : 64)
#define kTabbarHeight (kIsIphoneX ? 83 : 49)
// 底部的安全距离
#define kBottomSafeArea     (kIsIphoneX ? 35 : 0)

// 顶部的安全距离,包括状态栏的高度
#define kTopSafeArea        (kIsIphoneX ? 44 : 20)

#define kStatusBarHeight    ([[UIApplication sharedApplication] statusBarFrame].size.heigh)

// iphoneX 顶部多出的距离
#define kTopInsetAreaOfIphoneX      (kIsIphoneX ? (kTopSafeArea-20) : 0) 

#define kRandomColor            [UIColor colorWithRed:arc4random_uniform(125)/255.0 green:arc4random_uniform(125)/255.0 blue:arc4random_uniform(125)/255.0 alpha:0.7]

#endif /* ZHProjectDefine_h */
