//
//  UIImage+ImagePicerBundle.m
//  ZHProject
//
//  Created by zh on 2018/8/10.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "UIImage+ImagePicerBundle.h"

@implementation UIImage (ImagePicerBundle)

+ (UIImage *)imageFromImagePickerBundleNamed:(NSString *)name {
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"zhimagepicker" ofType:@"bundle"];
    
    NSBundle *imageBundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *imagePath = [imageBundle pathForResource:name ofType:nil];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
